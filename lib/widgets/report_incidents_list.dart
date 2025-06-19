import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ReportIncidentsList extends StatelessWidget {
  final String selectedPeriod;
  final String reportType;

  const ReportIncidentsList({
    Key? key,
    required this.selectedPeriod,
    required this.reportType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildSectionHeader('Negative', '02'),
          const SizedBox(height: 12),
          _buildIncidentItem(
            icon: 'assets/onb2.svg',
            title: 'Fight Detected',
            subtitle: 'Altercation at Checkout Zone',
            time: '2 mins ago',
            severity: 'Critical',
            severityColor: const Color(0xFFD32F2F),
            borderColor: const Color(0xFFD32F2F),
          ),
          const SizedBox(height: 12),
          _buildIncidentItem(
            icon: 'assets/onb2.svg',
            title: 'Harassment Alert',
            subtitle: '85% AI confidence, Kitchen Zone',
            time: '15 mins ago',
            severity: 'Critical',
            severityColor: const Color(0xFFD32F2F),
            borderColor: const Color(0xFFD32F2F),
          ),
          const SizedBox(height: 24),
          _buildSectionHeader('Neutral', '02'),
          const SizedBox(height: 12),
          _buildIncidentItem(
            icon: 'assets/onb2.svg',
            title: 'Phone Usage',
            subtitle: 'Detected during work hours',
            time: '30 mins ago',
            severity: 'Warning',
            severityColor: const Color(0xFFE65100),
            borderColor: const Color(0xFFE65100),
          ),
          const SizedBox(height: 12),
          _buildIncidentItem(
            icon: 'assets/onb2.svg',
            title: 'Long Break Alert',
            subtitle: 'Checkout Counter: 15 mins away',
            time: '5 mins ago',
            severity: 'Warning',
            severityColor: const Color(0xFFE65100),
            borderColor: const Color(0xFFE65100),
          ),
          const SizedBox(height: 24),
          _buildSectionHeader('Positive', '01'),
          const SizedBox(height: 12),
          _buildIncidentItem(
            icon: 'assets/onb2.svg',
            title: 'Good Behavior',
            subtitle: 'Customer assisted - 90% satisfaction',
            time: '1 hour ago',
            severity: 'Positive',
            severityColor: const Color(0xFF2E7D32),
            borderColor: const Color(0xFF2E7D32),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '($count)',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF6B7280),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIncidentItem({
    required String icon,
    required String title,
    required String subtitle,
    required String time,
    required String severity,
    required Color severityColor,
    required Color borderColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border(
          left: BorderSide(
            color: borderColor,
            width: 4,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: severityColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: SvgPicture.asset(
                icon,
                width: 20,
                height: 20,
                colorFilter: ColorFilter.mode(severityColor, BlendMode.srcIn),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      severity,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: severityColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
