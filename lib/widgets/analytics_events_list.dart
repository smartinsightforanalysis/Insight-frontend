import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:insight/l10n/app_localizations.dart';
import '../services/ai_api_service.dart';

class AnalyticsEventsList extends StatefulWidget {
  const AnalyticsEventsList({super.key});

  @override
  State<AnalyticsEventsList> createState() => _AnalyticsEventsListState();
}

class _AnalyticsEventsListState extends State<AnalyticsEventsList> {
  final AiApiService _aiApiService = AiApiService();
  bool _isLoading = true;
  int _incidentEvents = 0;
  int _behaviorEvents = 0;
  int _awayTimeEvents = 0;

  @override
  void initState() {
    super.initState();
    _loadAnalyticsData();
  }

  Future<void> _loadAnalyticsData() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final response = await _aiApiService.getAnalyticsEvents(period: '24hr');

      setState(() {
        _incidentEvents = response['incident_events'] ?? 0;
        _behaviorEvents = response['behavior_events'] ?? 0;
        _awayTimeEvents = response['away_time_events'] ?? 0;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading analytics data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

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
              Text(
                localizations.events,
                style: const TextStyle(
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
          if (_isLoading) ...[
            _buildLoadingRow(),
            const SizedBox(height: 8),
            _buildLoadingRow(),
            const SizedBox(height: 8),
            _buildLoadingRow(),
          ] else ...[
            _buildEventRow(
              localizations.incident,
              '$_incidentEvents ${_incidentEvents == 1 ? localizations.event : localizations.events}'
            ),
            const SizedBox(height: 8),
            _buildEventRow(
              localizations.behaviour,
              '$_behaviorEvents ${_behaviorEvents == 1 ? localizations.event : localizations.events}'
            ),
            const SizedBox(height: 8),
            _buildEventRow(
              localizations.awayTime,
              '$_awayTimeEvents ${_awayTimeEvents == 1 ? localizations.event : localizations.events}'
            ),
          ],
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

  Widget _buildLoadingRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: 80,
          height: 15,
          decoration: BoxDecoration(
            color: const Color(0xFFE5E7EB),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        Container(
          width: 60,
          height: 15,
          decoration: BoxDecoration(
            color: const Color(0xFFE5E7EB),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }
}