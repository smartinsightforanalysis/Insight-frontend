import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:insight/services/api_service.dart';
import 'package:insight/services/user_session.dart';
import 'package:insight/services/firebase_auth_service.dart';
import 'package:insight/services/simple_google_auth.dart';
import '../widgets/forgot_password_modal.dart';
import '../widgets/save_info_modal.dart';
import 'onboarding_screen.dart';
import 'signup.dart';
import 'admin_dashboard.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final ApiService _apiService = ApiService();
  final FirebaseAuthService _firebaseAuthService = FirebaseAuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isGoogleSignInLoading = false;
  String? _selectedRole;

  // Error state variables
  String? _roleError;
  String? _emailError;
  String? _passwordError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _navigateToDashboard() {
    if (_selectedRole == null) {
      setState(() {
        _roleError = 'Please select a role';
      });
      return;
    }
    final dashboard = AdminDashboard(userRole: _selectedRole!);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => dashboard),
    );
  }

  Future<void> _handleLogin() async {
    setState(() {
      _roleError = _selectedRole == null ? 'Please select a role' : null;
      _emailError = _emailController.text.isEmpty
          ? 'Please enter your email'
          : null;
      _passwordError = _passwordController.text.isEmpty
          ? 'Please enter your password'
          : null;
    });
    if (_roleError != null || _emailError != null || _passwordError != null) {
      return;
    }
    try {
      final response = await _apiService.loginUser(
        _emailController.text,
        _passwordController.text,
        _selectedRole!,
      );

      // Save user session
      await UserSession.instance.saveUserSession(
        user: response['user'],
        token: response['token'],
      );

      _navigateToDashboard();
    } catch (e) {
      String errorMessage = e.toString();
      String userFriendlyMessage;

      // Check for explicit network-related errors
      if (errorMessage.contains('Network') ||
          errorMessage.contains('Failed host lookup')) {
        userFriendlyMessage =
            'Network error. Please check your internet connection.';
      }
      // Check for the specific error message the user is still seeing for incorrect credentials
      else if (errorMessage.contains('Login service unavailable')) {
        userFriendlyMessage = 'Incorrect email or password. Please try again.';
      }
      // For all other errors, including API-specific errors like 401, 404, or generic exceptions,
      // display a general "Incorrect credentials" message for security and user-friendliness.
      else {
        userFriendlyMessage = 'Incorrect email or password. Please try again.';
      }

      setState(() {
        _passwordError = userFriendlyMessage;
      });
    }
  }

  Future<void> _testSimpleGoogleSignIn() async {
    if (_selectedRole == null) {
      setState(() {
        _roleError = 'Please select a role before testing Google Sign-In';
      });
      return;
    }

    setState(() {
      _isGoogleSignInLoading = true;
      _roleError = null;
      _emailError = null;
      _passwordError = null;
    });

    try {
      final account = await SimpleGoogleAuth.signIn();
      if (account != null) {
        setState(() {
          _passwordError =
              'Simple Google Sign-In successful! Email: ${account.email}';
        });
      }
    } catch (e) {
      setState(() {
        _passwordError = 'Simple Google Sign-In failed: $e';
      });
    } finally {
      setState(() {
        _isGoogleSignInLoading = false;
      });
    }
  }

  Future<void> _handleGoogleSignIn() async {
    // Check if role is selected
    if (_selectedRole == null) {
      setState(() {
        _roleError = 'Please select a role before signing in with Google';
      });
      return;
    }

    setState(() {
      _isGoogleSignInLoading = true;
      _roleError = null;
      _emailError = null;
      _passwordError = null;
    });

    try {
      // Sign in with Google
      final userCredential = await _firebaseAuthService.signInWithGoogle();

      if (userCredential == null) {
        setState(() {
          _isGoogleSignInLoading = false;
        });
        return; // User canceled sign-in
      }

      final user = userCredential.user!;

      // Try to sign in with existing account
      try {
        final response = await _apiService.googleSignIn(
          user.uid,
          user.email!,
          user.displayName ?? user.email!.split('@')[0],
          _selectedRole!,
          user.photoURL,
        );

        // Save user session
        await UserSession.instance.saveUserSession(
          user: response['user'],
          token: response['token'],
        );

        _navigateToDashboard();
      } catch (e) {
        // If sign-in fails, handle different scenarios
        String errorMessage = e.toString();
        String userFriendlyMessage = 'Google sign-in failed. Please try again.';

        if (errorMessage.contains('different role')) {
          userFriendlyMessage =
              'An account with this email exists but with a different role. Please try logging in with your correct role, or sign up with a different email.';
        } else if (errorMessage.contains('No account found')) {
          userFriendlyMessage =
              'No account found with this Google account and role. Please sign up first.';
        } else if (errorMessage.contains('already linked')) {
          userFriendlyMessage =
              'This Google account is already linked to another user. Please try logging in with your existing account.';
        } else if (errorMessage.contains('Network')) {
          userFriendlyMessage =
              'Network error during Google sign-in. Please check your internet connection.';
        }

        setState(() {
          _passwordError = userFriendlyMessage;
        });

        // Sign out from Firebase since login failed
        await _firebaseAuthService.signOut();
      }
    } catch (e) {
      String errorMessage = e.toString();
      String userFriendlyMessage = 'Google sign-in failed. Please try again.';

      if (errorMessage.contains('Network')) {
        userFriendlyMessage =
            'Network error during Google sign-in. Please check your internet connection.';
      } else if (errorMessage.contains('user_cancelled')) {
        userFriendlyMessage = 'Google sign-in was cancelled.';
      } else if (errorMessage.contains('firebase_auth')) {
        userFriendlyMessage =
            'Authentication error during Google sign-in. Please try again.';
      }

      setState(() {
        _passwordError = userFriendlyMessage;
      });
    } finally {
      setState(() {
        _isGoogleSignInLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.white, size: 40.0),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Login',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 24.0,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF209A9F), // Adjust color to match image
      ),
      backgroundColor: const Color(0xFF209A9F),
      body: Column(
        children: [
          const SizedBox(height: 20.0),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF4F7FB),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.0),
                  topRight: Radius.circular(24.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              'Select Role',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF374151),
                              ),
                            ),
                            const SizedBox(height: 8),
                            DropdownButtonFormField<String>(
                              hint: Text(
                                'Select your role',
                                style: TextStyle(color: Color(0xFFADAEBC)),
                              ),
                              value: _selectedRole,
                              decoration: InputDecoration(
                                hintStyle: TextStyle(color: Color(0xFFADAEBC)),
                                prefixIcon: const Icon(
                                  Icons.person_outline,
                                  color: Color(0xFF9CA3AF),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: BorderSide(
                                    color: Color(0xFFADAEBC),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: BorderSide(
                                    color: Color(0xFFADAEBC),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: BorderSide(
                                    color: Color(0xFFADAEBC),
                                  ),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                              items: const [
                                DropdownMenuItem<String>(
                                  value: 'admin',
                                  child: Text('Admin'),
                                ),
                                DropdownMenuItem<String>(
                                  value: 'supervisor',
                                  child: Text('Supervisor'),
                                ),
                                DropdownMenuItem<String>(
                                  value: 'auditor',
                                  child: Text('Auditor'),
                                ),
                              ],
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedRole = newValue;
                                  _roleError = null;
                                });
                              },
                            ),
                            if (_roleError != null)
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 4.0,
                                  bottom: 8.0,
                                ),
                                child: Text(
                                  _roleError!,
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            const SizedBox(height: 24),
                            const Text(
                              'Email',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF374151),
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                hintText: 'Enter your email',
                                hintStyle: TextStyle(color: Color(0xFFADAEBC)),
                                prefixIcon: const Icon(
                                  Icons.email_outlined,
                                  color: Color(0xFF9CA3AF),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: BorderSide(
                                    color: Color(0xFFADAEBC),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: BorderSide(
                                    color: Color(0xFFADAEBC),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: BorderSide(
                                    color: Color(0xFFADAEBC),
                                  ),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                              keyboardType: TextInputType.emailAddress,
                              onChanged: (_) {
                                if (_emailError != null)
                                  setState(() => _emailError = null);
                              },
                            ),
                            if (_emailError != null)
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 4.0,
                                  bottom: 8.0,
                                ),
                                child: Text(
                                  _emailError!,
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            const SizedBox(height: 24),
                            const Text(
                              'Password',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF374151),
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _passwordController,
                              decoration: InputDecoration(
                                hintText: 'Enter your password',
                                hintStyle: TextStyle(color: Color(0xFFADAEBC)),
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: SvgPicture.asset(
                                    'assets/password.svg',
                                    width: 24.0,
                                    height: 24.0,
                                    colorFilter: ColorFilter.mode(
                                      Color(0xFF9CA3AF),
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isPasswordVisible
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    color: Color(0xFF9CA3AF),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isPasswordVisible = !_isPasswordVisible;
                                    });
                                  },
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: BorderSide(
                                    color: Color(0xFFADAEBC),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: BorderSide(
                                    color: Color(0xFFADAEBC),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: BorderSide(
                                    color: Color(0xFFADAEBC),
                                  ),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                              obscureText: !_isPasswordVisible,
                              onChanged: (_) {
                                if (_passwordError != null)
                                  setState(() => _passwordError = null);
                              },
                            ),
                            if (_passwordError != null)
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 4.0,
                                  bottom: 8.0,
                                ),
                                child: Text(
                                  _passwordError!,
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            const SizedBox(height: 8),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  _showForgotPasswordModal(context);
                                },
                                child: const Text('Forgot Password?'),
                                style: TextButton.styleFrom(
                                  foregroundColor: const Color(0xFF209A9F),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton(
                              onPressed: _handleLogin,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF209A9F),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16.0,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              child: const Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Expanded(
                                  flex: 2,
                                  child: Divider(
                                    thickness: 1,
                                    color: Color(0xFFE5E7EB),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 24.0,
                                  ),
                                  child: Text(
                                    'or',
                                    style: TextStyle(
                                      color: Color(0xFF9CA3AF),
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Divider(
                                    thickness: 1,
                                    color: Color(0xFFE5E7EB),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            OutlinedButton(
                              onPressed: _isGoogleSignInLoading
                                  ? null
                                  : _handleGoogleSignIn,
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16.0,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                backgroundColor: const Color(
                                  0xFFEFEFEF,
                                ), // Change background color
                                side: BorderSide.none, // Remove border
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (_isGoogleSignInLoading)
                                    const SizedBox(
                                      width: 24.0,
                                      height: 24.0,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.0,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Color(0xFF434343),
                                            ),
                                      ),
                                    )
                                  else
                                    Image.asset(
                                      'assets/google_logo.png',
                                      height: 24.0,
                                    ), // Use Google logo asset
                                  const SizedBox(width: 8),
                                  Text(
                                    _isGoogleSignInLoading
                                        ? 'Signing in...'
                                        : 'Continue with Google',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Color(0xFF434343),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 24.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don't have an account?",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignupScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              'Signup',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            style: TextButton.styleFrom(
                              foregroundColor: const Color(0xFF209A9F),
                              padding: EdgeInsets.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showForgotPasswordModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const ForgotPasswordModal(),
    );
  }

  void _showSaveInfoModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const SaveInfoModal(),
    );
  }
}
