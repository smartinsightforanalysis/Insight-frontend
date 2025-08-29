import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:insight/l10n/app_localizations.dart';

class FilterEventsPopup extends StatefulWidget {
  final String reportTitle; // Add this line

  const FilterEventsPopup({super.key, required this.reportTitle});

  @override
  State<FilterEventsPopup> createState() => _FilterEventsPopupState();
}

class _FilterEventsPopupState extends State<FilterEventsPopup> {
  String? _selectedDateRange;
  String? _selectedZone;
  List<String> _selectedSeverities = [];
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    
    // Initialize default date range with localized "Today" if not set
    _selectedDateRange ??= localizations.today;
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
                Text(
                  localizations.filterEvents,
                  style: const TextStyle(
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
                  Text(
                    localizations.dateRange,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildDateRangeOption(localizations.today, localizations.today),
                  _buildDateRangeOption(localizations.last7Days, localizations.last7Days),
                  _buildDateRangeOption(
                    localizations.custom,
                    localizations.custom,
                    showCalendarIcon: true,
                  ),
                  const SizedBox(height: 24),

                  Text(
                    localizations.zone,
                    style: const TextStyle(
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
                        hint: Text(
                          localizations.selectZones,
                          style: const TextStyle(color: Color(0xFF9CA3AF)),
                        ),
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          color: Color(0xFF9CA3AF),
                        ),
                        items: [
                          localizations.zoneA,
                          localizations.zoneB,
                          localizations.zoneC,
                          localizations.zoneD,
                        ].map<DropdownMenuItem<String>>((String value) {
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

                  Text(
                    localizations.severity,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildSeverityButton(localizations.normal),
                      const SizedBox(width: 8),
                      _buildSeverityButton(localizations.moderate),
                      const SizedBox(width: 8),
                      _buildSeverityButton(localizations.suspicious),
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
                        _selectedDateRange = localizations.today;
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
                    child: Text(
                      localizations.reset,
                      style: const TextStyle(
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
                      // Prepare filter data
                      final filterData = {
                        'dateRange': _selectedDateRange,
                        'zone': _selectedZone,
                        'severities': _selectedSeverities,
                        'startDate': _startDate,
                        'endDate': _endDate,
                      };

                      Navigator.pop(context, filterData); // Close popup and return filter data
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF209A9F),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      localizations.apply,
                      style: const TextStyle(
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
    final localizations = AppLocalizations.of(context)!;
    final bool isSelected;
    if (value == localizations.custom) {
      isSelected =
          _selectedDateRange != localizations.today &&
          _selectedDateRange != localizations.last7Days &&
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
        _startDate = picked.start;
        _endDate = picked.end;
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
