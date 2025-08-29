import 'package:flutter/material.dart';
import 'package:insight/l10n/app_localizations.dart';

class TopEmployeesWidget extends StatelessWidget {
  final List<Map<String, dynamic>> employees;
  final bool isLoading;

  const TopEmployeesWidget({
    Key? key,
    required this.employees,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            AppLocalizations.of(context)?.topEmployeesThisWeek ??
                'Top Employees This Week',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1C3557),
            ),
          ),
        ),
        const SizedBox(height: 8),
        if (isLoading)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: CircularProgressIndicator(),
            ),
          )
        else if (employees.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: Text(
                'No employee data available',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ),
          )
        else
          ...employees.take(5).map((employee) {
            final name = employee['name'] ?? 'Unknown';
            final score = (employee['score'] ?? 0.0).toDouble();
            final rank = employee['rank'] ?? 1;

            // Calculate progress value (0.0 to 1.0) based on score
            // Score range is 0 to 100
            final progressValue = (score / 100).clamp(0.0, 1.0);

            // Get color based on rank
            final progressColor = _getColorForRank(rank);

            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: _buildEmployeeCard(
                name,
                _getLocationForEmployee(name), // Get location based on name
                score.toInt(),
                progressColor,
                progressValue,
              ),
            );
          }),
      ],
    );
  }

  Color _getColorForRank(int rank) {
    switch (rank) {
      case 1:
        return const Color(0xFF1E3A8A); // Dark blue for #1
      case 2:
        return const Color(0xFF60A5FA); // Light blue for #2
      case 3:
        return const Color(0xFF9FD6A3); // Green for #3
      case 4:
        return const Color(0xFFCBD5E1); // Light gray for #4
      case 5:
        return const Color(0xFFCBD5E1); // Light gray for #5
      default:
        return const Color(0xFFCBD5E1); // Default gray
    }
  }

  String _getLocationForEmployee(String name) {
    // Map employee names to locations/zones
    final lowerName = name.toLowerCase();
    if (lowerName.contains('talha')) {
      return 'Downtown';
    } else if (lowerName.contains('basit')) {
      return 'Central';
    } else if (lowerName.contains('m..talha')) {
      return 'Zone 2';
    } else if (lowerName.contains('m.talha')) {
      return 'Zone 4';
    } else {
      return 'Central'; // Default location
    }
  }



  Widget _buildEmployeeCard(
    String name,
    String location,
    int score,
    Color progressColor,
    double progressValue,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      elevation: 1,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Employee placeholder
            CircleAvatar(
              radius: 25,
              backgroundColor: progressColor.withOpacity(0.15),
              child: Icon(
                Icons.person,
                color: progressColor,
                size: 30,
              ),
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
