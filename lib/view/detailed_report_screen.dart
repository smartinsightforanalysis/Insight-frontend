import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/report_period_tabs.dart';
import '../widgets/report_summary_cards.dart';
import '../widgets/report_incidents_list.dart';
import '../widgets/export_report_button.dart';

class DetailedReportScreen extends StatefulWidget {
  final String reportTitle;
  final String userRole;

  const DetailedReportScreen({
    Key? key,
    required this.reportTitle,
    required this.userRole,
  }) : super(key: key);

  @override
  State<DetailedReportScreen> createState() => _DetailedReportScreenState();
}

class _DetailedReportScreenState extends State<DetailedReportScreen> {
  String _selectedPeriod = 'Daily';

  void _onPeriodChanged(String period) {
    setState(() {
      _selectedPeriod = period;
    });
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
              colorFilter: const ColorFilter.mode(Color(0xFF4B5563), BlendMode.srcIn),
            ),
            onPressed: () {
              // Handle filter action
            },
          ),
        ],
        shape: const Border(
          bottom: BorderSide(
            color: Color(0xFFE5E7EB),
            width: 1,
          ),
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
            ),
            
            // Incidents List
            ReportIncidentsList(
              selectedPeriod: _selectedPeriod,
              reportType: widget.reportTitle,
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
