import 'package:flutter/material.dart';
import 'package:insight/l10n/app_localizations.dart';
import '../services/ai_api_service.dart';

class ReportSummaryCards extends StatefulWidget {
  final String selectedPeriod;
  final String reportType;
  final Map<String, dynamic>? filters;

  const ReportSummaryCards({
    super.key,
    required this.selectedPeriod,
    required this.reportType,
    this.filters,
  });

  @override
  State<ReportSummaryCards> createState() => _ReportSummaryCardsState();
}

class _ReportSummaryCardsState extends State<ReportSummaryCards> {
  final AiApiService _aiApiService = AiApiService();

  int _positiveCount = 0;
  int _neutralCount = 0;
  int _negativeCount = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadIncidentsData();
  }

  @override
  void didUpdateWidget(ReportSummaryCards oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reload data when period or filters change
    if (oldWidget.selectedPeriod != widget.selectedPeriod ||
        oldWidget.filters != widget.filters) {
      _loadIncidentsData();
    }
  }

  Future<void> _loadIncidentsData() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final Map<String, dynamic> response;

      // Use filtered API if filters are applied
      if (widget.filters != null) {
        response = await _aiApiService.getIncidentsWithFilters(
          startDate: widget.filters!['startDate'],
          endDate: widget.filters!['endDate'],
          zone: widget.filters!['zone'],
        );
      } else {
        response = await _aiApiService.getIncidents();
      }

      if (response['statistics'] != null && response['statistics']['categorization'] != null) {
        final categorization = response['statistics']['categorization'];

        setState(() {
          _positiveCount = categorization['positive_violations'] ?? 0;
          _neutralCount = categorization['neutral_violations'] ?? 0;
          _negativeCount = categorization['negative_violations'] ?? 0;
          _isLoading = false;
        });
      } else if (response['incidents'] != null) {
        // Fallback to manual counting if categorization stats are not available
        final incidents = response['incidents'] as List;

        int positive = 0;
        int neutral = 0;
        int negative = 0;

        for (var incident in incidents) {
          final category = incident['category']?.toString().toLowerCase();
          switch (category) {
            case 'positive':
              positive++;
              break;
            case 'neutral':
              neutral++;
              break;
            case 'negative':
              negative++;
              break;
          }
        }

        setState(() {
          _positiveCount = positive;
          _neutralCount = neutral;
          _negativeCount = negative;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading incidents data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    if (_isLoading) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        height: 120,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildSummaryCard(
              title: localizations.positive,
              value: _positiveCount.toString(),
              backgroundColor: const Color(0xFFEBFDF5),
              textColor: const Color(0xFF059669),
              icon: Icons.check,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildSummaryCard(
              title: localizations.neutral,
              value: _neutralCount.toString(),
              backgroundColor: const Color(0xFFFFFBEB),
              textColor: const Color(0xFFD97706),
              icon: Icons.remove,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildSummaryCard(
              title: localizations.negative,
              value: _negativeCount.toString(),
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
    return Builder(
      builder: (context) {
        final localizations = AppLocalizations.of(context)!;
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
            border: title == localizations.positive
                ? Border.all(color: const Color(0xFFD1FAE5), width: 1)
                : title == localizations.neutral
                ? Border.all(color: const Color(0xFFFEF3C7), width: 1)
                : title == localizations.negative
                ? Border.all(color: const Color(0xFFFEE2E2), width: 1)
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: textColor, size: 24),
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
                  fontWeight: FontWeight.w500,
                  color: title == localizations.positive
                      ? const Color(0xFF059669)
                      : title == localizations.neutral
                      ? const Color(0xFFD97706)
                      : title == localizations.negative
                      ? const Color(0xFFDC2626)
                      : textColor,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
