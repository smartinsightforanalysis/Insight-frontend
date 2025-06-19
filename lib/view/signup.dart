import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/forgot_password_modal.dart';
import '../widgets/save_info_modal.dart';
import 'onboarding_screen.dart';
import '../widgets/verify_email_modal.dart';
import 'admin_dashboard.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool _isPasswordVisible = false;
  bool _termsAccepted = false;
  String? _selectedRole;

  void _navigateToDashboard() {
    if (_selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a role')),
      );
      return;
    }

    // All roles now go to AdminDashboard with the selected role passed as parameter
    final dashboard = AdminDashboard(userRole: _selectedRole!);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => dashboard),
    );
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
        title: const Text('Signup', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 24.0)),
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
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF374151)),
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
                        prefixIcon: const Icon(Icons.person_outline, color: Color(0xFF9CA3AF)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(color: Color(0xFFADAEBC)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(color: Color(0xFFADAEBC)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(color: Color(0xFFADAEBC)),
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
                        });
                      },
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Full Name',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF374151)),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Enter your full name',
                        hintStyle: TextStyle(color: Color(0xFFADAEBC)),
                        prefixIcon: const Icon(Icons.person_outline, color: Color(0xFF9CA3AF)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(color: Color(0xFFADAEBC)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(color: Color(0xFFADAEBC)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(color: Color(0xFFADAEBC)),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Email',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF374151)),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Enter your email',
                        hintStyle: TextStyle(color: Color(0xFFADAEBC)),
                        prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFF9CA3AF)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(color: Color(0xFFADAEBC)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(color: Color(0xFFADAEBC)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(color: Color(0xFFADAEBC)),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Password',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF374151)),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Enter your password',
                        hintStyle: TextStyle(color: Color(0xFFADAEBC)),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: SvgPicture.asset(
                            'assets/password.svg',
                            width: 24.0,
                            height: 24.0,
                            colorFilter: ColorFilter.mode(Color(0xFF9CA3AF), BlendMode.srcIn),
                          ),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
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
                          borderSide: BorderSide(color: Color(0xFFADAEBC)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(color: Color(0xFFADAEBC)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(color: Color(0xFFADAEBC)),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      obscureText: !_isPasswordVisible,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Confirm Password',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF374151)),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Confirm your password',
                        hintStyle: TextStyle(color: Color(0xFFADAEBC)),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: SvgPicture.asset(
                            'assets/password.svg',
                            width: 24.0,
                            height: 24.0,
                            colorFilter: ColorFilter.mode(Color(0xFF9CA3AF), BlendMode.srcIn),
                          ),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
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
                          borderSide: BorderSide(color: Color(0xFFADAEBC)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(color: Color(0xFFADAEBC)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(color: Color(0xFFADAEBC)),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      obscureText: !_isPasswordVisible,
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
                            });
                          },
                          fillColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                            if (states.contains(MaterialState.selected)) {
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
                                style: const TextStyle(fontSize: 14, color: Color(0xFF434343), fontWeight: FontWeight.bold),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'terms and Privacy policy',
                                    style: const TextStyle(),
                                  ),
                                  TextSpan(
                                    text: '  ',
                                  ),
                                  TextSpan(
                                    text: 'Read',
                                    style: const TextStyle(color: Color(0xFF209A9F), fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_selectedRole == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please select a role')),
                          );
                          return;
                        }
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => VerifyEmailModal(
                            isSignupContext: true,
                            selectedRole: _selectedRole,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF209A9F),
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: const Text(
                        'Signup',
                        style: TextStyle(fontSize: 18, color: Colors.white),
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
                          padding: EdgeInsets.symmetric(horizontal: 24.0),
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
                      onPressed: () {
                        // TODO: Implement Google sign-in
                      },
                      style: OutlinedButton.styleFrom(
                         padding: const EdgeInsets.symmetric(vertical: 16.0),
                         shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        backgroundColor: const Color(0xFFEFEFEF),
                        side: BorderSide.none,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/google_logo.png', height: 24.0),
                          const SizedBox(width: 8),
                          const Text(
                            'Continue with Google',
                            style: TextStyle(fontSize: 18, color: Color(0xFF434343), fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 24.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Already have an account?", style: TextStyle(fontWeight: FontWeight.bold)),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Login', style: TextStyle(fontWeight: FontWeight.bold)),
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
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
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
