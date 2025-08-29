import 'package:flutter/material.dart';
import 'package:insight/l10n/app_localizations.dart';

class BranchesPerformanceWidget extends StatelessWidget {
  final List<Map<String, dynamic>> branches;
  final bool isLoading;

  const BranchesPerformanceWidget({
    Key? key,
    this.branches = const [],
    this.isLoading = false,
  }) : super(key: key);

  // Define colors for different branches
  static const List<Color> _branchColors = [
    Color(0xFF1E3A8A), // Dark blue
    Color(0xFF60A5FA), // Light blue
    Color(0xFFCBD5E1), // Light gray
    Color(0xFF9FD6A3), // Light green
    Color(0xFFE879F9), // Pink
    Color(0xFFFBBF24), // Yellow
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            AppLocalizations.of(context)?.branchesPerformance ??
                'Branches Performance',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1C3557),
            ),
          ),
        ),
        const SizedBox(height: 8),
        if (isLoading)
          _buildLoadingState()
        else if (branches.isEmpty)
          _buildEmptyState()
        else
          ..._buildBranchCards(),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
      child: Center(child: CircularProgressIndicator(color: Color(0xFF16A3AC))),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
      child: Center(
        child: Text(
          'No branch data available',
          style: TextStyle(color: Colors.grey[600], fontSize: 14),
        ),
      ),
    );
  }

  List<Widget> _buildBranchCards() {
    List<Widget> cards = [];

    for (int i = 0; i < branches.length; i++) {
      final branch = branches[i];
      final branchName = branch['branch']?.toString() ?? 'Unknown Branch';
      final productivityScore = (branch['productivity_score'] ?? 0.0)
          .toDouble();
      final scorePercentage = (productivityScore * 100).round().clamp(0, 100);
      final progressValue = productivityScore.clamp(0.0, 1.0);

      // Use different colors for each branch
      final color = _branchColors[i % _branchColors.length];

      // Generate a location based on branch name (you can enhance this with real location data)
      final location = _generateLocationName(branchName);

      cards.add(
        _buildBranchCard(
          'Branch $branchName',
          location,
          scorePercentage,
          color,
          progressValue,
        ),
      );

      if (i < branches.length - 1) {
        cards.add(const SizedBox(height: 8));
      }
    }

    return cards;
  }

  String _generateLocationName(String branchName) {
    // Simple mapping for demo purposes - you can enhance this with real location data
    switch (branchName.toUpperCase()) {
      case 'A':
        return 'Downtown';
      case 'B':
        return 'Central';
      case 'C':
        return 'Zone 2';
      case 'D':
        return 'Zone 4';
      default:
        return 'Zone ${branchName}';
    }
  }

  Widget _buildBranchCard(
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
            // Branch placeholder
            CircleAvatar(
              radius: 25, 
              backgroundColor: progressColor.withOpacity(0.15),
              child: Icon(
                Icons.business,
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
