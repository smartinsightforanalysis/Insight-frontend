import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AnalyticsEventsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Events',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF374151),
                ),
              ),
              SvgPicture.asset(
                'assets/3dots.svg',
                width: 20,
                height: 20,
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildEventRow('Incident', '4 events'),
          const SizedBox(height: 8),
          _buildEventRow('Behaviour', '2 events'),
          const SizedBox(height: 8),
          _buildEventRow('Away time', '1 event'),
        ],
      ),
    );
  }

  Widget _buildEventRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 15, color: Colors.black),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 15, color: Color(0xFF1F2937)),
        ),
      ],
    );
  }
} 