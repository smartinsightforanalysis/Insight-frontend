import 'package:flutter/material.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.white, size: 40.0),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text('Forget Password', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 24.0)),
        centerTitle: true,
        backgroundColor: const Color(0xFF209A9F),
      ),
      backgroundColor: const Color(0xFF209A9F), // Set background to teal
      body: Column(
        children: [
          const SizedBox(height: 20.0), // Add some spacing from the app bar
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: const Color(0xFFF4F7FB),
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
                    const Text(
                      'New Password',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF374151)),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Enter new password',
                        hintStyle: const TextStyle(color: Color(0xFFADAEBC)),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isNewPasswordVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                            color: const Color(0xFF9CA3AF),
                          ),
                          onPressed: () {
                            setState(() {
                              _isNewPasswordVisible = !_isNewPasswordVisible;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(color: Color(0xFFADAEBC)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(color: Color(0xFFADAEBC)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(color: Color(0xFFADAEBC)),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      obscureText: !_isNewPasswordVisible,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Confirm New Password',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF374151)),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Confirm new password',
                        hintStyle: const TextStyle(color: Color(0xFFADAEBC)),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isConfirmPasswordVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                            color: const Color(0xFF9CA3AF),
                          ),
                          onPressed: () {
                            setState(() {
                              _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(color: Color(0xFFADAEBC)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(color: Color(0xFFADAEBC)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(color: Color(0xFFADAEBC)),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      obscureText: !_isConfirmPasswordVisible,
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () {
                        // TODO: Implement update password logic
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF209A9F),
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: const Text(
                        'Update Password',
                        style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
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
