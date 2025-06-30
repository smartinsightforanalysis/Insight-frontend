import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:insight/services/api_service.dart';
import 'package:insight/services/firebase_auth_service.dart';
import 'package:insight/services/user_session.dart';
import '../widgets/verify_email_modal.dart';
import 'admin_dashboard.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final ApiService _apiService = ApiService();
  final FirebaseAuthService _firebaseAuthService = FirebaseAuthService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isPasswordVisible = false;
  bool _termsAccepted = false;
  bool _isGoogleSignUpLoading = false;
  String? _selectedRole;

  // Error state variables
  String? _roleError;
  String? _nameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;
  String? _termsError;

  void _navigateToDashboard() {
    final dashboard = AdminDashboard(userRole: _selectedRole!);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => dashboard),
    );
  }

  Future<void> _handleSignup() async {
    setState(() {
      _roleError = _selectedRole == null ? 'Please select a role' : null;
      _nameError = _nameController.text.isEmpty
          ? 'Please enter your name'
          : null;
      _emailError = _emailController.text.isEmpty
          ? 'Please enter your email'
          : null;
      _passwordError = _passwordController.text.isEmpty
          ? 'Please enter your password'
          : null;
      _confirmPasswordError = _confirmPasswordController.text.isEmpty
          ? 'Please confirm your password'
          : null;
      if (_passwordController.text != _confirmPasswordController.text &&
          _confirmPasswordError == null) {
        _confirmPasswordError = 'Passwords do not match';
      }
      _termsError = !_termsAccepted
          ? 'You must accept the terms and privacy policy'
          : null;
    });

    if (_roleError != null ||
        _nameError != null ||
        _emailError != null ||
        _passwordError != null ||
        _confirmPasswordError != null ||
        _termsError != null) {
      return;
    }

    try {
      await _apiService.sendOtp(_emailController.text);
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => VerifyEmailModal(
          isSignupContext: true,
          selectedRole: _selectedRole,
          email: _emailController.text,
          name: _nameController.text,
          password: _passwordController.text,
        ),
      );
    } catch (e) {
      String errorMessage = e.toString();
      String userFriendlyMessage =
          'Failed to send verification code. Please try again.';

      if (errorMessage.contains('email already exists')) {
        userFriendlyMessage =
            'This email is already registered. Please try logging in instead.';
      } else if (errorMessage.contains('Network')) {
        userFriendlyMessage =
            'Network error. Please check your internet connection.';
      }

      setState(() {
        _emailError = userFriendlyMessage;
      });
    }
  }

  Future<void> _handleGoogleSignUp() async {
    // Check if role is selected and terms are accepted
    setState(() {
      _roleError = _selectedRole == null ? 'Please select a role' : null;
      _termsError = !_termsAccepted
          ? 'You must accept the terms and privacy policy'
          : null;
    });

    if (_roleError != null || _termsError != null) {
      return;
    }

    setState(() {
      _isGoogleSignUpLoading = true;
      _roleError = null;
      _nameError = null;
      _emailError = null;
      _passwordError = null;
      _confirmPasswordError = null;
      _termsError = null;
    });

    try {
      // Sign in with Google
      final userCredential = await _firebaseAuthService.signInWithGoogle();

      if (userCredential == null) {
        setState(() {
          _isGoogleSignUpLoading = false;
        });
        return; // User canceled sign-in
      }

      final user = userCredential.user!;

      // Try to sign up with Google
      try {
        final response = await _apiService.googleSignUp(
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
        // If sign-up fails, handle different scenarios
        String errorMessage = e.toString();
        String userFriendlyMessage = 'Google sign-up failed. Please try again.';

        if (errorMessage.contains('already exists with role:')) {
          userFriendlyMessage =
              'An account with this email already exists. Please try logging in, or sign up with a different email.';
        } else if (errorMessage.contains('already linked')) {
          userFriendlyMessage =
              'This Google account is already linked to another user. Please try logging in with your existing account.';
        } else if (errorMessage.contains('Network')) {
          userFriendlyMessage =
              'Network error during Google sign-up. Please check your internet connection.';
        }

        setState(() {
          _emailError = userFriendlyMessage;
        });

        // Sign out from Firebase since signup failed
        await _firebaseAuthService.signOut();
      }
    } catch (e) {
      String errorMessage = e.toString();
      String userFriendlyMessage = 'Google sign-up failed. Please try again.';

      if (errorMessage.contains('Network')) {
        userFriendlyMessage =
            'Network error during Google sign-up. Please check your internet connection.';
      } else if (errorMessage.contains('user_cancelled')) {
        userFriendlyMessage = 'Google sign-up was cancelled.';
      } else if (errorMessage.contains('firebase_auth')) {
        userFriendlyMessage =
            'Authentication error during Google sign-up. Please try again.';
      }

      setState(() {
        _emailError = userFriendlyMessage;
      });
    } finally {
      setState(() {
        _isGoogleSignUpLoading = false;
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
          'Signup',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 24.0,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF209A9F),
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
                              'Full Name',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF374151),
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                hintText: 'Enter your full name',
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
                              onChanged: (_) {
                                if (_nameError != null)
                                  setState(() => _nameError = null);
                              },
                            ),
                            if (_nameError != null)
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 4.0,
                                  bottom: 8.0,
                                ),
                                child: Text(
                                  _nameError!,
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
                            const SizedBox(height: 24),
                            const Text(
                              'Confirm Password',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF374151),
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _confirmPasswordController,
                              decoration: InputDecoration(
                                hintText: 'Confirm your password',
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
                                if (_confirmPasswordError != null)
                                  setState(() => _confirmPasswordError = null);
                              },
                            ),
                            if (_confirmPasswordError != null)
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 4.0,
                                  bottom: 8.0,
                                ),
                                child: Text(
                                  _confirmPasswordError!,
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // TODO: Implement checkbox functionality
                                Checkbox(
                                  value: _termsAccepted,
                                  onChanged: (bool? newValue) {
                                    setState(() {
                                      _termsAccepted = newValue ?? false;
                                      if (_termsError != null && _termsAccepted)
                                        _termsError = null;
                                    });
                                  },
                                  fillColor:
                                      MaterialStateProperty.resolveWith<Color>((
                                        Set<MaterialState> states,
                                      ) {
                                        if (states.contains(
                                          MaterialState.selected,
                                        )) {
                                          return const Color(0xFF209A9F);
                                        }
                                        return const Color(0xFFD9D9D9);
                                      }),
                                  side: BorderSide.none,
                                  shape: CircleBorder(),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 14.0),
                                    child: RichText(
                                      text: TextSpan(
                                        text: 'I accept the ',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFF434343),
                                          fontWeight: FontWeight.bold,
                                        ),
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: 'terms and Privacy policy',
                                            style: const TextStyle(),
                                          ),
                                          TextSpan(text: '  '),
                                          TextSpan(
                                            text: 'Read',
                                            style: const TextStyle(
                                              color: Color(0xFF209A9F),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (_termsError != null)
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 4.0,
                                  bottom: 8.0,
                                ),
                                child: Text(
                                  _termsError!,
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ElevatedButton(
                              onPressed: _handleSignup,
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
                                'Signup',
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
                              onPressed: _isGoogleSignUpLoading
                                  ? null
                                  : _handleGoogleSignUp,
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16.0,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                backgroundColor: const Color(0xFFEFEFEF),
                                side: BorderSide.none,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (_isGoogleSignUpLoading)
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
                                    ),
                                  const SizedBox(width: 8),
                                  Text(
                                    _isGoogleSignUpLoading
                                        ? 'Signing up...'
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
                            Padding(
                              padding: const EdgeInsets.only(top: 24.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Already have an account?",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      'Login',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    style: TextButton.styleFrom(
                                      foregroundColor: const Color(0xFF209A9F),
                                      padding: EdgeInsets.zero,
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
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
}
