import 'package:flutter/material.dart';
import '../services/ai_api_service.dart';

class SimplePerformanceChart extends StatefulWidget {
  final String title;
  final List<int> data;
  final String? employeeName;

  const SimplePerformanceChart({
    Key? key,
    required this.title,
    required this.data,
    this.employeeName,
  }) : super(key: key);

  @override
  State<SimplePerformanceChart> createState() => _SimplePerformanceChartState();
}

class _SimplePerformanceChartState extends State<SimplePerformanceChart> {
  final AiApiService _aiApiService = AiApiService();
  int _selectedIndex = 0; // 0: D, 1: W, 2: M
  List<int> _apiData = [];
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    if (widget.employeeName != null) {
      _loadPerformanceData();
    }
  }

  Future<void> _loadPerformanceData() async {
    if (widget.employeeName == null) return;

    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final period = _selectedIndex == 0 ? '7d' : _selectedIndex == 1 ? '30d' : '90d';

      final response = await _aiApiService.getEmployeePerformanceChart(
        employeeName: widget.employeeName!,
        chartType: 'bar',
        period: period,
      );

      if (response['data'] != null && response['data'] is List) {
        final data = List<Map<String, dynamic>>.from(response['data']);
        final chartData = data.map((item) {
          // Use compliance_score as the main performance metric
          final score = item['compliance_score'] ?? 0;
          return (score is num) ? score.round().clamp(0, 100) : 0;
        }).toList();

        setState(() {
          _apiData = chartData.isNotEmpty ? chartData : [0, 0, 0, 0, 0, 0, 0];
          _isLoading = false;
        });
      } else {
        setState(() {
          _apiData = [0, 0, 0, 0, 0, 0, 0]; // Fallback data
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Failed to load performance data';
        _apiData = [0, 0, 0, 0, 0, 0, 0]; // Fallback data
        _isLoading = false;
      });
    }
  }

  List<int> get _currentData {
    if (widget.employeeName != null && _apiData.isNotEmpty) {
      return _apiData;
    }
    return widget.data; // Fallback to provided data
  }

  @override
  Widget build(BuildContext context) {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
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
                    const SizedBox(width: 8),
                    _buildToggle('W', 1),
                    const SizedBox(width: 8),
                    _buildToggle('M', 2),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Chart Area
          SizedBox(
            height: 140,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Y-axis numbers
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    for (var y in [100, 75, 50, 25, 0])
                      SizedBox(
                        height: 28,
                        child: Center(
                          child: Text(
                            '$y',
                            style: TextStyle(
                              color: Colors.grey.shade400,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 8),
                
                // Chart bars
                Expanded(
                  child: Stack(
                    children: [
                      // Grid lines - positioned to align exactly with center of Y-axis labels
                      Stack(
                        children: [
                          // 75 line - at 42px from top (center of 75 label)
                          Positioned(
                            top: 42,
                            left: 0,
                            right: 0,
                            child: Container(
                              width: double.infinity,
                              height: 1,
                              color: Colors.grey.withValues(alpha: 0.15),
                            ),
                          ),
                          // 50 line - at 70px from top (center of 50 label)
                          Positioned(
                            top: 70,
                            left: 0,
                            right: 0,
                            child: Container(
                              width: double.infinity,
                              height: 1,
                              color: Colors.grey.withValues(alpha: 0.15),
                            ),
                          ),
                          // 25 line - at 98px from top (center of 25 label)
                          Positioned(
                            top: 98,
                            left: 0,
                            right: 0,
                            child: Container(
                              width: double.infinity,
                              height: 1,
                              color: Colors.grey.withValues(alpha: 0.15),
                            ),
                          ),
                          // 0 line - at 126px from top (center of 0 label)
                          Positioned(
                            top: 126,
                            left: 0,
                            right: 0,
                            child: Container(
                              width: double.infinity,
                              height: 1,
                              color: Colors.grey.withValues(alpha: 0.15),
                            ),
                          ),
                        ],
                      ),
                      
                      // Bars - each positioned individually to start from the 0 horizontal line
                      ...List.generate(_currentData.length, (i) {
                        // Calculate bar height as percentage of available space above 0 line
                        // Available space from 0 line to top: 126px (0 line is at 126px from top)
                        // Scale data value (0-100) to fit this space
                        final double barHeight = (_currentData[i] / 100.0) * 126.0;

                        // Calculate horizontal position for each bar
                        final double totalWidth = MediaQuery.of(context).size.width - 32 - 40 - 8; // Subtract padding and Y-axis width
                        final double barSpacing = totalWidth / _currentData.length;
                        final double leftPosition = (i * barSpacing) + (barSpacing / 2) - 8; // Center each bar in its space

                        return Positioned(
                          bottom: 14, // Start from 0 line (126px from top = 14px from bottom of 140px chart)
                          left: leftPosition,
                          child: Container(
                            width: 16,
                            height: barHeight,
                            decoration: const BoxDecoration(
                              color: Color(0xFF16A3AC),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(2),
                                topRight: Radius.circular(2),
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggle(String label, int idx) {
    final bool selected = _selectedIndex == idx;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = idx;
        });
        if (widget.employeeName != null) {
          _loadPerformanceData();
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(7),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
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
            fontSize: 12,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }
}
