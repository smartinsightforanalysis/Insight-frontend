import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:insight/l10n/app_localizations.dart';
import 'package:insight/view/analytics_download_progress_screen.dart';
import 'package:insight/view/employee_download_progress_screen.dart';

class DownloadReportWidget extends StatefulWidget {
  final String? customButtonText;
  final String? employeeName; // Add employee name parameter

  const DownloadReportWidget({
    super.key,
    this.customButtonText,
    this.employeeName,
  });

  @override
  State<DownloadReportWidget> createState() => _DownloadReportWidgetState();
}

class _DownloadReportWidgetState extends State<DownloadReportWidget> {
  bool _includeAnalytics = true;
  bool _includeSnapshots = false;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localizations.downloadReport,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1C3557),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            localizations.exportDetailedReportPdf,
            style: const TextStyle(fontSize: 14, color: Color(0xFF4B5563)),
          ),
          const SizedBox(height: 16),

          // Include Analytics Toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                localizations.includeAiInsights,
                style: const TextStyle(fontSize: 14, color: Colors.black),
              ),
              Switch(
                value: _includeAnalytics,
                onChanged: (value) {
                  setState(() {
                    _includeAnalytics = value;
                  });
                },
                activeColor: const Color(0xFF16A3AC),
                inactiveThumbColor: const Color(0xFF9CA3AF),
                inactiveTrackColor: const Color(0xFFE5E7EB),
                activeTrackColor: const Color(0xFFB0D9D9),
                trackOutlineWidth: WidgetStateProperty.all(0.0),
              ),
            ],
          ),

          // Include Snapshots Toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                localizations.includeSnapshots,
                style: const TextStyle(fontSize: 14, color: Colors.black),
              ),
              Switch(
                value: _includeSnapshots,
                onChanged: (value) {
                  setState(() {
                    _includeSnapshots = value;
                  });
                },
                activeColor: const Color(0xFF16A3AC),
                inactiveThumbColor: const Color(0xFF9CA3AF),
                inactiveTrackColor: const Color(0xFFE5E7EB),
                activeTrackColor: const Color(0xFFB0D9D9),
                trackOutlineWidth: WidgetStateProperty.all(0.0),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Download Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (widget.employeeName != null) {
                  // Navigate to employee-specific download screen
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => EmployeeDownloadProgressScreen(
                        employeeName: widget.employeeName!,
                        includeAiInsights: _includeAnalytics,
                        includeSnapshots: _includeSnapshots,
                      ),
                    ),
                  );
                } else {
                  // Navigate to analytics download screen (default behavior)
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AnalyticsDownloadProgressScreen(
                        includeAiInsights: _includeAnalytics,
                        includeSnapshots: _includeSnapshots,
                      ),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF16A3AC),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/pdf.svg',
                    width: 20,
                    height: 20,
                    colorFilter: ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.customButtonText ?? localizations.downloadEmployeeSummary,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
