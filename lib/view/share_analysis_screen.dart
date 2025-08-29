import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:insight/l10n/app_localizations.dart';
import 'package:insight/view/download_progress_screen.dart';
import '../services/ai_api_service.dart';

class ShareAnalysisScreen extends StatefulWidget {
  final int incident;
  final int behaviour;
  final int away;
  final String timeRange;
  final String userRole;
  final Map<String, dynamic>? segmentData;

  const ShareAnalysisScreen({
    Key? key,
    required this.incident,
    required this.behaviour,
    required this.away,
    required this.timeRange,
    required this.userRole,
    this.segmentData,
  }) : super(key: key);

  @override
  State<ShareAnalysisScreen> createState() => _ShareAnalysisScreenState();
}

class _ShareAnalysisScreenState extends State<ShareAnalysisScreen> {
  final AiApiService _aiApiService = AiApiService();
  Map<String, dynamic>? _eventTimeSegments;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadEventTimeSegments();
  }

  Future<void> _loadEventTimeSegments() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final response = await _aiApiService.getEventTimeSegments(period: '24hr');

      setState(() {
        _eventTimeSegments = response;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load event data: $e';
        _isLoading = false;
      });
    }
  }

  // Helper method to get segment data based on time range
  Map<String, dynamic>? _getSegmentData() {
    if (_eventTimeSegments == null || _eventTimeSegments!['time_segments'] == null) {
      return null;
    }

    final timeSegments = _eventTimeSegments!['time_segments'] as Map<String, dynamic>;

    // Map time ranges to segment keys
    switch (widget.timeRange.toLowerCase()) {
      case '06:00 - 12:00':
      case 'morning':
        return timeSegments['morning'];
      case '12:00 - 18:00':
      case 'afternoon':
        return timeSegments['afternoon'];
      case '18:00 - 24:00':
      case 'evening':
        return timeSegments['evening'];
      case '00:00 - 06:00':
      case 'night':
        return timeSegments['night'];
      default:
        // Try to find by partial match
        for (final entry in timeSegments.entries) {
          final segmentData = entry.value as Map<String, dynamic>;
          if (segmentData['time_range'] == widget.timeRange) {
            return segmentData;
          }
        }
        return null;
    }
  }

  // Helper method to get incident details from API data
  List<Map<String, String>> _getIncidentDetails(AppLocalizations localizations) {
    final segmentData = _getSegmentData();

    if (segmentData == null) {
      // Fallback to default values if no API data
      return [
        {'label': localizations.incidentStartTime, 'value': '--:--:--'},
        {'label': localizations.incidentEndTime, 'value': '--:--:--'},
        {'label': localizations.staffInvolve, 'value': '0'},
        {'label': localizations.duration, 'value': '0m 0s'},
        {'label': localizations.incidentType, 'value': 'N/A'},
        {'label': localizations.zone, 'value': 'N/A'},
      ];
    }

    return [
      {
        'label': localizations.incidentStartTime,
        'value': segmentData['incident_start_time']?.toString() ?? '--:--:--'
      },
      {
        'label': localizations.incidentEndTime,
        'value': segmentData['incident_end_time']?.toString() ?? '--:--:--'
      },
      {
        'label': localizations.staffInvolve,
        'value': segmentData['staff_involved']?.toString() ?? '0'
      },
      {
        'label': localizations.duration,
        'value': segmentData['duration_formatted']?.toString() ?? '0m 0s'
      },
      {
        'label': localizations.incidentType,
        'value': segmentData['incident_type']?.toString() ?? 'N/A'
      },
      {
        'label': localizations.zone,
        'value': segmentData['zone']?.toString() ?? 'N/A'
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
          toolbarHeight: kToolbarHeight + 10,
          shape: const Border(
            bottom: BorderSide(color: Color(0xFFE5E7EB), width: 1),
          ),
          titleSpacing: 0,
          title: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
                onPressed: () => Navigator.of(context).pop(),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localizations.eventTimeSegments,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text(
                          widget.timeRange,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color(0xFF374151),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 22,
                          color: Color(0xFF374151),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: widget.userRole.toLowerCase() == 'admin'
                    ? OutlinedButton.icon(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  const DownloadProgressScreen(),
                            ),
                          );
                        },
                        icon: SvgPicture.asset(
                          'assets/export.svg',
                          width: 16,
                          height: 16,
                          colorFilter: const ColorFilter.mode(
                            Color(0xFF374151),
                            BlendMode.srcIn,
                          ),
                        ),
                        label: Text(
                          localizations.export,
                          style: const TextStyle(
                            color: Color(0xFF1C3557),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFE5E7EB)),
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.only(
                            left: 6,
                            right: 16,
                            top: 8,
                            bottom: 8,
                          ),
                        ),
                      )
                    : SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 4),
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
                                painter: _DonutChartPainter(
                                  incident: widget.incident,
                                  behaviour: widget.behaviour,
                                  away: widget.away,
                                ),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    localizations.totalEvents,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Color(0xFF737373),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '${widget.incident + widget.behaviour + widget.away}',
                                    style: const TextStyle(
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
                  ],
                ),
              ),
              const SizedBox(height: 16),
              LayoutBuilder(
                builder: (context, constraints) {
                  double cardWidth = 0;
                  double spacing = 12;
                  bool isCompact = false;
                  if (constraints.maxWidth < 370) {
                    cardWidth = (constraints.maxWidth - 2 * spacing) / 3;
                    if (cardWidth < 110) isCompact = true;
                  }
                  return Row(
                    children: [
                      _EventTypeCard(
                        color: Color(0xFF14B8A6),
                        title: localizations.incident,
                        count: widget.incident,
                        peak: widget.incident > 0 ? _getEventDescription(widget.incident, 'incident') : localizations.noEvent,
                        width: cardWidth > 0 ? cardWidth : null,
                        isCompact: isCompact,
                      ),
                      SizedBox(width: spacing),
                      _EventTypeCard(
                        color: Color(0xFFF97316),
                        title: localizations.behaviour,
                        count: widget.behaviour,
                        peak: widget.behaviour > 0 ? _getEventDescription(widget.behaviour, 'behaviour') : localizations.noEvent,
                        width: cardWidth > 0 ? cardWidth : null,
                        isCompact: isCompact,
                      ),
                      SizedBox(width: spacing),
                      _EventTypeCard(
                        color: Color(0xFFFACC15),
                        title: localizations.awaytime,
                        count: widget.away,
                        peak: widget.away > 0 ? _getEventDescription(widget.away, 'awaytime') : localizations.noEvent,
                        width: cardWidth > 0 ? cardWidth : null,
                        isCompact: isCompact,
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 16),
              const IncidentHeatmapWidget(),
              IncidentDetailsGrid(
                details: _getIncidentDetails(localizations),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getEventDescription(int count, String type) {
    if (count == 0) return 'No event';

    switch (type) {
      case 'incident':
        return count == 1 ? '1 incident' : '$count incidents';
      case 'behaviour':
        return count == 1 ? '1 behavior' : '$count behaviors';
      case 'awaytime':
        return count == 1 ? '1 away time' : '$count away times';
      default:
        return count == 1 ? '1 event' : '$count events';
    }
  }
}

// --- Donut chart, event type card, and event time table widgets copied from detailed_analysis_screen.dart ---

class _DonutChartPainter extends CustomPainter {
  final int incident;
  final int behaviour;
  final int away;

  _DonutChartPainter({
    required this.incident,
    required this.behaviour,
    required this.away,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final double thickness = 28;
    final double gap = 0.04; // radians, for small gap between segments
    final double startAngle = -90 * 3.1415926535 / 180;

    final int totalEvents = incident + behaviour + away;

    // If no events, show equal segments or a gray circle
    if (totalEvents == 0) {
      final double sweep = (2 * 3.1415926535 - 3 * gap) / 3;
      final paints = [
        Paint()
          ..color = Color(0xFFE5E7EB) // gray for no data
          ..style = PaintingStyle.stroke
          ..strokeWidth = thickness
          ..strokeCap = StrokeCap.butt,
        Paint()
          ..color = Color(0xFFE5E7EB) // gray for no data
          ..style = PaintingStyle.stroke
          ..strokeWidth = thickness
          ..strokeCap = StrokeCap.butt,
        Paint()
          ..color = Color(0xFFE5E7EB) // gray for no data
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
      return;
    }

    // Calculate proportional sweep angles based on actual data
    final double totalSweep = 2 * 3.1415926535 - 3 * gap;
    final double behaviourSweep = (behaviour / totalEvents) * totalSweep;
    final double incidentSweep = (incident / totalEvents) * totalSweep;
    final double awaySweep = (away / totalEvents) * totalSweep;

    final paints = [
      Paint()
        ..color = Color(0xFFF97316) // orange for behaviour
        ..style = PaintingStyle.stroke
        ..strokeWidth = thickness
        ..strokeCap = StrokeCap.butt,
      Paint()
        ..color = Color(0xFF14B8A6) // teal for incident
        ..style = PaintingStyle.stroke
        ..strokeWidth = thickness
        ..strokeCap = StrokeCap.butt,
      Paint()
        ..color = Color(0xFFFACC15) // yellow for away time
        ..style = PaintingStyle.stroke
        ..strokeWidth = thickness
        ..strokeCap = StrokeCap.butt,
    ];

    double angle = startAngle;

    // Draw behaviour segment (orange)
    if (behaviour > 0) {
      canvas.drawArc(
        rect.deflate(thickness / 2),
        angle,
        behaviourSweep,
        false,
        paints[0],
      );
      angle += behaviourSweep + gap;
    }

    // Draw incident segment (teal)
    if (incident > 0) {
      canvas.drawArc(
        rect.deflate(thickness / 2),
        angle,
        incidentSweep,
        false,
        paints[1],
      );
      angle += incidentSweep + gap;
    }

    // Draw away time segment (yellow)
    if (away > 0) {
      canvas.drawArc(
        rect.deflate(thickness / 2),
        angle,
        awaySweep,
        false,
        paints[2],
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is! _DonutChartPainter) return true;
    return oldDelegate.incident != incident ||
           oldDelegate.behaviour != behaviour ||
           oldDelegate.away != away;
  }
}

class _EventTypeCard extends StatelessWidget {
  final Color color;
  final String title;
  final int count;
  final String peak;
  final double? width;
  final bool isCompact;
  const _EventTypeCard({
    required this.color,
    required this.title,
    required this.count,
    required this.peak,
    this.width,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    final card = Container(
      padding: EdgeInsets.symmetric(
        vertical: isCompact ? 10 : 16,
        horizontal: isCompact ? 4 : 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: isCompact ? 8 : 10,
                height: isCompact ? 8 : 10,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              SizedBox(width: isCompact ? 4 : 6),
              Flexible(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: isCompact ? 13 : 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF4B5563),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: isCompact ? 4 : 8),
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: isCompact ? 17 : 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: isCompact ? 2 : 4),
          Text(
            peak,
            style: TextStyle(
              fontSize: isCompact ? 11 : 13,
              color: Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
    if (width != null) {
      return SizedBox(width: width, child: card);
    } else {
      return Expanded(child: card);
    }
  }
}

class _EventTimeTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final rows = [
      _EventTimeRow('08:00 - 09:00 AM', 1, 0, 0),
      _EventTimeRow('09:00 - 10:00 AM', 0, 1, 0),
      _EventTimeRow('10:00 - 11:00 AM', 2, 2, 1),
    ];
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(2.5),
          1: FlexColumnWidth(1.3),
          2: FlexColumnWidth(1.3),
          3: FlexColumnWidth(1.7),
          4: FlexColumnWidth(0.7),
        },
        border: TableBorder(
          horizontalInside: BorderSide(color: Color(0xFFF3F4F6)),
        ),
        children: [
          TableRow(
            decoration: const BoxDecoration(color: Color(0xFFF9FAFB)),
            children: [
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.top,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 12,
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.timeRange,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF6B7280),
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.top,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 0,
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.incident,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF6B7280),
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.top,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 0,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          AppLocalizations.of(context)!.behaviour,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF6B7280),
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 8),
                    ],
                  ),
                ),
              ),
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.top,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 0,
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.awayTime,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF6B7280),
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.top,
                child: SizedBox.shrink(),
              ),
            ],
          ),
          ...rows,
        ],
      ),
    );
  }
}

