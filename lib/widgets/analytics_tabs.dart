import 'package:flutter/material.dart';

class AnalyticsTabs extends StatelessWidget {
  final int selectedIndex;
  final void Function(int)? onTabSelected;

  const AnalyticsTabs({this.selectedIndex = 0, this.onTabSelected, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildTab('Time Activity', 0, selectedIndex == 0),
        ),
        const SizedBox(width: 18),
        Expanded(
          child: _buildTab('Zone Map', 1, selectedIndex == 1),
        ),
      ],
    );
  }

  Widget _buildTab(String label, int index, bool selected) {
    return GestureDetector(
      onTap: () => onTabSelected?.call(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFEAF4FA) : const Color(0xFFF5F6F7),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: selected ? const Color(0xFF179EA8) : const Color(0xFF5B6470),
          ),
        ),
      ),
    );
  }
} 