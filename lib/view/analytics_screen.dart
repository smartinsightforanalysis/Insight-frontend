import 'package:flutter/material.dart';
import '../widgets/analytics_app_bar.dart';
import '../widgets/analytics_tabs.dart';
import '../widgets/analytics_events_list.dart';
import '../widgets/analytics_detailed_button.dart';
import '../widgets/frame_snapshots_widget.dart';
import '../widgets/video_review_widget.dart';
import '../widgets/download_report_widget.dart';
import 'detailed_analysis_screen.dart';

class AnalyticsScreen extends StatefulWidget {
  final String userRole;
  const AnalyticsScreen({super.key, required this.userRole});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90),
        child: AnalyticsAppBar(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 8,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnalyticsTabs(
                      selectedIndex: _selectedTab,
                      onTabSelected: (i) => setState(() => _selectedTab = i),
                    ),
                    const SizedBox(height: 16),
                    if (_selectedTab == 0)
                      const _TimeActivityView()
                    else
                      const ZoneMapView(),
                  ],
                ),
              ),
              if (_selectedTab == 1) ...[
                const SizedBox(height: 16),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Zone Breakdown',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                _ZoneBreakdownCard(),
              ],
              if (_selectedTab == 0) ...[
                const SizedBox(height: 16),
                AnalyticsEventsList(),
                const SizedBox(height: 12),
                AnalyticsDetailedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DetailedAnalysisScreen(userRole: widget.userRole),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                FrameSnapshotsWidget(
                  title: 'Frame Snapshots',
                  description: 'Captured from security footage',
                  snapshotImages: const [],
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [],
                  ),
                ),
                const SizedBox(height: 16),
                VideoReviewWidget(
                  title: 'Video Review',
                  description: 'Captured from security footage',
                  videoThumbnail: '',
                ),
                const SizedBox(height: 16),
                if (widget.userRole.toLowerCase() == 'admin')
                  const DownloadReportWidget(),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _DonutChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final double thickness = 28;
    final double gap = 0.04; // radians, for small gap between segments
    final double startAngle = -90 * 3.1415926535 / 180;
    final double sweep = (2 * 3.1415926535 - 3 * gap) / 3;

    final paints = [
      Paint()
        ..color =
            Color(0xFFF97316) // orange
        ..style = PaintingStyle.stroke
        ..strokeWidth = thickness
        ..strokeCap = StrokeCap.butt,
      Paint()
        ..color =
            Color(0xFF14B8A6) // teal
        ..style = PaintingStyle.stroke
        ..strokeWidth = thickness
        ..strokeCap = StrokeCap.butt,
      Paint()
        ..color =
            Color(0xFFFACC15) // yellow
        ..style = PaintingStyle.stroke
        ..strokeWidth = thickness
        ..strokeCap = StrokeCap.butt,
    ];

    double angle = startAngle;
    for (int i = 0; i < 3; i++) {
      canvas.drawArc(
        rect.deflate(thickness / 2),
        angle,
        sweep,
        false,
        paints[i],
      );
      angle += sweep + gap;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            color: Color(0xFF4B5563),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _TimeActivityView extends StatelessWidget {
  const _TimeActivityView();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Center(
            child: SizedBox(
              height: 220,
              width: 260,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CustomPaint(
                    size: const Size(220, 220),
                    painter: _DonutChartPainter(),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        'Total Events',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFF737373),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '7',
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _LegendItem(color: Color(0xFF14B8A6), label: 'Incident'),
            const SizedBox(width: 24),
            _LegendItem(color: Color(0xFFF97316), label: 'Behaviour'),
            const SizedBox(width: 24),
            _LegendItem(color: Color(0xFFFACC15), label: 'Awaytime'),
          ],
        ),
      ],
    );
  }
}

