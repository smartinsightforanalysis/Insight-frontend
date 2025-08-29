import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:insight/l10n/app_localizations.dart';
import '../services/ai_api_service.dart';

class ReportIncidentsList extends StatefulWidget {
  final String selectedPeriod;
  final String reportType;
  final Map<String, dynamic>? filters;

  const ReportIncidentsList({
    super.key,
    required this.selectedPeriod,
    required this.reportType,
    this.filters,
  });

  @override
  State<ReportIncidentsList> createState() => _ReportIncidentsListState();
}

class _ReportIncidentsListState extends State<ReportIncidentsList> {
  final AiApiService _aiApiService = AiApiService();

  List<Map<String, dynamic>> _negativeIncidents = [];
  List<Map<String, dynamic>> _neutralIncidents = [];
  List<Map<String, dynamic>> _positiveIncidents = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadIncidentsData();
  }

  @override
  void didUpdateWidget(ReportIncidentsList oldWidget) {
    super.didUpdateWidget(oldWidget);
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

      if (response['incidents'] != null) {
        final incidents = response['incidents'] as List;

        final negative = <Map<String, dynamic>>[];
        final neutral = <Map<String, dynamic>>[];
        final positive = <Map<String, dynamic>>[];

        for (var incident in incidents) {
          final category = incident['category']?.toString().toLowerCase();
          switch (category) {
            case 'negative':
              negative.add(incident);
              break;
            case 'neutral':
              neutral.add(incident);
              break;
            case 'positive':
              positive.add(incident);
              break;
          }
        }

        setState(() {
          _negativeIncidents = negative;
          _neutralIncidents = neutral;
          _positiveIncidents = positive;
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
        margin: const EdgeInsets.all(16),
        height: 200,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Negative incidents section
          if (_negativeIncidents.isNotEmpty) ...[
            _buildSectionHeader(localizations.negative, _negativeIncidents.length.toString().padLeft(2, '0')),
            const SizedBox(height: 12),
            ..._negativeIncidents.map((incident) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildIncidentItemFromData(incident, localizations),
            )),
            const SizedBox(height: 24),
          ],

          // Neutral incidents section
          if (_neutralIncidents.isNotEmpty) ...[
            _buildSectionHeader(localizations.neutral, _neutralIncidents.length.toString().padLeft(2, '0')),
            const SizedBox(height: 12),
            ..._neutralIncidents.map((incident) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildIncidentItemFromData(incident, localizations),
            )),
            const SizedBox(height: 24),
          ],

          // Positive incidents section
          if (_positiveIncidents.isNotEmpty) ...[
            _buildSectionHeader(localizations.positive, _positiveIncidents.length.toString().padLeft(2, '0')),
            const SizedBox(height: 12),
            ..._positiveIncidents.map((incident) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildIncidentItemFromData(incident, localizations),
            )),
          ],

          // Show message if no incidents
          if (_negativeIncidents.isEmpty && _neutralIncidents.isEmpty && _positiveIncidents.isEmpty)
            Container(
              padding: const EdgeInsets.all(32),
              child: Text(
                'No incidents found',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildIncidentItemFromData(Map<String, dynamic> incident, AppLocalizations localizations) {
    final category = incident['category']?.toString().toLowerCase() ?? 'neutral';
    final type = incident['type']?.toString() ?? 'unknown';
    final employee = incident['employee']?.toString() ?? 'Unknown';
    final zone = incident['zone']?.toString() ?? 'Unknown';
    final confidence = (incident['confidence'] ?? 0.0) * 100;
    final timestamp = incident['timestamp']?.toString() ?? '';
    final severity = incident['severity']?.toString() ?? 'Medium';

    // Get colors based on category and severity
    Color severityColor;
    Color borderColor;
    String severityText;

    if (category == 'negative') {
      severityColor = const Color(0xFFD32F2F);
      borderColor = const Color(0xFFD32F2F);
      severityText = severity == 'High' ? localizations.critical : localizations.warning;
    } else if (category == 'positive') {
      severityColor = const Color(0xFF2E7D32);
      borderColor = const Color(0xFF2E7D32);
      severityText = localizations.positive;
    } else {
      severityColor = const Color(0xFFE65100);
      borderColor = const Color(0xFFE65100);
      severityText = localizations.warning;
    }

    // Format incident title
    String title = _formatIncidentType(type, localizations);

    // Format subtitle with employee, zone, and confidence
    String subtitle = '';
    if (employee != 'Unknown') {
      subtitle += 'Employee: $employee';
    }
    if (zone != 'Unknown') {
      if (subtitle.isNotEmpty) subtitle += ' • ';
      subtitle += 'Zone: $zone';
    }
    if (confidence > 0) {
      if (subtitle.isNotEmpty) subtitle += ' • ';
      subtitle += 'Confidence: ${confidence.toStringAsFixed(0)}%';
    }

    // Format time
    String timeText = _formatTimestamp(timestamp);

    return _buildIncidentItem(
      icon: 'assets/onb2.svg',
      title: title,
      subtitle: subtitle.isEmpty ? 'No additional details' : subtitle,
      time: timeText,
      severity: severityText,
      severityColor: severityColor,
      borderColor: borderColor,
    );
  }

  String _formatIncidentType(String type, AppLocalizations localizations) {
    switch (type.toLowerCase()) {
      case 'phone_usage':
      case 'phone_use':
        return localizations.phoneUsage;
      case 'fight':
        return localizations.fightDetected;
      case 'gloves_violation':
      case 'gloves_missing':
        return 'Gloves Violation';
      case 'smoking':
        return 'Smoking Detected';
      case 'no_cap':
        return 'Cap Missing';
      case 'handwashing':
        return 'Handwashing Issue';
      case 'harassment':
        return localizations.harassmentAlert;
      case 'excellent_service':
        return localizations.excellentCustomerService;
      default:
        return type.replaceAll('_', ' ').split(' ').map((word) =>
          word.isEmpty ? '' : word[0].toUpperCase() + word.substring(1)).join(' ');
    }
  }

  String _formatTimestamp(String timestamp) {
    if (timestamp.isEmpty) return 'Unknown time';

    try {
      final dateTime = DateTime.parse(timestamp);
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inMinutes < 60) {
        return '${difference.inMinutes} mins ago';
      } else if (difference.inHours < 24) {
        return '${difference.inHours} hours ago';
      } else {
        return '${difference.inDays} days ago';
      }
    } catch (e) {
      return 'Unknown time';
    }
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
        border: Border(left: BorderSide(color: borderColor, width: 4)),
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
