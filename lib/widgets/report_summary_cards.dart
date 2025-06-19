import 'package:flutter/material.dart';

class ReportSummaryCards extends StatelessWidget {
  final String selectedPeriod;
  final String reportType;

  const ReportSummaryCards({
    Key? key,
    required this.selectedPeriod,
    required this.reportType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildSummaryCard(
              title: 'Positive',
              value: '24',
              backgroundColor: const Color(0xFFEBFDF5),
              textColor: const Color(0xFF059669),
              icon: Icons.check,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildSummaryCard(
              title: 'Neutral',
              value: '15',
              backgroundColor: const Color(0xFFFFFBEB),
              textColor: const Color(0xFFD97706),
              icon: Icons.remove,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildSummaryCard(
              title: 'Negative',
              value: '8',
              backgroundColor: const Color(0xFFFEF2F2),
              textColor: const Color(0xFFDC2626),
              icon: Icons.warning,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required Color backgroundColor,
    required Color textColor,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: title == 'Positive'
            ? Border.all(color: const Color(0xFFD1FAE5), width: 1)
            : title == 'Neutral'
                ? Border.all(color: const Color(0xFFFEF3C7), width: 1)
                : title == 'Negative'
                    ? Border.all(color: const Color(0xFFFEE2E2), width: 1)
                    : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: textColor,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: title == 'Positive' ? FontWeight.w500 : FontWeight.w500,
              color: title == 'Positive' ? const Color(0xFF059669) : title == 'Neutral' ? const Color(0xFFD97706) : title == 'Negative' ? const Color(0xFFDC2626) : textColor,
            ),
          ),
        ],
      ),
    );
  }
}