class ZoneMapView extends StatelessWidget {
  const ZoneMapView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isSmall = screenWidth < 400;
    // Sizes for backgrounds and cards
    final double bgWidth = isSmall ? 155 : 195;
    final double bgHeight = isSmall ? 85 : 105;
    final double cardWidth = isSmall ? 120 : 155;
    final double cardHeight = isSmall ? 53 : 65;
    final double cardFont = isSmall ? 13 : 14;
    final double subtitleFont = isSmall ? 11 : 12;
    final double cardTitleSpace = isSmall ? 3 : 4;
    return Container(
      width: double.infinity,
      child: Stack(
        children: [
          // Zone Map
          Container(
            width: double.infinity,
            height: isSmall ? 250 : 340,
            child: Stack(
              children: [
                // Service Counter background
                Positioned(
                  left: 0,
                  top: 10,
                  child: _ZoneBgCard(
                    width: bgWidth,
                    height: bgHeight,
                    color: Color(0x33FACC15), // #FACC15 with 20% opacity
                    borderRadius: 8,
                  ),
                ),
                // Customer Area background
                Positioned(
                  left: isSmall ? 120 : 170,
                  top: isSmall ? 70 : 100,
                  child: _ZoneBgCard(
                    width: bgWidth,
                    height: bgHeight,
                    color: Color(0x3322D3A8), // #22D3A8 with 20% opacity
                    borderRadius: 8,
                  ),
                ),
                // Service Area background
                Positioned(
                  left: isSmall ? 55 : 80,
                  top: isSmall ? 150 : 200,
                  child: _ZoneBgCard(
                    width: bgWidth,
                    height: bgHeight,
                    color: Color(0x33FDBA74), // #FDBA74 with 20% opacity
                    borderRadius: 8,
                  ),
                ),

                // Service Counter card
                Positioned(
                  left: isSmall ? 15 : 20,
                  top: isSmall ? 25 : 30,
                  child: _ZoneCardStyled(
                    label: 'Service Counter',
                    incidents: 3,
                    incidentLabel: 'Incident',
                    width: cardWidth,
                    height: cardHeight,
                    shadow: true,
                    fontSize: cardFont,
                    subtitleFontSize: subtitleFont,
                    subtitleSpace: cardTitleSpace,
                  ),
                ),
                // Customer Area card
                Positioned(
                  left: isSmall ? 135 : 190,
                  top: isSmall ? 85 : 120,
                  child: _ZoneCardStyled(
                    label: 'Customer Area',
                    incidents: 1,
                    incidentLabel: 'incident',
                    width: cardWidth,
                    height: cardHeight,
                    shadow: true,
                    fontSize: cardFont,
                    subtitleFontSize: subtitleFont,
                    subtitleSpace: cardTitleSpace,
                  ),
                ),
                // Service Area card
                Positioned(
                  left: isSmall ? 70 : 100,
                  top: isSmall ? 165 : 220,
                  child: _ZoneCardStyled(
                    label: 'Service Area',
                    incidents: 0,
                    incidentLabel: 'incident',
                    width: cardWidth,
                    height: cardHeight,
                    shadow: true,
                    fontSize: cardFont,
                    subtitleFontSize: subtitleFont,
                    subtitleSpace: cardTitleSpace,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: isSmall ? 24 : 40),
        ],
      ),
    );
  }
}

class _ZoneBgCard extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final double borderRadius;
  const _ZoneBgCard({
    required this.width,
    required this.height,
    required this.color,
    this.borderRadius = 24,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}

class _ZoneCardStyled extends StatelessWidget {
  final String label;
  final int incidents;
  final String incidentLabel;
  final double width;
  final double height;
  final bool shadow;
  final double fontSize;
  final double subtitleFontSize;
  final double subtitleSpace;
  const _ZoneCardStyled({
    required this.label,
    required this.incidents,
    required this.incidentLabel,
    required this.width,
    required this.height,
    this.shadow = false,
    this.fontSize = 14,
    this.subtitleFontSize = 12,
    this.subtitleSpace = 4,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: shadow
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.13),
                  blurRadius: 16,
                  offset: Offset(0, 8),
                ),
              ]
            : [],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            SizedBox(height: subtitleSpace),
            Text(
              '${incidents} $incidentLabel',
              style: TextStyle(
                fontSize: subtitleFontSize,
                fontWeight: FontWeight.w400,
                color: Color(0xFF4B5563),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ZoneBreakdownCard extends StatelessWidget {
  const _ZoneBreakdownCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Service Counter',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          Table(
            columnWidths: const {0: FlexColumnWidth(1), 1: FlexColumnWidth(1)},
            children: const [
              TableRow(
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: Text(
                      'Time Spent',
                      style: TextStyle(fontSize: 15, color: Color(0xFF6B7280)),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Incidents',
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              TableRow(
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 16),
                    child: Text(
                      '1 hr 21 min',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 16),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '3',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              TableRow(
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: Text(
                      'Behaviour',
                      style: TextStyle(fontSize: 15, color: Color(0xFF6B7280)),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Away Time',
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              TableRow(
                children: [
                  Text(
                    '89%',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '1 time',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
