import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:insight/view/download_progress_screen.dart';

class ExportReportDialog extends StatefulWidget {
  final String reportType;

  const ExportReportDialog({Key? key, required this.reportType})
    : super(key: key);

  @override
  State<ExportReportDialog> createState() => _ExportReportDialogState();
}

class _ExportReportDialogState extends State<ExportReportDialog> {
  String? selectedReportType;
  String? selectedDateRange;
  final TextEditingController _employeeController = TextEditingController();
  String selectedExportFormat = 'PDF';
  bool includeChartsGraphs = false;

  final List<String> reportTypes = [
    'Incident Report',
    'Performance Report',
    'Attendance Report',
    'Behavior Report',
  ];

  final List<String> dateRanges = [
    'Last 7 days',
    'Last 30 days',
    'Last 3 months',
    'Last 6 months',
    'Custom range',
  ];

  @override
  void initState() {
    super.initState();
    // Don't pre-populate report type to show hint text
  }

  @override
  void dispose() {
    _employeeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.70,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(21),
          topRight: Radius.circular(21),
        ),
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 4.0),
                  child: Text(
                    'Report',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),

          // Body
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Report Type
                  const Padding(
                    padding: EdgeInsets.only(left: 4.0),
                    child: Text(
                      'Report Type',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF374151),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedReportType,
                        hint: const Text(
                          'Select report type',
                          style: TextStyle(
                            color: Color(0xFF9CA3AF),
                            fontSize: 16,
                          ),
                        ),
                        isExpanded: true,
                        isDense: true,
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          color: Color(0xFF6B7280),
                          size: 20,
                        ),
                        items: reportTypes.map((String type) {
                          return DropdownMenuItem<String>(
                            value: type,
                            child: Text(
                              type,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color(0xFF111827),
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedReportType = newValue;
                          });
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Date Range
                  const Padding(
                    padding: EdgeInsets.only(left: 4.0),
                    child: Text(
                      'Date Range',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF374151),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => _showDateRangeDialog(context),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            selectedDateRange ?? 'Select date range',
                            style: TextStyle(
                              fontSize: 16,
                              color: selectedDateRange != null
                                  ? const Color(0xFF111827)
                                  : const Color(0xFF9CA3AF),
                            ),
                          ),
                          SvgPicture.asset(
                            'assets/calender.svg',
                            width: 14,
                            height: 16,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Employee
                  const Padding(
                    padding: EdgeInsets.only(left: 4.0),
                    child: Text(
                      'Employee (optional)',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF374151),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _employeeController,
                    decoration: InputDecoration(
                      hintText: 'All employees',
                      hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
                      suffixIcon: Container(
                        width: 20,
                        height: 20,
                        padding: const EdgeInsets.all(12.0),
                        child: const Icon(
                          Icons.search,
                          size: 20,
                          color: Color(0xFF9CA3AF),
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF9FAFB),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 12.0,
                        horizontal: 16.0,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Export Format
                  const Padding(
                    padding: EdgeInsets.only(left: 4.0),
                    child: Text(
                      'Export Format',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF374151),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedExportFormat = 'PDF';
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                            decoration: BoxDecoration(
                              color: selectedExportFormat == 'PDF'
                                  ? const Color(0xFFECFDF5)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: selectedExportFormat == 'PDF'
                                    ? const Color(0xFF209A9F)
                                    : const Color(0xFFE5E7EB),
                                width: selectedExportFormat == 'PDF' ? 2 : 1,
                              ),
                            ),
                            child: Column(
                              children: [
                                SvgPicture.asset(
                                  'assets/pdf2.svg',
                                  width: 24,
                                  height: 24,
                                  color: selectedExportFormat == 'PDF'
                                      ? const Color(0xFF209A9F)
                                      : const Color(0xFF9CA3AF),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'PDF',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: selectedExportFormat == 'PDF'
                                        ? const Color(0xFF209A9F)
                                        : const Color(0xFF6B7280),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedExportFormat = 'Excel';
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                            decoration: BoxDecoration(
                              color: selectedExportFormat == 'Excel'
                                  ? const Color(0xFFECFDF5)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: selectedExportFormat == 'Excel'
                                    ? const Color(0xFF209A9F)
                                    : const Color(0xFFE5E7EB),
                                width: selectedExportFormat == 'Excel' ? 2 : 1,
                              ),
                            ),
                            child: Column(
                              children: [
                                SvgPicture.asset(
                                  'assets/excel.svg',
                                  width: 24,
                                  height: 24,
                                  color: selectedExportFormat == 'Excel'
                                      ? const Color(0xFF209A9F)
                                      : const Color(0xFF9CA3AF),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Excel',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: selectedExportFormat == 'Excel'
                                        ? const Color(0xFF209A9F)
                                        : const Color(0xFF6B7280),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Include Charts/Graphs Toggle
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Include Charts/Graphs',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF374151),
                          ),
                        ),
                        Switch(
                          value: includeChartsGraphs,
                          onChanged: (bool value) {
                            setState(() {
                              includeChartsGraphs = value;
                            });
                          },
                          activeColor: const Color(0xFF209A9F),
                          inactiveThumbColor: const Color(0xFF9CA3AF),
                          inactiveTrackColor: const Color(0xFFE5E7EB),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),

          // Export Button (Fixed at bottom)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  _handleExport(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF209A9F),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                icon: SvgPicture.asset(
                  'assets/export.svg',
                  width: 20,
                  height: 20,
                  color: Colors.white,
                ),
                label: const Text(
                  'Export Report',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleExport(BuildContext context) {
    // Validate required fields
    if (selectedReportType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a report type'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (selectedDateRange == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a date range'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Close dialog and show export message
    Navigator.of(context).pop();

    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const DownloadProgressScreen(),
    ));

    // TODO: Implement actual export functionality
  }

  void _showDateRangeDialog(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: DateTimeRange(
        start: DateTime.now().subtract(const Duration(days: 30)),
        end: DateTime.now(),
      ),
    );

    if (picked != null) {
      setState(() {
        selectedDateRange =
            '${_formatDate(picked.start)} - ${_formatDate(picked.end)}';
      });
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
