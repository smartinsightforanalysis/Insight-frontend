import 'package:flutter/material.dart';

class AnalyticsLegend extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildLegendItem(const Color(0xFF22B8B6), 'Incident'),
          const SizedBox(width: 16),
          _buildLegendItem(const Color(0xFFF59E0B), 'Behaviour'),
          const SizedBox(width: 16),
          _buildLegendItem(const Color(0xFFFFC107), 'Awaytime'),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280))),
      ],
    );
  }
} 