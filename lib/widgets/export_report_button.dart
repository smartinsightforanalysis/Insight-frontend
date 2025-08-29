import 'package:flutter/material.dart';
import 'package:insight/l10n/app_localizations.dart';
import 'package:insight/widgets/export_report_dialog.dart';

class ExportReportButton extends StatelessWidget {
  final String userRole;
  final String reportType;

  const ExportReportButton({
    Key? key,
    required this.userRole,
    required this.reportType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    
    // Only show for admin role users based on user preferences
    if (userRole != 'admin') {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.all(16),
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          _handleExportReport(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF209A9F),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        icon: const Icon(Icons.download, size: 20),
        label: Text(
          localizations.exportAllReports,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  void _handleExportReport(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ExportReportDialog(reportType: reportType),
    );
  }
}
