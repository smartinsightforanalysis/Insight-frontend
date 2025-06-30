import 'package:flutter/material.dart';
import 'package:insight/services/api_service.dart';
import 'package:insight/view/forget_password.dart';
import 'package:insight/view/admin_dashboard.dart';
import 'package:insight/view/login.dart';

class VerifyEmailModal extends StatefulWidget {
  final Widget? nextScreen;
  final bool isSignupContext;
  final String? selectedRole;
  final String? email;
  final String? name;
  final String? password;
  final String? phoneNumber; // Added phoneNumber

  const VerifyEmailModal({
    Key? key,
    this.nextScreen,
    this.isSignupContext = false,
    this.selectedRole,
    this.email,
    this.name,
    this.password,
    this.phoneNumber, // Added phoneNumber to constructor
  }) : super(key: key);

  @override
  State<VerifyEmailModal> createState() => _VerifyEmailModalState();
}

class _VerifyEmailModalState extends State<VerifyEmailModal> {
  final ApiService _apiService = ApiService();
  final TextEditingController _field1Controller = TextEditingController();
  final TextEditingController _field2Controller = TextEditingController();
  final TextEditingController _field3Controller = TextEditingController();
  final TextEditingController _field4Controller = TextEditingController();

  String? _otpError;

  @override
  void dispose() {
    _field1Controller.dispose();
    _field2Controller.dispose();
    _field3Controller.dispose();
    _field4Controller.dispose();
    super.dispose();
  }

  void _navigateToDashboard() {
    if (widget.selectedRole == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a role')));
      return;
    }

    final dashboard = AdminDashboard(userRole: widget.selectedRole!);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => dashboard),
    );
  }

  void _showSuccessAndNavigateToLogin() {
    // Close the modal first
    Navigator.of(context).pop();

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Signup successful! Please log in.'),
        backgroundColor: Color(0xFF209A9F),
        duration: Duration(seconds: 3),
      ),
    );

    // Navigate to login screen, clearing all previous routes
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (Route<dynamic> route) => false,
    );
  }

  Future<void> _handleVerifyOtp() async {
    final otp =
        _field1Controller.text +
        _field2Controller.text +
        _field3Controller.text +
        _field4Controller.text;
    if (otp.length != 4) {
      setState(() {
        _otpError = 'Please enter the complete OTP';
      });
      return;
    }

    try {
      if (widget.isSignupContext) {
        await _apiService.verifyOTPAndRegister(
          widget.email!,
          otp,
          widget.name!,
          widget.password!,
          widget.selectedRole!,
          widget.phoneNumber, // Now optional, can be null
        );
        _showSuccessAndNavigateToLogin();
      } else {
        await _apiService.verifyOtp(widget.email!, otp);
        Navigator.of(context).pop();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ForgetPasswordScreen(email: widget.email!),
          ),
        );
      }
    } catch (e) {
      setState(() {
        // Show the actual error message from the backend
        String errorMessage = e.toString();
        String userFriendlyMessage = "Invalid OTP"; // Default message

        if (errorMessage.contains('HTTP 400: Bad Request')) {
          userFriendlyMessage = "Invalid OTP. Please try again.";
        } else if (errorMessage.contains('Network')) {
          userFriendlyMessage =
              "Network error. Please check your internet connection.";
        } else if (errorMessage.startsWith('Exception: ')) {
          errorMessage = errorMessage.substring(
            11,
          ); // Remove "Exception: " prefix
          userFriendlyMessage = errorMessage.isNotEmpty
              ? errorMessage
              : "Invalid OTP. Please try again.";
        }
        _otpError = userFriendlyMessage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF4F7FB),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: 24.0,
          right: 24.0,
          top: 16.0,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24.0,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width:
                    MediaQuery.of(context).size.width *
                    0.3, // 60% of screen width (approx modal width)
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.black, // Changed color to black
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Title
            const Text(
              'Verify Your Email',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 8),

            // Subtitle
            const Text(
              'Enter the 4-digit code sent to your email',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 32),

            // Code input fields
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCodeInputField(_field1Controller),
                _buildCodeInputField(_field2Controller),
                _buildCodeInputField(_field3Controller),
                _buildCodeInputField(_field4Controller),
              ],
            ),
            // Show error message below OTP fields
            if (_otpError != null)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Center(
                  child: Text(
                    _otpError!,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 32),

            // Continue button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _handleVerifyOtp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF209A9F),
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  widget.isSignupContext ? 'Verify' : 'Continue',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            // Add Change Email button conditionally
            if (widget.isSignupContext)
              Center(
                child: TextButton(
                  onPressed: () {
                    // TODO: Implement change email logic
                    Navigator.of(context).pop(); // Close the modal
                    // Potentially navigate back to a screen where email can be changed, or show a different modal
                  },
                  child: const Text('Change Email?'),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF209A9F),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildCodeInputField(TextEditingController controller) {
    return SizedBox(
      width: 60,
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        decoration: InputDecoration(
          counterText: "", // Hide counter text
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
            borderSide: const BorderSide(color: Color(0xFF209A9F)),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
        onChanged: (value) {
          if (_otpError != null) {
            setState(() {
              _otpError = null;
            });
          }
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          }
        },
      ),
    );
  }
}
