import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RecentBehavioursWidget extends StatelessWidget {
  const RecentBehavioursWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Behaviours',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1C3557),
                ),
              ),
              TextButton(
                onPressed: () {
                  // Handle View All tap
                },
                child: const Text(
                  'View All',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF209A9F), // Blue color
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildBehaviourCard(
          'Zoya Ahmed',
          'Excellent customer service provided',
          '2:30 PM',
          '#Front Desk',
          'AI Tag: Positive',
          const Color(0xFFDAFFDB), // Light green for positive
          const Color(0xFF059669), // Text color for positive tag
          const Color(0xFFD1FAE5), // Background color for positive tag
        ),
        const SizedBox(height: 16),
        _buildBehaviourCard(
          'Ali Raza',
          'Harassment behavior detected at Kitchen',
          '2:42 PM',
          '#Service area',
          'AI Tag: Negative',
          const Color(0xFFFEF2F2), // Light red for negative
          const Color(0xFFDC2626), // Text color for negative tag
          const Color(0xFFFEE2E2), // Background color for negative tag
        ),
        const SizedBox(height: 16),
        _buildBehaviourCard(
          'Sarah Khan',
          'Extended break time observed',
          '1:15 PM',
          '#Rest area',
          'AI Tag: Neutral',
          const Color(0xFFEFEFEF), // Card background color
          const Color(0xFFD97706), // Text color for negative tag
          const Color(0xFFFEF3C7), // Background color for negative tag
        ),
      ],
    );
  }

  Widget _buildBehaviourCard(
    String name,
    String description,
    String time,
    String tag1,
    String tag2,
    Color cardColor,
    Color tag2Color,
    Color tag2BackgroundColor,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      elevation: 0,
      color: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1C3557),
                  ),
                ),
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xFF374151),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildTag(tag1, const Color(0xFFF3F4F6), const Color(0xFF4B5563)),
                const SizedBox(width: 8),
                _buildTag(tag2, tag2BackgroundColor, tag2Color),
                const SizedBox(width: 4),
                SvgPicture.asset('assets/photo.svg'), // Replaced with photo.svg
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String text, Color backgroundColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
    );
  }
} 