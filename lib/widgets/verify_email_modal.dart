import 'package:flutter/material.dart';
import 'package:insight/view/forget_password.dart';
import 'package:insight/view/admin_dashboard.dart';

class VerifyEmailModal extends StatefulWidget {
  final Widget? nextScreen;
  final bool isSignupContext;
  final String? selectedRole;

  const VerifyEmailModal({
    Key? key, 
    this.nextScreen, 
    this.isSignupContext = false,
    this.selectedRole,
  }) : super(key: key);

  @override
  State<VerifyEmailModal> createState() => _VerifyEmailModalState();
}

class _VerifyEmailModalState extends State<VerifyEmailModal> {
  // Controllers for the four digit inputs
  final TextEditingController _field1Controller = TextEditingController();
  final TextEditingController _field2Controller = TextEditingController();
  final TextEditingController _field3Controller = TextEditingController();
  final TextEditingController _field4Controller = TextEditingController();

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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a role')),
      );
      return;
    }

    // All roles now go to AdminDashboard with the selected role passed as parameter
    final dashboard = AdminDashboard(userRole: widget.selectedRole!);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => dashboard),
    );
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
                width: MediaQuery.of(context).size.width * 0.3, // 60% of screen width (approx modal width)
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
            const SizedBox(height: 32),

            // Continue button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Implement verification logic
                  Navigator.of(context).pop();
                  if (widget.isSignupContext) {
                    _navigateToDashboard();
                  } else if (widget.nextScreen != null) {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => widget.nextScreen!));
                  }
                },
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
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          }
        },
      ),
    );
  }
} 