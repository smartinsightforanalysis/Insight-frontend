import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:insight/l10n/app_localizations.dart';

class RecentBehavioursWidget extends StatelessWidget {
  final List<Map<String, dynamic>> recentBehaviors;
  final int totalEvents;
  final Map<String, dynamic> behaviorSummary;
  final String timePeriod;
  final bool isLoading;

  const RecentBehavioursWidget({
    Key? key,
    this.recentBehaviors = const [],
    this.totalEvents = 0,
    this.behaviorSummary = const {},
    this.timePeriod = 'Last 24 hours',
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)?.recentBehaviours ??
                        'Recent Behaviours',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1C3557),
                    ),
                  ),
                  if (!isLoading && totalEvents > 0)
                    Text(
                      '$totalEvents events • $timePeriod',
                      style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                    ),
                ],
              ),
              TextButton(
                onPressed: () {
                  // Handle View All tap
                },
                child: Text(
                  AppLocalizations.of(context)?.viewAll ?? 'View All',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF209A9F),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        if (isLoading)
          _buildLoadingState()
        else if (recentBehaviors.isEmpty)
          _buildEmptyState(context)
        else
          ..._buildBehaviorCards(context),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
      child: Center(child: CircularProgressIndicator(color: Color(0xFF16A3AC))),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.timeline, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No recent behaviors',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              timePeriod,
              style: TextStyle(color: Colors.grey[500], fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildBehaviorCards(BuildContext context) {
    List<Widget> cards = [];

    for (int i = 0; i < recentBehaviors.length; i++) {
      final behavior = recentBehaviors[i];

      // Extract data from API response
      final employeeName =
          behavior['employee_name']?.toString() ?? 'Unknown Employee';
      final description =
          behavior['description']?.toString() ?? 'No description available';
      final timestamp = behavior['timestamp']?.toString() ?? '';
      final location = behavior['location']?.toString() ?? 'Unknown Location';
      final behaviorType = behavior['behavior_type']?.toString() ?? 'neutral';
      final aiTag = behavior['ai_tag']?.toString() ?? 'Neutral';

      // Format time from timestamp
      final time = _formatTime(timestamp);

      // Determine colors based on behavior type
      final colors = _getBehaviorColors(behaviorType.toLowerCase());

      cards.add(
        _buildBehaviourCard(
          employeeName,
          description,
          time,
          '#$location',
          '${AppLocalizations.of(context)?.aiTag ?? 'AI Tag'}: $aiTag',
          colors['cardColor']!,
          colors['tagTextColor']!,
          colors['tagBackgroundColor']!,
        ),
      );

      if (i < recentBehaviors.length - 1) {
        cards.add(const SizedBox(height: 16));
      }
    }

    return cards;
  }

  String _formatTime(String timestamp) {
    if (timestamp.isEmpty) return '';

    try {
      final dateTime = DateTime.parse(timestamp);
      final hour = dateTime.hour;
      final minute = dateTime.minute;
      final period = hour >= 12 ? 'PM' : 'AM';
      final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);

      return '$displayHour:${minute.toString().padLeft(2, '0')} $period';
    } catch (e) {
      return timestamp; // Return original if parsing fails
    }
  }

  Map<String, Color> _getBehaviorColors(String behaviorType) {
    switch (behaviorType) {
      case 'positive':
        return {
          'cardColor': const Color(0xFFDAFFDB),
          'tagTextColor': const Color(0xFF059669),
          'tagBackgroundColor': const Color(0xFFD1FAE5),
        };
      case 'negative':
        return {
          'cardColor': const Color(0xFFFEF2F2),
          'tagTextColor': const Color(0xFFDC2626),
          'tagBackgroundColor': const Color(0xFFFEE2E2),
        };
      case 'neutral':
      default:
        return {
          'cardColor': const Color(0xFFEFEFEF),
          'tagTextColor': const Color(0xFFD97706),
          'tagBackgroundColor': const Color(0xFFFEF3C7),
        };
    }
  }

  Widget _buildBehaviourCard(
    String name,
    String description,
    String time,
    String tag1,
    String tag2,
    Color cardColor,
    Color tag2Color,
    Color tag2BackgroundColor,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      elevation: 0,
      color: cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1C3557),
                  ),
                ),
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: const TextStyle(fontSize: 15, color: Color(0xFF374151)),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildTag(
                  tag1,
                  const Color(0xFFF3F4F6),
                  const Color(0xFF4B5563),
                ),
                const SizedBox(width: 8),
                _buildTag(tag2, tag2BackgroundColor, tag2Color),
                const SizedBox(width: 4),
                SvgPicture.asset('assets/photo.svg'), // Replaced with photo.svg
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String text, Color backgroundColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
    );
  }
}