TableRow _EventTimeRow(String time, int incident, int behaviour, int away) {
  final parts = time.split(' - ');
  final formattedTime = parts.length == 2 ? '${parts[0]} -\n${parts[1]}' : time;
  return TableRow(
    decoration: const BoxDecoration(color: Colors.white),
    children: [
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.top,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          child: Text(
            formattedTime,
            style: const TextStyle(fontSize: 14, color: Color(0xFF374151)),
            maxLines: 2,
          ),
        ),
      ),
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.top,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 18),
              Text(
                incident.toString(),
                style: const TextStyle(fontSize: 14, color: Color(0xFF374151)),
              ),
            ],
          ),
        ),
      ),
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.top,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 18),
              Text(
                behaviour.toString(),
                style: const TextStyle(fontSize: 14, color: Color(0xFF374151)),
              ),
            ],
          ),
        ),
      ),
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.top,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 18),
              Text(
                away.toString(),
                style: const TextStyle(fontSize: 14, color: Color(0xFF374151)),
              ),
            ],
          ),
        ),
      ),
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.top,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 18),
            Center(
              child: Icon(
                Icons.open_in_new,
                size: 18,
                color: Color(0xFF209A9F),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

class IncidentHeatmapWidget extends StatelessWidget {
  const IncidentHeatmapWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4.0, bottom: 12.0),
            child: Text(
              AppLocalizations.of(context)!.incidentAnalysis,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'assets/incident.png',
                fit: BoxFit.contain,
                width: double.infinity,
                height: 260,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class IncidentDetailsGrid extends StatelessWidget {
  final List<Map<String, String>> details;

  const IncidentDetailsGrid({
    Key? key,
    required this.details,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16, bottom: 16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 10,
            spreadRadius: 0,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 500;
            return Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: List.generate(details.length, (i) {
                return SizedBox(
                  width: isWide
                      ? (constraints.maxWidth - 32) / 3
                      : (constraints.maxWidth - 24) / 2,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 18,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.07),
                          blurRadius: 10,
                          spreadRadius: 0,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          details[i]['label']!,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF6B7280),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          details[i]['value']!,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: i == 4 || i == 5
                                ? FontWeight.bold
                                : FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            );
          },
        ),
      ),
    );
  }
}
