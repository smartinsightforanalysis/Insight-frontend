import 'package:flutter/material.dart';

class StaffComparisonChart extends StatefulWidget {
  final String title;
  final List<int> data;
  final List<String> avatars;

  const StaffComparisonChart({
    Key? key,
    required this.title,
    required this.data,
    required this.avatars,
  }) : super(key: key);

  @override
  State<StaffComparisonChart> createState() => _StaffComparisonChartState();
}

class _StaffComparisonChartState extends State<StaffComparisonChart> {
  int _selectedIndex = 0; // 0: D, 1: W, 2: M

  // Responsive helper methods
  double _getResponsiveChartHeight(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 360) {
      return 120.0;
    } else if (screenWidth < 400) {
      return 130.0;
    } else {
      return 140.0;
    }
  }

  double _getResponsiveBarWidth(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 360) {
      return 12.0;
    } else if (screenWidth < 400) {
      return 14.0;
    } else {
      return 16.0;
    }
  }

  double _getResponsiveAvatarRadius(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 360) {
      return 10.0;
    } else if (screenWidth < 400) {
      return 12.0;
    } else {
      return 14.5;
    }
  }

  double _getResponsiveSpacing(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 360) {
      return 8.0;
    } else if (screenWidth < 400) {
      return 10.0;
    } else {
      return 12.0;
    }
  }

  double _getResponsiveTitleFontSize(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 360) {
      return 14.0;
    } else if (screenWidth < 400) {
      return 15.0;
    } else {
      return 16.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final chartHeight = _getResponsiveChartHeight(context);
    final barWidth = _getResponsiveBarWidth(context);
    final avatarRadius = _getResponsiveAvatarRadius(context);
    final spacing = _getResponsiveSpacing(context);
    final titleFontSize = _getResponsiveTitleFontSize(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(spacing + 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
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
                style: TextStyle(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1C3557),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: spacing - 2, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F6FA),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildToggle('D', 0),
                    SizedBox(width: spacing - 4),
                    _buildToggle('W', 1),
                    SizedBox(width: spacing - 4),
                    _buildToggle('M', 2),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: spacing + 4),
          
          // Chart Area with integrated bars and avatars
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Y-axis numbers
              SizedBox(
                height: chartHeight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    for (var y in [100, 75, 50, 25, 0])
                      SizedBox(
                        height: chartHeight / 5,
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
              ),
              SizedBox(width: spacing - 4),

              // Chart bars and avatars in columns for perfect alignment
              Expanded(
                child: Column(
                  children: [
                    // Chart area with bars
                    SizedBox(
                      height: chartHeight,
                      child: Stack(
                        children: [
                          // Grid lines positioned to align exactly with center of Y-axis labels
                          Stack(
                            children: [
                              // 75 line - at center of 75 label
                              Positioned(
                                top: (chartHeight / 5) + (chartHeight / 10) - 0.5,
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
                                top: (chartHeight / 5) * 2 + (chartHeight / 10) - 0.5,
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
                                top: (chartHeight / 5) * 3 + (chartHeight / 10) - 0.5,
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
                                top: (chartHeight / 5) * 4 + (chartHeight / 10) - 0.5,
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
                            bottom: (chartHeight / 10) - 0.5, // Start from 0 line position
                            left: 0,
                            right: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: List.generate(widget.data.length, (i) {
                                // Calculate bar height as percentage of available space above 0 line
                                // Available space from 0 line to top: (chartHeight / 5) * 4 + (chartHeight / 10)
                                final double availableHeight = (chartHeight / 5) * 4 + (chartHeight / 10);
                                final double barHeight = (widget.data[i] / 100.0) * availableHeight;

                                return Padding(
                                  padding: EdgeInsets.symmetric(horizontal: spacing / 2),
                                  child: Container(
                                    width: barWidth,
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
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Avatars row
                    SizedBox(height: spacing),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(widget.avatars.length, (i) {
                        return CircleAvatar(
                          radius: avatarRadius,
                          backgroundImage: AssetImage(widget.avatars[i]),
                        );
                      }),
                    ),
                  ],
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
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = idx;
        });
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
            fontSize: 12,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }
}
