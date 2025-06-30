import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../view/filtered_report_screen.dart';

class FilterEventsPopup extends StatefulWidget {
  final String reportTitle; // Add this line

  const FilterEventsPopup({Key? key, required this.reportTitle})
    : super(key: key); // Modify constructor

  @override
  State<FilterEventsPopup> createState() => _FilterEventsPopupState();
}

class _FilterEventsPopupState extends State<FilterEventsPopup> {
  String? _selectedDateRange = 'Today'; // Default to Today
  String? _selectedZone;
  List<String> _selectedSeverities = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7, // 70% of screen height
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
                const Text(
                  'Filter Events',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
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
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Date Range',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildDateRangeOption('Today', 'Today'),
                  _buildDateRangeOption('Last 7 Days', 'Last 7 Days'),
                  _buildDateRangeOption(
                    'Custom',
                    'Custom',
                    showCalendarIcon: true,
                  ),
                  const SizedBox(height: 24),

                  const Text(
                    'Zone',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: _selectedZone,
                        hint: const Text(
                          'Select zones',
                          style: TextStyle(color: Color(0xFF9CA3AF)),
                        ),
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          color: Color(0xFF9CA3AF),
                        ),
                        items: <String>['Zone A', 'Zone B', 'Zone C', 'Zone D']
                            .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            })
                            .toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedZone = newValue;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  const Text(
                    'Severity',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildSeverityButton('Normal'),
                      const SizedBox(width: 8),
                      _buildSeverityButton('Moderate'),
                      const SizedBox(width: 8),
                      _buildSeverityButton('Suspicious'),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          // Buttons
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _selectedDateRange = 'Today';
                        _selectedZone = null;
                        _selectedSeverities = [];
                      });
                      // Optionally, close the popup or apply reset logic
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: Color(0xFFE5E7EB)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Reset',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF4B5563),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Close the popup
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FilteredReportScreen(
                            reportTitle: widget.reportTitle,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF209A9F),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Apply',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateRangeOption(
    String label,
    String value, {
    bool showCalendarIcon = false,
  }) {
    final bool isSelected;
    if (value == 'Custom') {
      isSelected =
          _selectedDateRange != 'Today' &&
          _selectedDateRange != 'Last 7 Days' &&
          _selectedDateRange != null;
    } else {
      isSelected = _selectedDateRange == value;
    }

    return GestureDetector(
      onTap: () {
        if (value == 'Custom') {
          _showDateRangePicker(context);
        } else {
          setState(() {
            _selectedDateRange = value;
          });
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              value == 'Custom' && isSelected && _selectedDateRange != 'Custom'
                  ? _selectedDateRange!
                  : label,
              style: TextStyle(
                fontSize: 16,
                color: isSelected
                    ? const Color(0xFF111827)
                    : const Color(0xFF4B5563),
              ),
            ),
            if (isSelected && !showCalendarIcon)
              const Icon(Icons.check, color: Color(0xFF209A9F), size: 20),
            if (showCalendarIcon)
              SvgPicture.asset(
                'assets/calender.svg',
                width: 16,
                height: 16,
                colorFilter: const ColorFilter.mode(
                  Color(0xFF9CA3AF),
                  BlendMode.srcIn,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _showDateRangePicker(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(
        const Duration(days: 365 * 5),
      ), // 5 years from now
      initialDateRange: DateTimeRange(
        start: DateTime.now().subtract(const Duration(days: 7)),
        end: DateTime.now(),
      ),
    );

    if (picked != null) {
      setState(() {
        _selectedDateRange =
            '${picked.start.day}/${picked.start.month}/${picked.start.year} - ${picked.end.day}/${picked.end.month}/${picked.end.year}';
      });
    }
  }

  Widget _buildSeverityButton(String severity) {
    final bool isSelected = _selectedSeverities.contains(severity);
    Color backgroundColor;
    Color textColor;
    Color borderColor;

    switch (severity) {
      case 'Normal':
        backgroundColor = isSelected
            ? const Color(0xFFECFDF5)
            : const Color(0xFFF9FAFB);
        textColor = isSelected
            ? const Color(0xFF059669)
            : const Color(0xFF4B5563);
        borderColor = isSelected ? const Color(0xFF059669) : Colors.transparent;
        break;
      case 'Moderate':
        backgroundColor = isSelected
            ? const Color(0xFFFEF3C7)
            : const Color(0xFFF9FAFB);
        textColor = isSelected
            ? const Color(0xFFB45309)
            : const Color(0xFF4B5563);
        borderColor = isSelected ? const Color(0xFFB45309) : Colors.transparent;
        break;
      case 'Suspicious':
        backgroundColor = isSelected
            ? const Color(0xFFFEE2E2)
            : const Color(0xFFF9FAFB);
        textColor = isSelected
            ? const Color(0xFFB91C1C)
            : const Color(0xFF4B5563);
        borderColor = isSelected ? const Color(0xFFB91C1C) : Colors.transparent;
        break;
      default:
        backgroundColor = const Color(0xFFF9FAFB);
        textColor = const Color(0xFF4B5563);
        borderColor = Colors.transparent;
    }

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            if (_selectedSeverities.contains(severity)) {
              _selectedSeverities.remove(severity);
            } else {
              _selectedSeverities.add(severity);
            }
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: borderColor, width: 1),
          ),
          child: Center(
            child: Text(
              severity,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
