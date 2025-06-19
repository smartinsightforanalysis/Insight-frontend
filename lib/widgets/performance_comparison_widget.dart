import 'package:flutter/material.dart';

class PerformanceComparisonWidget extends StatelessWidget {
  final int avgDailyScore;
  final int workTimePercentage;

  const PerformanceComparisonWidget({
    Key? key,
    required this.avgDailyScore,
    required this.workTimePercentage,
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
            'Performance Comparison',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1C3557),
            ),
          ),
          const SizedBox(height: 16),
          
          // Work Hours Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Work Hours',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF4B5563),
                ),
              ),
              const Text(
                '+12%',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF209A9F),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          
          // Progress Bar for Work Hours
          Stack(
            children: [
              // Background bar
              Container(
                height: 8,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              // Filled bar
              FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: avgDailyScore / 100,
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: const Color(0xFF16A3AC),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Break Time Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Break Time',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF4B5563),
                ),
              ),
              const Text(
                '-8%',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF209A9F),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          
          // Progress Bar for Break Time
          Stack(
            children: [
              // Background bar
              Container(
                height: 8,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              // Filled bar
              FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: workTimePercentage / 100,
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: const Color(0xFF16A3AC),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
