import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:insight/l10n/app_localizations.dart';
import 'package:insight/widgets/analytics_export_dialog.dart';
import 'share_analysis_screen.dart';
import '../services/ai_api_service.dart';

class DetailedAnalysisScreen extends StatefulWidget {
  final String userRole;
  const DetailedAnalysisScreen({super.key, required this.userRole});

  @override
  State<DetailedAnalysisScreen> createState() => _DetailedAnalysisScreenState();
}

class _DetailedAnalysisScreenState extends State<DetailedAnalysisScreen> {
  final AiApiService _aiApiService = AiApiService();
  bool _isLoading = true;
  int _totalEvents = 0;
  int _incidentEvents = 0;
  int _behaviorEvents = 0;
  int _awayTimeEvents = 0;
  String _incidentPeakTime = '';
  String _behaviorPeakTime = '';
  String _awayTimePeakTime = '';

  @override
  void initState() {
    super.initState();
    _loadAnalyticsData();
  }

  Future<void> _loadAnalyticsData() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final response = await _aiApiService.getAnalyticsEvents(period: '24hr');

      setState(() {
        _totalEvents = response['total_events'] ?? 0;
        _incidentEvents = response['incident_events'] ?? 0;
        _behaviorEvents = response['behavior_events'] ?? 0;
        _awayTimeEvents = response['away_time_events'] ?? 0;

        // Calculate peak times from timeline data
        _calculatePeakTimes(response['timeline'] ?? []);

        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading analytics data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _calculatePeakTimes(List<dynamic> timeline) {
    // Group events by hour and type
    Map<String, Map<int, int>> eventsByHour = {
      'incident': {},
      'behavior': {},
      'away_time': {},
    };

    for (var event in timeline) {
      final type = event['type'] as String?;
      final timestamp = event['timestamp'] as String?;

      if (type != null && timestamp != null) {
        try {
          DateTime dateTime;

          if (timestamp.contains('T')) {
            if (timestamp.startsWith('2025-')) {
              // ISO format: "2025-07-17T09:40:00"
              dateTime = DateTime.parse(timestamp);
            } else {
              // Custom format: "6/16/2025T15:20:52"
              final parts = timestamp.split('T');
              if (parts.length == 2) {
                final datePart = parts[0];
                final timePart = parts[1];
                final dateComponents = datePart.split('/');
                if (dateComponents.length == 3) {
                  final month = int.parse(dateComponents[0]);
                  final day = int.parse(dateComponents[1]);
                  final year = int.parse(dateComponents[2]);
                  final timeComponents = timePart.split(':');
                  final hour = int.parse(timeComponents[0]);
                  final minute = int.parse(timeComponents[1]);
                  final second = int.parse(timeComponents[2]);
                  dateTime = DateTime(year, month, day, hour, minute, second);
                } else {
                  continue;
                }
              } else {
                continue;
              }
            }
          } else {
            continue;
          }

          final hour = dateTime.hour;
          eventsByHour[type] = eventsByHour[type] ?? {};
          eventsByHour[type]![hour] = (eventsByHour[type]![hour] ?? 0) + 1;
        } catch (e) {
          debugPrint('Error parsing timestamp: $timestamp, error: $e');
          continue;
        }
      }
    }

    // Find peak hours for each type
    _incidentPeakTime = _findPeakTime(eventsByHour['incident'] ?? {});
    _behaviorPeakTime = _findPeakTime(eventsByHour['behavior'] ?? {});
    _awayTimePeakTime = _findPeakTime(eventsByHour['away_time'] ?? {});
  }

  String _findPeakTime(Map<int, int> hourCounts) {
    if (hourCounts.isEmpty) return '';

    int maxCount = 0;
    int peakHour = 0;

    hourCounts.forEach((hour, count) {
      if (count > maxCount) {
        maxCount = count;
        peakHour = hour;
      }
    });

    // Format hour as 12-hour format
    if (peakHour == 0) return '12:00 AM';
    if (peakHour < 12) return '$peakHour:00 AM';
    if (peakHour == 12) return '12:00 PM';
    return '${peakHour - 12}:00 PM';
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
            bottom: BorderSide(
              color: Color(0xFFE5E7EB),
              width: 1,
            ),
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
                    Builder(
                      builder: (context) {
                        final width = MediaQuery.of(context).size.width;
                        final isSmall = width < 350;
                        return Text(
                          localizations.analytics,
                          style: TextStyle(
                            fontSize: isSmall ? 16 : 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          overflow: TextOverflow.ellipsis,
                        );
                      },
                    ),
                    const SizedBox(height: 4),
                    Builder(
                      builder: (context) {
                        final width = MediaQuery.of(context).size.width;
                        final isSmall = width < 350;
                        return Text(
                          localizations.last24HoursDetailedActivity,
                          style: TextStyle(
                            fontSize: isSmall ? 10 : 14,
                            color: Color(0xFF4B5563),
                          ),
                          overflow: TextOverflow.ellipsis,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            if (widget.userRole.toLowerCase() == 'admin')
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: OutlinedButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => const AnalyticsExportDialog(),
                      );
                    },
                    icon: SvgPicture.asset(
                      'assets/export.svg',
                      width: 16,
                      height: 16,
                      colorFilter: ColorFilter.mode(Color(0xFF374151), BlendMode.srcIn),
                    ),
                    label: Text(
                      localizations.export,
                      style: const TextStyle(color: Color(0xFF1C3557), fontWeight: FontWeight.w600),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFE5E7EB)),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.only(left: 6, right: 16, top: 8, bottom: 8),
                    ),
                  ),
                ),
              ),
          ],
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
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
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
                              if (!_isLoading)
                                CustomPaint(
                                  size: const Size(220, 220),
                                  painter: _DonutChartPainter(
                                    incidentEvents: _incidentEvents,
                                    behaviorEvents: _behaviorEvents,
                                    awayTimeEvents: _awayTimeEvents,
                                  ),
                                ),
                              if (_isLoading)
                                const CircularProgressIndicator(
                                  color: Color(0xFF209A9F),
                                )
                              else
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(localizations.totalEvents, style: const TextStyle(fontSize: 18, color: Color(0xFF737373), fontWeight: FontWeight.w500)),
                                    const SizedBox(height: 8),
                                    Text('$_totalEvents', style: const TextStyle(fontSize: 35, fontWeight: FontWeight.bold, color: Colors.black)),
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
                  if (_isLoading) {
                    return Row(
                      children: [
                        _LoadingEventCard(
                          width: cardWidth > 0 ? cardWidth : null,
                          isCompact: isCompact,
                        ),
                        SizedBox(width: spacing),
                        _LoadingEventCard(
                          width: cardWidth > 0 ? cardWidth : null,
                          isCompact: isCompact,
                        ),
                        SizedBox(width: spacing),
                        _LoadingEventCard(
                          width: cardWidth > 0 ? cardWidth : null,
                          isCompact: isCompact,
                        ),
                      ],
                    );
                  } else {
                    return Row(
                      children: [
                        _EventTypeCard(
                          color: Color(0xFF14B8A6),
                          title: localizations.incident,
                          count: _incidentEvents,
                          peak: _incidentEvents > 0 ? _incidentPeakTime : '',
                          width: cardWidth > 0 ? cardWidth : null,
                          isCompact: isCompact,
                        ),
                        SizedBox(width: spacing),
                        _EventTypeCard(
                          color: Color(0xFFF97316),
                          title: localizations.behaviour,
                          count: _behaviorEvents,
                          peak: _behaviorEvents > 0 ? _behaviorPeakTime : '',
                          width: cardWidth > 0 ? cardWidth : null,
                          isCompact: isCompact,
                        ),
                        SizedBox(width: spacing),
                        _EventTypeCard(
                          color: Color(0xFFFACC15),
                          title: localizations.awaytime,
                          count: _awayTimeEvents,
                          peak: _awayTimeEvents > 0 ? _awayTimePeakTime : '',
                          width: cardWidth > 0 ? cardWidth : null,
                          isCompact: isCompact,
                        ),
                      ],
                    );
                  }
                },
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        localizations.eventTimeSegments,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _EventTimeTable(userRole: widget.userRole),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DonutChartPainter extends CustomPainter {
  final int incidentEvents;
  final int behaviorEvents;
  final int awayTimeEvents;

  _DonutChartPainter({
    required this.incidentEvents,
    required this.behaviorEvents,
    required this.awayTimeEvents,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final double thickness = 28;
    final double gap = 0.04; // radians, for small gap between segments
    final double startAngle = -90 * 3.1415926535 / 180;

    final total = incidentEvents + behaviorEvents + awayTimeEvents;
    if (total == 0) return; // Don't draw anything if no events

    // Calculate sweep angles based on proportions
    final double totalSweep = 2 * 3.1415926535 - 3 * gap;
    final double incidentSweep = (incidentEvents / total) * totalSweep;
    final double behaviorSweep = (behaviorEvents / total) * totalSweep;
    final double awayTimeSweep = (awayTimeEvents / total) * totalSweep;

    final paints = [
      Paint()
        ..color = Color(0xFF14B8A6) // teal for incidents
        ..style = PaintingStyle.stroke
        ..strokeWidth = thickness
        ..strokeCap = StrokeCap.butt,
      Paint()
        ..color = Color(0xFFF97316) // orange for behavior
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
    final sweeps = [incidentSweep, behaviorSweep, awayTimeSweep];

    for (int i = 0; i < 3; i++) {
      if (sweeps[i] > 0) {
        canvas.drawArc(
          rect.deflate(thickness / 2),
          angle,
          sweeps[i],
          false,
          paints[i],
        );
        angle += sweeps[i] + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is _DonutChartPainter) {
      return oldDelegate.incidentEvents != incidentEvents ||
             oldDelegate.behaviorEvents != behaviorEvents ||
             oldDelegate.awayTimeEvents != awayTimeEvents;
    }
    return true;
  }
}

class _LoadingEventCard extends StatelessWidget {
  final double? width;
  final bool isCompact;

  const _LoadingEventCard({
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
                decoration: const BoxDecoration(
                  color: Color(0xFFE5E7EB),
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: isCompact ? 4 : 6),
              Container(
                width: isCompact ? 40 : 60,
                height: isCompact ? 13 : 15,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
          SizedBox(height: isCompact ? 4 : 8),
          Container(
            width: isCompact ? 20 : 30,
            height: isCompact ? 17 : 22,
            decoration: BoxDecoration(
              color: const Color(0xFFE5E7EB),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          SizedBox(height: isCompact ? 2 : 4),
          Container(
            width: isCompact ? 50 : 70,
            height: isCompact ? 11 : 13,
            decoration: BoxDecoration(
              color: const Color(0xFFE5E7EB),
              borderRadius: BorderRadius.circular(4),
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

class _EventTypeCard extends StatelessWidget {
  final Color color;
  final String title;
  final int count;
  final String peak;
  final double? width;
  final bool isCompact;
  const _EventTypeCard({required this.color, required this.title, required this.count, required this.peak, this.width, this.isCompact = false});

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
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
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
          SizedBox(
            height: isCompact ? 11 : 13,
            child: peak.isNotEmpty
                ? Text(
                    '${AppLocalizations.of(context)!.peak}: $peak',
                    style: TextStyle(
                      fontSize: isCompact ? 11 : 13,
                      color: Color(0xFF6B7280),
                    ),
                  )
                : const SizedBox.shrink(),
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

class _EventTimeTable extends StatefulWidget {
  final String userRole;
  const _EventTimeTable({required this.userRole});

  @override
  State<_EventTimeTable> createState() => _EventTimeTableState();
}

class _EventTimeTableState extends State<_EventTimeTable> {
  final AiApiService _aiApiService = AiApiService();
  bool _isLoading = true;
  List<Map<String, dynamic>> _timeSegments = [];

  @override
  void initState() {
    super.initState();
    _loadTimeSegmentsData();
  }

  Future<void> _loadTimeSegmentsData() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final response = await _aiApiService.getAnalyticsEventTimeSegments(period: '24hr');

      setState(() {
        _timeSegments = _parseTimeSegments(response['time_segments'] ?? {});
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading time segments data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<Map<String, dynamic>> _parseTimeSegments(Map<String, dynamic> segments) {
    final List<Map<String, dynamic>> parsedSegments = [];

    // Define the order of segments
    final segmentOrder = ['night', 'morning', 'afternoon', 'evening'];

    for (String segmentKey in segmentOrder) {
      if (segments.containsKey(segmentKey)) {
        final segment = segments[segmentKey];
        parsedSegments.add({
          'timeRange': _formatTimeRange(segment['time_range'] ?? ''),
          'incidentCount': segment['incident_count'] ?? 0,
          'behaviorCount': segment['behavior_count'] ?? 0,
          'awayTimeCount': segment['away_time_count'] ?? 0,
        });
      }
    }

    return parsedSegments;
  }

  String _formatTimeRange(String timeRange) {
    if (timeRange.isEmpty) return '';

    // Convert 24-hour format to 12-hour format
    final parts = timeRange.split('-');
    if (parts.length != 2) return timeRange;

    final startTime = _formatTime(parts[0]);
    final endTime = _formatTime(parts[1]);

    return '$startTime - $endTime';
  }

  String _formatTime(String time) {
    try {
      final parts = time.split(':');
      if (parts.length < 2) return time;

      int hour = int.parse(parts[0]);
      final minute = parts[1];

      if (hour == 0) return '12:$minute AM';
      if (hour < 12) return '$hour:$minute AM';
      if (hour == 12) return '12:$minute PM';
      return '${hour - 12}:$minute PM';
    } catch (e) {
      return time;
    }
  }

  @override
  Widget build(BuildContext context) {
    final rows = _isLoading
        ? [
            _loadingTimeRow(),
            _loadingTimeRow(),
            _loadingTimeRow(),
          ]
        : _timeSegments.map((segment) => _eventTimeRow(
            context,
            segment['timeRange'],
            segment['incidentCount'],
            segment['behaviorCount'],
            segment['awayTimeCount'],
            widget.userRole,
            segment, // Pass the full segment data
          )).toList();
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(2.5),
        1: FlexColumnWidth(1.3),
        2: FlexColumnWidth(1.3),
        3: FlexColumnWidth(1.7),
        4: FlexColumnWidth(0.7),
      },
      border: TableBorder(horizontalInside: BorderSide(color: Color(0xFFF3F4F6))),
      children: [
        TableRow(
          decoration: const BoxDecoration(color: Color(0xFFF9FAFB)),
          children: [
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.top,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                child: Text(AppLocalizations.of(context)!.timeRange, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF6B7280), fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
              ),
            ),
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.top,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                child: Text(AppLocalizations.of(context)!.incident, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF6B7280), fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
              ),
            ),
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.top,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        AppLocalizations.of(context)!.behaviour,
                        style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF6B7280), fontSize: 12),
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
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                child: Text(AppLocalizations.of(context)!.awayTime, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF6B7280), fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
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
    );
  }

  TableRow _loadingTimeRow() {
    return TableRow(
      decoration: const BoxDecoration(color: Colors.white),
      children: [
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.top,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            child: Container(
              width: 80,
              height: 14,
              decoration: BoxDecoration(
                color: const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.top,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 18),
                Container(
                  width: 20,
                  height: 14,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5E7EB),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        ),
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.top,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 18),
                Container(
                  width: 20,
                  height: 14,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5E7EB),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        ),
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.top,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 18),
                Container(
                  width: 20,
                  height: 14,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5E7EB),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        ),
        const TableCell(
          verticalAlignment: TableCellVerticalAlignment.top,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 18),
              Center(
                child: SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Color(0xFFE5E7EB),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static TableRow _eventTimeRow(BuildContext context, String time, int incident, int behaviour, int away, String userRole, [Map<String, dynamic>? segmentData]) {
    final parts = time.split(' - ');
    final formattedTime = parts.length == 2 ? '${parts[0]} - \n${parts[1]}' : time;
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
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ShareAnalysisScreen(
                          incident: incident,
                          behaviour: behaviour,
                          away: away,
                          timeRange: time,
                          userRole: userRole,
                          segmentData: segmentData,
                        ),
                      ),
                    );
                  },
                  child: Icon(Icons.open_in_new, size: 18, color: Color(0xFF209A9F)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
} 