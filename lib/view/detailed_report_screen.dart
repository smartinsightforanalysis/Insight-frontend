import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:insight/l10n/app_localizations.dart';
import '../widgets/report_period_tabs.dart';
import '../widgets/report_summary_cards.dart';
import '../widgets/filter_events_popup.dart';
import '../widgets/report_incidents_list.dart';
import '../widgets/export_report_button.dart';
import 'filtered_report_screen.dart';
import '../services/ai_api_service.dart';

class DetailedReportScreen extends StatefulWidget {
  final String reportTitle;
  final String userRole;

  const DetailedReportScreen({
    super.key,
    required this.reportTitle,
    required this.userRole,
  });

  @override
  State<DetailedReportScreen> createState() => _DetailedReportScreenState();
}

class _DetailedReportScreenState extends State<DetailedReportScreen> {
  late String _selectedPeriod;
  Map<String, dynamic>? _activeFilters;

  void _onPeriodChanged(String period) {
    setState(() {
      _selectedPeriod = period;
    });
  }



  void _handleFilterData(Map<String, dynamic> filterData) async {
    // Convert filter data to API parameters
    String? startDate;
    String? endDate;
    String? zone;

    // Handle date range
    final dateRange = filterData['dateRange'] as String?;
    final startDateObj = filterData['startDate'] as DateTime?;
    final endDateObj = filterData['endDate'] as DateTime?;

    if (startDateObj != null && endDateObj != null) {
      startDate = startDateObj.toIso8601String().split('T')[0];
      endDate = endDateObj.toIso8601String().split('T')[0];
    } else if (dateRange != null) {
      final localizations = AppLocalizations.of(context)!;
      final now = DateTime.now();

      if (dateRange == localizations.today) {
        startDate = now.toIso8601String().split('T')[0];
        endDate = now.toIso8601String().split('T')[0];
      } else if (dateRange == localizations.last7Days) {
        startDate = now.subtract(const Duration(days: 7)).toIso8601String().split('T')[0];
        endDate = now.toIso8601String().split('T')[0];
      }
    }

    // Handle zone
    final selectedZone = filterData['zone'] as String?;
    if (selectedZone != null) {
      // Convert localized zone names to API format
      final localizations = AppLocalizations.of(context)!;
      if (selectedZone == localizations.zoneA) {
        zone = 'A';
      } else if (selectedZone == localizations.zoneB) {
        zone = 'B';
      } else if (selectedZone == localizations.zoneC) {
        zone = 'C';
      } else if (selectedZone == localizations.zoneD) {
        zone = 'D';
      }
    }

    // Check if filters will return results
    try {
      final aiApiService = AiApiService();
      final response = await aiApiService.getIncidentsWithFilters(
        startDate: startDate,
        endDate: endDate,
        zone: zone,
      );

      final incidents = response['incidents'] as List?;
      final hasResults = incidents != null && incidents.isNotEmpty;

      if (hasResults) {
        // Apply filters to current screen
        setState(() {
          _activeFilters = {
            'startDate': startDate,
            'endDate': endDate,
            'zone': zone,
            'originalData': filterData,
          };
        });
      } else {
        // Navigate to filtered report screen (no data found)
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FilteredReportScreen(
                reportTitle: widget.reportTitle,
              ),
            ),
          );
        }
      }
    } catch (e) {
      // On error, still apply filters to show loading/error states
      setState(() {
        _activeFilters = {
          'startDate': startDate,
          'endDate': endDate,
          'zone': zone,
          'originalData': filterData,
        };
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final localizations = AppLocalizations.of(context)!;
    _selectedPeriod = localizations.daily;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        toolbarHeight: kToolbarHeight + 10,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
          padding: EdgeInsets.zero,
        ),
        titleSpacing: 0,
        title: Text(
          widget.reportTitle,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              'assets/filter.svg',
              width: 16,
              height: 14,
              colorFilter: const ColorFilter.mode(
                Color(0xFF4B5563),
                BlendMode.srcIn,
              ),
            ),
            onPressed: () async {
              final filterData = await showModalBottomSheet<Map<String, dynamic>>(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) =>
                    FilterEventsPopup(reportTitle: widget.reportTitle),
              );

              if (filterData != null) {
                _handleFilterData(filterData);
              }
            },
          ),
        ],
        shape: const Border(
          bottom: BorderSide(color: Color(0xFFE5E7EB), width: 1),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Period Selection Tabs
            ReportPeriodTabs(
              selectedPeriod: _selectedPeriod,
              onPeriodChanged: _onPeriodChanged,
            ),

            // Summary Cards
            ReportSummaryCards(
              selectedPeriod: _selectedPeriod,
              reportType: widget.reportTitle,
              filters: _activeFilters,
            ),

            // Incidents List
            ReportIncidentsList(
              selectedPeriod: _selectedPeriod,
              reportType: widget.reportTitle,
              filters: _activeFilters,
            ),

            // Export Button
            ExportReportButton(
              userRole: widget.userRole,
              reportType: widget.reportTitle,
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
