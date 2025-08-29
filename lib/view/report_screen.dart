import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:insight/l10n/app_localizations.dart';
import '../widgets/bottom_bar.dart';
import '../services/ai_api_service.dart';
import 'staff_screen.dart';
import 'admin_dashboard.dart';
import 'detailed_report_screen.dart';
import 'user_settings_screen.dart';
import 'analytics_screen.dart';

class ReportScreen extends StatefulWidget {
  final String userRole;

  const ReportScreen({Key? key, required this.userRole}) : super(key: key);

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  int _currentIndex = 1; // Reports tab is selected
  String _selectedPeriod = 'Daily';

  // API service and incident data
  final AiApiService _aiApiService = AiApiService();
  int _totalIncidents = 247; // Default value
  double _averageConfidence = 0.12; // Default value (12%)
  bool _isLoadingIncidents = true;

  // Behaviors data
  int _totalBehaviors = 183; // Default value
  double _behaviorsPercentage = 0.0; // Default value (0%)
  bool _isLoadingBehaviors = true;

  // Away time data
  int _totalAwayTime = 92; // Default value
  double _awayTimePercentage = -5.0; // Default value (-5%)
  bool _isLoadingAwayTime = true;

  @override
  void initState() {
    super.initState();
    _loadIncidentsData();
    _loadBehaviorsData();
    _loadAwayTimeData();
  }

  Future<void> _loadIncidentsData() async {
    try {
      setState(() {
        _isLoadingIncidents = true;
      });

      final periodCode = _getPeriodCode(_selectedPeriod);
      final response = await _aiApiService.getIncidents(period: periodCode);

      if (response['total_incidents'] != null &&
          response['statistics'] != null) {
        setState(() {
          _totalIncidents = response['total_incidents'];
          _averageConfidence =
              response['statistics']['average_confidence'] ?? 0.0;
          _isLoadingIncidents = false;
        });
      } else {
        setState(() {
          _isLoadingIncidents = false;
        });
      }
    } catch (e) {
      print('Error loading incidents data: $e');
      setState(() {
        _isLoadingIncidents = false;
      });
    }
  }

  Future<void> _loadBehaviorsData() async {
    try {
      setState(() {
        _isLoadingBehaviors = true;
      });

      final periodCode = _getPeriodCode(_selectedPeriod);
      final response = await _aiApiService.getBehaviors(period: periodCode);

      // Extract data from the actual API response structure
      final behaviors = response['behaviors'];
      final behaviorRatio = response['behavior_ratio'];

      if (behaviors != null && behaviors['employee_behavior_summary'] != null &&
          behaviorRatio != null && behaviorRatio['positive_percentage'] != null) {
        final employeeCount = (behaviors['employee_behavior_summary'] as List).length;
        final positivePercentage = (behaviorRatio['positive_percentage'] ?? 0.0).toDouble();

        setState(() {
          _totalBehaviors = employeeCount;
          _behaviorsPercentage = positivePercentage;
          _isLoadingBehaviors = false;
        });
      } else {
        setState(() {
          _isLoadingBehaviors = false;
        });
      }
    } catch (e) {
      print('Error loading behaviors data: $e');
      setState(() {
        _isLoadingBehaviors = false;
      });
    }
  }

  Future<void> _loadAwayTimeData() async {
    try {
      setState(() {
        _isLoadingAwayTime = true;
      });

      final periodCode = _getPeriodCode(_selectedPeriod);
      final response = await _aiApiService.getAwayTime(period: periodCode);

      if (response['status_breakdown'] != null) {
        final statusBreakdown = response['status_breakdown'];

        // Calculate total away time from status breakdown
        int totalAwayTime = 0;
        if (statusBreakdown is Map<String, dynamic>) {
          statusBreakdown.forEach((key, value) {
            if (value is num) {
              totalAwayTime += value.toInt();
            }
          });
        }

        // Get percentage change if available
        double percentageChange = _awayTimePercentage; // Keep default if not available
        if (response['percentage_change'] != null) {
          percentageChange = (response['percentage_change'] as num).toDouble();
        }

        setState(() {
          _totalAwayTime = totalAwayTime > 0 ? totalAwayTime : _totalAwayTime;
          _awayTimePercentage = percentageChange;
          _isLoadingAwayTime = false;
        });
      } else {
        setState(() {
          _isLoadingAwayTime = false;
        });
      }
    } catch (e) {
      print('Error loading away time data: $e');
      setState(() {
        _isLoadingAwayTime = false;
      });
    }
  }

