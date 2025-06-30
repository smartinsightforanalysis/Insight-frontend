import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/bottom_bar.dart';
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
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            DetailedReportScreen(
              reportTitle: reportTitle,
              userRole: widget.userRole,
            ),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
            const Text(
              'Report',
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
                label: const Text(
                  'View Analytics',
                  style: TextStyle(fontSize: 14, color: Color(0xFF374151)),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
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
                    _buildPeriodTab('Daily'),
                    _buildPeriodTab('Weekly'),
                    _buildPeriodTab('Monthly'),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Report Cards
              _buildReportCard(
                title: 'Incident',
                subtitle: 'Last 7 days',
                value: '247',
                percentage: '↑12%',
                percentageColor: const Color(0xFF10B981),
                borderColor: const Color(0xFF10B981),
                onTap: () => _navigateToDetailedReport('Incident Report'),
              ),
              const SizedBox(height: 16),
              _buildReportCard(
                title: 'Behaviors',
                subtitle: 'Last 7 days',
                value: '183',
                percentage: '—0%',
                percentageColor: const Color(0xFFF59E0B),
                borderColor: const Color(0xFFF59E0B),
                onTap: () => _navigateToDetailedReport('Behavior Report'),
              ),
              const SizedBox(height: 16),
              _buildReportCard(
                title: 'Away time',
                subtitle: 'Last 7 days',
                value: '92',
                percentage: '↓5%',
                percentageColor: const Color(0xFFEF4444),
                borderColor: const Color(0xFFEF4444),
                onTap: () => _navigateToDetailedReport('Away Time Report'),
              ),
            ],
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
                  width: 58,
                  height: 28,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: title == 'Incident'
                        ? const Color(0xFFD1FAE5)
                        : title == 'Behaviors'
                        ? const Color(0xFFFEF3C7)
                        : title == 'Away time'
                        ? const Color(0xFFFEE2E2)
                        : percentageColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: title == 'Incident'
                                ? '↑'
                                : title == 'Away time'
                                ? '↓'
                                : percentage[0],
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: title == 'Incident'
                                  ? const Color(0xFF047857)
                                  : title == 'Behaviors'
                                  ? const Color(0xFFB45309)
                                  : title == 'Away time'
                                  ? const Color(0xFFB91C1C)
                                  : percentageColor,
                            ),
                          ),
                          TextSpan(
                            text: title == 'Incident'
                                ? '12%'
                                : percentage.substring(1),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: title == 'Incident'
                                  ? const Color(0xFF047857)
                                  : title == 'Behaviors'
                                  ? const Color(0xFFB45309)
                                  : title == 'Away time'
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
