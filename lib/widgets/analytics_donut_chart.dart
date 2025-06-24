import 'package:flutter/material.dart';
import 'analytics_tabs.dart';

class AnalyticsDonutChart extends StatelessWidget {
  final int selectedIndex;
  final void Function(int)? onTabSelected;
  const AnalyticsDonutChart({Key? key, this.selectedIndex = 0, this.onTabSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnalyticsTabs(selectedIndex: selectedIndex, onTabSelected: onTabSelected),
          const SizedBox(height: 16),
          AspectRatio(
            aspectRatio: 1.2,
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 160,
                    height: 160,
                    child: CircularProgressIndicator(
                      value: 1.0,
                      strokeWidth: 18,
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF22B8B6)),
                      backgroundColor: Color(0xFFF59E0B),
                    ),
                  ),
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: CircularProgressIndicator(
                      value: 0.7,
                      strokeWidth: 18,
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFF59E0B)),
                      backgroundColor: Color(0xFFFFC107),
                    ),
                  ),
                  SizedBox(
                    width: 80,
                    height: 80,
                    child: CircularProgressIndicator(
                      value: 0.3,
                      strokeWidth: 18,
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFFC107)),
                      backgroundColor: Color(0xFFFFEB3B),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text('Total Events', style: TextStyle(fontSize: 16, color: Color(0xFF6B7280))),
                      SizedBox(height: 4),
                      Text('7', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
} 