  Future<void> _refreshAllData() async {
    await Future.wait([
      _loadIncidentsData(),
      _loadBehaviorsData(),
      _loadAwayTimeData(),
    ]);
  }

  String _getPeriodCode(String uiPeriod) {
    switch (uiPeriod.toLowerCase()) {
      case 'daily':
        return '1d';
      case 'weekly':
        return '7d';
      case 'monthly':
        return '30d';
      default:
        return '7d'; // Default to weekly
    }
  }

  String _getPeriodSubtitle(String uiPeriod, AppLocalizations? localizations) {
    switch (uiPeriod.toLowerCase()) {
      case 'daily':
        return 'Last 1 day';
      case 'weekly':
        return localizations?.lastSevenDays ?? 'Last 7 days';
      case 'monthly':
        return 'Last 30 days';
      default:
        return localizations?.lastSevenDays ?? 'Last 7 days';
    }
  }

  void _onItemTapped(int index) {
    if (index == 0) {
      // Dashboard tab
      // Navigate back to dashboard by replacing current screen
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              AdminDashboard(userRole: widget.userRole),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      );
    } else if (index == 2) {
      // Staff tab
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              StaffScreen(userRole: widget.userRole),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      );
    } else if (index == 3) {
      // Users tab
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              UserSettingsScreen(userRole: widget.userRole),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      );
    }
  }

  void _navigateToDetailedReport(String reportTitle) {
    final localizations = AppLocalizations.of(context);
    String translatedTitle;

    switch (reportTitle) {
      case 'Incident Report':
        translatedTitle = localizations?.incidentReport ?? 'Incident Report';
        break;
      case 'Behavior Report':
        translatedTitle = localizations?.behaviorReport ?? 'Behavior Report';
        break;
      case 'Away Time Report':
        translatedTitle = localizations?.awayTimeReport ?? 'Away Time Report';
        break;
      default:
        translatedTitle = reportTitle;
    }

    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            DetailedReportScreen(
              reportTitle: translatedTitle,
              userRole: widget.userRole,
            ),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: kToolbarHeight + 35,
        automaticallyImplyLeading: false,
        titleSpacing: 16,
        shape: const Border(
          bottom: BorderSide(color: Color(0xFFE5E7EB), width: 1),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              localizations?.report ?? 'Report',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AnalyticsScreen(userRole: widget.userRole),
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: SvgPicture.asset(
                  'assets/onb2.svg',
                  width: 16,
                  height: 16,
                  colorFilter: const ColorFilter.mode(
                    Color(0xFF434343),
                    BlendMode.srcIn,
                  ),
                ),
                label: Text(
                  localizations?.viewAnalytics ?? 'View Analytics',
                  style: TextStyle(fontSize: 14, color: Color(0xFF374151)),
                ),
              ),
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshAllData,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Period Selection Tabs
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      _buildPeriodTab(localizations?.daily ?? 'Daily'),
                      _buildPeriodTab(localizations?.weekly ?? 'Weekly'),
                      _buildPeriodTab(localizations?.monthly ?? 'Monthly'),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Report Cards
                _buildReportCard(
                  title: localizations?.incident ?? 'Incident',
                  subtitle: _getPeriodSubtitle(_selectedPeriod, localizations),
                  value: _isLoadingIncidents
                      ? '...'
                      : _totalIncidents.toString(),
                  percentage: _isLoadingIncidents
                      ? '...'
                      : '↑${(_averageConfidence * 100).toStringAsFixed(0)}%',
                  percentageColor: const Color(0xFF10B981),
                  borderColor: const Color(0xFF10B981),
                  onTap: () => _navigateToDetailedReport('Incident Report'),
                ),
                const SizedBox(height: 16),
                _buildReportCard(
                  title: localizations?.behaviors ?? 'Behaviors',
                  subtitle: _getPeriodSubtitle(_selectedPeriod, localizations),
                  value: _isLoadingBehaviors
                      ? '...'
                      : _totalBehaviors.toString(),
                  percentage: _isLoadingBehaviors
                      ? '...'
                      : _behaviorsPercentage == 0.0
                          ? '—0%'
                          : '↑${_behaviorsPercentage.toStringAsFixed(0)}%',
                  percentageColor: _behaviorsPercentage == 0.0
                      ? const Color(0xFFF59E0B)
                      : const Color(0xFF10B981),
                  borderColor: const Color(0xFFF59E0B),
                  onTap: () => _navigateToDetailedReport('Behavior Report'),
                ),
                const SizedBox(height: 16),
                _buildReportCard(
                  title: localizations?.awayTime ?? 'Away time',
                  subtitle: _getPeriodSubtitle(_selectedPeriod, localizations),
                  value: _isLoadingAwayTime ? '...' : _totalAwayTime.toString(),
                  percentage: _isLoadingAwayTime
                      ? '...'
                      : _awayTimePercentage >= 0
                          ? '↑${_awayTimePercentage.toStringAsFixed(0)}%'
                          : '↓${_awayTimePercentage.abs().toStringAsFixed(0)}%',
                  percentageColor: _awayTimePercentage >= 0
                      ? const Color(0xFF10B981) // Green for positive
                      : const Color(0xFFEF4444), // Red for negative
                  borderColor: const Color(0xFFEF4444),
                  onTap: () => _navigateToDetailedReport('Away Time Report'),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        userRole: widget.userRole,
      ),
    );
  }

  Widget _buildPeriodTab(String period) {
    final isSelected = _selectedPeriod == period;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedPeriod = period;
          });
          // Refresh data when period changes
          _refreshAllData();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            border: Border(
              bottom: BorderSide(
                color: isSelected
                    ? const Color(0xFF209A9F)
                    : const Color(0xFFE5E7EB),
                width: 2,
              ),
            ),
          ),
          child: Text(
            period,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected
                  ? const Color(0xFF209A9F)
                  : const Color(0xFF6B7280),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReportCard({
    required String title,
    required String subtitle,
    required String value,
    required String percentage,
    required Color percentageColor,
    required Color borderColor,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 68,
                  height: 28,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color:
                        title ==
                            (AppLocalizations.of(context)?.incident ??
                                'Incident')
                        ? const Color(0xFFD1FAE5)
                        : title ==
                              (AppLocalizations.of(context)?.behaviors ??
                                  'Behaviors')
                        ? const Color(0xFFFEF3C7)
                        : title ==
                              (AppLocalizations.of(context)?.awayTime ??
                                  'Away time')
                        ? const Color(0xFFFEE2E2)
                        : percentageColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text:
                                title ==
                                    (AppLocalizations.of(context)?.incident ??
                                        'Incident')
                                ? '↑'
                                : title ==
                                      (AppLocalizations.of(context)?.awayTime ??
                                          'Away time')
                                ? '↓'
                                : percentage[0],
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color:
                                  title ==
                                      (AppLocalizations.of(context)?.incident ??
                                          'Incident')
                                  ? const Color(0xFF047857)
                                  : title ==
                                        (AppLocalizations.of(
                                              context,
                                            )?.behaviors ??
                                            'Behaviors')
                                  ? const Color(0xFFB45309)
                                  : title ==
                                        (AppLocalizations.of(
                                              context,
                                            )?.awayTime ??
                                            'Away time')
                                  ? const Color(0xFFB91C1C)
                                  : percentageColor,
                            ),
                          ),
                          TextSpan(
                            text:
                                title ==
                                    (AppLocalizations.of(context)?.incident ??
                                        'Incident')
                                ? _isLoadingIncidents
                                      ? '...'
                                      : '${(_averageConfidence * 100).toStringAsFixed(0)}%'
                                : percentage.substring(1),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color:
                                  title ==
                                      (AppLocalizations.of(context)?.incident ??
                                          'Incident')
                                  ? const Color(0xFF047857)
                                  : title ==
                                        (AppLocalizations.of(
                                              context,
                                            )?.behaviors ??
                                            'Behaviors')
                                  ? const Color(0xFFB45309)
                                  : title ==
                                        (AppLocalizations.of(
                                              context,
                                            )?.awayTime ??
                                            'Away time')
                                  ? const Color(0xFFB91C1C)
                                  : percentageColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
