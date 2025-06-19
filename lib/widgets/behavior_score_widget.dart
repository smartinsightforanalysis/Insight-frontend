import 'package:flutter/material.dart';

class BehaviorScoreWidget extends StatelessWidget {
  final int productivityScore;
  final int attendanceScore;

  const BehaviorScoreWidget({
    Key? key,
    required this.productivityScore,
    required this.attendanceScore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Behavior Score',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1C3557),
            ),
          ),
          const SizedBox(height: 20),

          // Main Layout: Large Circle + Productivity/Attendance List
          Row(
            children: [
              // Large Main Score Circle
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF16A3AC),
                    width: 4,
                  ),
                  color: Colors.white,
                ),
                child: Center(
                  child: Text(
                    '$productivityScore%',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF16A3AC),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 24),

              // Productivity and Attendance List
              Expanded(
                child: Column(
                  children: [
                    // Productivity Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Productivity',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF4B5563),
                          ),
                        ),
                        Text(
                          '95%',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF16A3AC),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Attendance Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Attendance',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF4B5563),
                          ),
                        ),
                        Text(
                          '$attendanceScore%',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF16A3AC),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
