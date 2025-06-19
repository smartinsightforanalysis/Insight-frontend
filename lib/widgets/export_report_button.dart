import 'package:flutter/material.dart';

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
        icon: const Icon(
          Icons.download,
          size: 20,
        ),
        label: const Text(
          'Export All Reports',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _handleExportReport(BuildContext context) {
    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Export Report'),
          content: Text('Export $reportType data as PDF or Excel?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _exportAsPDF(context);
              },
              child: const Text('PDF'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _exportAsExcel(context);
              },
              child: const Text('Excel'),
            ),
          ],
        );
      },
    );
  }

  void _exportAsPDF(BuildContext context) {
    // TODO: Implement PDF export functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Exporting as PDF...'),
        backgroundColor: Color(0xFF209A9F),
      ),
    );
  }

  void _exportAsExcel(BuildContext context) {
    // TODO: Implement Excel export functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Exporting as Excel...'),
        backgroundColor: Color(0xFF209A9F),
      ),
    );
  }
}
