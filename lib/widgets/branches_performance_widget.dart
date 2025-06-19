import 'package:flutter/material.dart';

class BranchesPerformanceWidget extends StatelessWidget {
  const BranchesPerformanceWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: const Text(
            'Branches Performance',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1C3557),
            ),
          ),
        ),
        const SizedBox(height: 8),
        _buildEmployeeCard(
          'Branch A', 
          'Downtown', 
          88, 
          const Color(0xFF1E3A8A),
          0.9
        ),
        const SizedBox(height: 8),
        _buildEmployeeCard(
          'Branch B', 
          'Central', 
          84, 
          const Color(0xFF60A5FA),
          0.85
        ),
        const SizedBox(height: 8),
        _buildEmployeeCard(
          'Branch C', 
          'Zone 2', 
          82, 
          const Color(0xFFCBD5E1),
          0.82
        ),
        const SizedBox(height: 8),
        _buildEmployeeCard(
          'Branch D', 
          'Zone 4', 
          79, 
          const Color(0xFF9FD6A3),
          0.78
        ),
      ],
    );
  }

  Widget _buildEmployeeCard(
      String name,
      String location,
      int score,
      Color progressColor,
      double progressValue) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      elevation: 1,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Circle avatar with solid color
            CircleAvatar(
              radius: 25,
              backgroundColor: const Color(0xFFEAEAEA),
            ),
            const SizedBox(width: 16),
            // Name and location
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1C3557),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F0FE),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          location,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Color(0xFF1C3557),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Progress bar
                  Stack(
                    children: [
                      // Background bar
                      Container(
                        height: 8,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      // Progress
                      FractionallySizedBox(
                        widthFactor: progressValue,
                        child: Container(
                          height: 8,
                          decoration: BoxDecoration(
                            color: progressColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            // Score
            Text(
              score.toString(),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1C3557),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 