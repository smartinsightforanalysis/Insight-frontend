import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:insight/l10n/app_localizations.dart';

class BranchPerformanceChart extends StatefulWidget {
  final List<Map<String, dynamic>> branches;
  final bool isLoading;
  final Function(String)? onPeriodChanged;

  const BranchPerformanceChart({
    Key? key,
    this.branches = const [],
    this.isLoading = false,
    this.onPeriodChanged,
  }) : super(key: key);

  @override
  State<BranchPerformanceChart> createState() => _BranchPerformanceChartState();
}

class _BranchPerformanceChartState extends State<BranchPerformanceChart> {
  int _selectedIndex = 0; // 0: D, 1: W, 2: M

  // Get branch names from API data
  List<String> get _branchLabels {
    if (widget.branches.isEmpty) {
      return ['A', 'B', 'C', 'D']; // Fallback
    }
    return widget.branches
        .map((branch) => branch['branch']?.toString() ?? 'Unknown')
        .toList();
  }

  // Get productivity scores as percentages (0-100)
  List<int> get _productivityScores {
    if (widget.branches.isEmpty) {
      return [50, 95, 30, 75]; // Fallback data
    }
    return widget.branches.map((branch) {
      double score = (branch['productivity_score'] ?? 0.0).toDouble();
      return (score * 100).round().clamp(0, 100); // Convert to percentage
    }).toList();
  }

  // For now, use same data for D, W, M (can be enhanced later with time-based data)
  List<List<int>> get _data {
    final scores = _productivityScores;
    return [
      scores, // D
      scores, // W
      scores, // M
    ];
  }

  @override
  Widget build(BuildContext context) {
    final bars = _data[_selectedIndex];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          // Overall light shadow
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
          // Bottom border shadow
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 3,
            spreadRadius: 1,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)?.branchPerformance ??
                    'Branch Performance',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1C3557),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F6FA),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildToggle('D', 0),
                    SizedBox(
                      width: MediaQuery.of(context).size.width < 400 ? 4 : 8,
                    ),
                    _buildToggle('W', 1),
                    SizedBox(
                      width: MediaQuery.of(context).size.width < 400 ? 4 : 8,
                    ),
                    _buildToggle('M', 2),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 170,
            child: widget.isLoading
                ? Center(
                    child: CircularProgressIndicator(color: Color(0xFF16A3AC)),
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Y-axis numbers
                      SizedBox(
                        width: 32.0, // Fixed width for Y-axis numbers
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            for (var y in [100, 75, 50, 25, 0])
                              SizedBox(
                                height: 34,
                                child: Text(
                                  '$y',
                                  style: TextStyle(
                                    color: Colors.grey.shade400,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Chart area with grid lines and bars only (no longer scrollable)
                      Expanded(
                        child: Stack(
                          children: [
                            // Grid lines positioned to align exactly with center of Y-axis labels
                            Stack(
                              children: [
                                // 75 line - at center of 75 label
                                Positioned(
                                  top: (170 / 5) + (170 / 10) - 0.5,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    width: double.infinity,
                                    height: 1,
                                    color: Colors.grey.withOpacity(0.15),
                                  ),
                                ),
                                // 50 line - at center of 50 label
                                Positioned(
                                  top: (170 / 5) * 2 + (170 / 10) - 0.5,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    width: double.infinity,
                                    height: 1,
                                    color: Colors.grey.withOpacity(0.15),
                                  ),
                                ),
                                // 25 line - at center of 25 label
                                Positioned(
                                  top: (170 / 5) * 3 + (170 / 10) - 0.5,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    width: double.infinity,
                                    height: 1,
                                    color: Colors.grey.withOpacity(0.15),
                                  ),
                                ),
                                // 0 line - at center of 0 label
                                Positioned(
                                  top: (170 / 5) * 4 + (170 / 10) - 0.5,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    width: double.infinity,
                                    height: 1,
                                    color: Colors.grey.withOpacity(0.15),
                                  ),
                                ),
                              ],
                            ),
                            // Bars - positioned to start from the 0 horizontal line
                            Positioned(
                              bottom:
                                  (170 / 10) -
                                  0.5, // Start from 0 line position
                              left: 0,
                              right: 0,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: List.generate(bars.length, (i) {
                                  // Calculate bar height as percentage of available space above 0 line
                                  // Available space from 0 line to top: (170 / 5) * 4 + (170 / 10)
                                  final double availableHeight =
                                      (170 / 5) * 4 + (170 / 10);
                                  final double barHeight =
                                      (bars[i] / 100.0) * availableHeight;

                                  return Expanded(
                                    child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Container(
                                        width:
                                            24, // Keep a fixed width for the bar itself, let Expanded handle spacing
                                        height: barHeight,
                                        decoration: const BoxDecoration(
                                          color: Color(0xFF16A3AC),
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(2),
                                            topRight: Radius.circular(2),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
          const SizedBox(height: 16),
          // Branch labels row (no longer scrollable)
          if (!widget.isLoading)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 32.0,
                ), // Match the fixed width of Y-axis numbers
                const SizedBox(
                  width: 8,
                ), // Match the gap between Y-axis and bars
                Expanded(
                  child: Row(
                    children: List.generate(_branchLabels.length, (i) {
                      return Expanded(
                        child: Center(
                          child: SizedBox(
                            width: 24, // Match the width of the bars
                            child: Text(
                              _branchLabels[i],
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF6B7280),
                              ),
                              textAlign: TextAlign
                                  .center, // Ensure text is centered within its SizedBox
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildToggle(String label, int idx) {
    final bool selected = _selectedIndex == idx;
    // Get screen width to make responsive
    final double screenWidth = MediaQuery.of(context).size.width;
    // Determine if we're on a small device
    final bool isSmallDevice = screenWidth < 400;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = idx;
        });

        // Call the callback with the appropriate period
        if (widget.onPeriodChanged != null) {
          String period;
          switch (idx) {
            case 0:
              period = '1d'; // D
              break;
            case 1:
              period = '7d'; // W
              break;
            case 2:
              period = '30d'; // M
              break;
            default:
              period = '1d';
          }
          widget.onPeriodChanged!(period);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: EdgeInsets.symmetric(
          horizontal: isSmallDevice ? 6 : 10,
          vertical: isSmallDevice ? 2 : 4,
        ),
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(isSmallDevice ? 5 : 7),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ]
              : [],
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: selected ? const Color(0xFF1E293B) : const Color(0xFF64748B),
            fontSize: isSmallDevice ? 12 : 15,
            letterSpacing: isSmallDevice ? 0.8 : 1.2,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
