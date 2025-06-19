import 'package:flutter/material.dart';

class SaveInfoModal extends StatelessWidget {
  const SaveInfoModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF4F7FB), // Using the same background color as the login form
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
          crossAxisAlignment: CrossAxisAlignment.stretch, // Change to stretch for full-width buttons
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
            const SizedBox(height: 32), // Increased spacing
            
            const Text(
              'Save Your Information',
              style: TextStyle(
                fontSize: 24, // Increased font size for title
                fontWeight: FontWeight.w600, // Adjusted font weight
                color: Color(0xFF111827), // Adjusted color
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Click here to save your information for future.',
              style: TextStyle(
                fontSize: 16, // Increased font size for subtitle
                fontWeight: FontWeight.w400, // Adjusted font weight
                color: Color(0xFF6B7280), // Adjusted color
              ),
            ),
            const SizedBox(height: 32), // Increased spacing
            
            SizedBox( // Wrap button in SizedBox for full width
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Implement save logic
                  Navigator.pop(context); // Close the modal
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF209A9F), // Using the same button color as the login button
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  elevation: 0, // Removed elevation
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w600), // Adjusted font weight
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox( // Wrap button in SizedBox for full width
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  // TODO: Implement skip logic
                  Navigator.pop(context); // Close the modal
                },
                child: const Text('Skip'),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF209A9F), // Using the same color as the forgot password/signup links
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 