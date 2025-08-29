import 'package:flutter/material.dart';
import 'package:insight/l10n/app_localizations.dart';
import '../widgets/analytics_app_bar.dart';
import '../widgets/analytics_tabs.dart';
import '../widgets/analytics_events_list.dart';
import '../widgets/analytics_detailed_button.dart';
import '../widgets/frame_snapshots_widget.dart';

import '../widgets/download_report_widget.dart';
import 'detailed_analysis_screen.dart';
import '../services/ai_api_service.dart';

class AnalyticsScreen extends StatefulWidget {
  final String userRole;
  const AnalyticsScreen({super.key, required this.userRole});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  int _selectedTab = 0;

  // Zone data state (shared between ZoneMapView and ZoneBreakdownCard)
  List<Map<String, dynamic>> _zones = [];
  bool _isLoadingZoneMap = true;
  final AiApiService _aiApiService = AiApiService();

  // Frame snapshots state
  List<String> _employeeSnapshots = [];
  bool _isLoadingSnapshots = true;
  String? _snapshotsError;

  @override
  void initState() {
    super.initState();
    _loadEmployeeSnapshots();
    _loadZoneMapData();
  }

  Future<void> _loadZoneMapData() async {
    try {
      setState(() {
        _isLoadingZoneMap = true;
      });

      print('🔍 Fetching zone map data for analytics');
      final response = await _aiApiService.getAnalyticsZoneMap();
      print('📊 Zone map API response: $response');

      // Extract zones data from the response
      if (response['zone_map'] != null && response['zone_map']['zones'] != null) {
        final zones = List<Map<String, dynamic>>.from(response['zone_map']['zones']);

        print('✅ Found ${zones.length} zones for analytics');
        setState(() {
          _zones = zones;
          _isLoadingZoneMap = false;
        });
      } else {
        print('❌ No zones data found in analytics response');
        setState(() {
          _zones = [];
          _isLoadingZoneMap = false;
        });
      }
    } catch (e) {
      print('💥 Error loading zone map data for analytics: $e');
      setState(() {
        _zones = [];
        _isLoadingZoneMap = false;
      });
    }
  }

  Future<void> _loadEmployeeSnapshots() async {
    try {
      setState(() {
        _isLoadingSnapshots = true;
        _snapshotsError = null;
      });

      print('🔍 Loading employee snapshots for analytics...');

      // First, get all employees
      final staffResponse = await _aiApiService.getEmployeesList();
      print('👥 Staff API response: $staffResponse');

      if (staffResponse['employees'] != null && staffResponse['employees'] is List) {
        final employees = List<Map<String, dynamic>>.from(staffResponse['employees']);
        final snapshotUrls = <String>[];

        // Limit to first 3 employees for performance and display purposes
        final limitedEmployees = employees.take(3).toList();

        // For each employee, try to get one snapshot
        for (final employee in limitedEmployees) {
          final employeeName = employee['name'] as String?;
          if (employeeName != null && employeeName.isNotEmpty) {
            try {
              print('🔍 Fetching snapshot for employee: $employeeName');

              // Try multiple name variations for better success rate
              var snapshotResponse = await _aiApiService.getEmployeeFrameSnapshots(
                employeeName: employeeName,
              );

              // If no snapshots found, try with cleaned name
              if (snapshotResponse['snapshots'] == null ||
                  (snapshotResponse['snapshots'] as List).isEmpty) {
                final cleanedName = employeeName.trim().replaceAll(RegExp(r'\s+'), ' ');
                if (cleanedName != employeeName) {
                  print('🔄 Trying with cleaned name: "$cleanedName"');
                  snapshotResponse = await _aiApiService.getEmployeeFrameSnapshots(
                    employeeName: cleanedName,
                  );
                }
              }

              // If still no results and name contains Muhammad and Talha, try known format
              if ((snapshotResponse['snapshots'] == null ||
                   (snapshotResponse['snapshots'] as List).isEmpty) &&
                  employeeName.toLowerCase().contains('muhammad') &&
                  employeeName.toLowerCase().contains('talha')) {
                print('🔄 Trying with known format: "Muhammad  Talha"');
                snapshotResponse = await _aiApiService.getEmployeeFrameSnapshots(
                  employeeName: "Muhammad  Talha",
                );
              }

              if (snapshotResponse['snapshots'] != null &&
                  snapshotResponse['snapshots'] is List &&
                  (snapshotResponse['snapshots'] as List).isNotEmpty) {

                final snapshots = List<Map<String, dynamic>>.from(snapshotResponse['snapshots']);
                final firstSnapshot = snapshots.first;
                final imageUrl = firstSnapshot['image_url'] as String?;

                if (imageUrl != null && imageUrl.isNotEmpty) {
                  snapshotUrls.add(imageUrl);
                  print('✅ Added snapshot for $employeeName: $imageUrl');

                  // Stop if we have 3 snapshots (max display limit)
                  if (snapshotUrls.length >= 3) {
                    break;
                  }
                }
              } else {
                print('❌ No snapshots found for $employeeName');
              }
            } catch (e) {
              print('💥 Error fetching snapshot for $employeeName: $e');
              // Continue with other employees
            }
          }
        }

        print('📸 Total snapshots collected: ${snapshotUrls.length}');

        // If no snapshots found, try to get at least one from Muhammad Talha
        if (snapshotUrls.isEmpty) {
          try {
            print('🔄 No snapshots found, trying fallback with "Muhammad  Talha"');
            final fallbackResponse = await _aiApiService.getEmployeeFrameSnapshots(
              employeeName: "Muhammad  Talha",
            );

            if (fallbackResponse['snapshots'] != null &&
                fallbackResponse['snapshots'] is List &&
                (fallbackResponse['snapshots'] as List).isNotEmpty) {

              final snapshots = List<Map<String, dynamic>>.from(fallbackResponse['snapshots']);
              final firstSnapshot = snapshots.first;
              final imageUrl = firstSnapshot['image_url'] as String?;

              if (imageUrl != null && imageUrl.isNotEmpty) {
                snapshotUrls.add(imageUrl);
                print('✅ Added fallback snapshot: $imageUrl');
              }
            }
          } catch (e) {
            print('💥 Error with fallback snapshot: $e');
          }
        }

        setState(() {
          _employeeSnapshots = snapshotUrls;
          _isLoadingSnapshots = false;
        });
      } else {
        print('❌ No employees found in staff response');
        setState(() {
          _employeeSnapshots = [];
          _isLoadingSnapshots = false;
          _snapshotsError = 'No employees found';
        });
      }
    } catch (e) {
      print('💥 Error loading employee snapshots: $e');
      setState(() {
        _employeeSnapshots = [];
        _isLoadingSnapshots = false;
        _snapshotsError = 'Failed to load snapshots: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    
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
                      ZoneMapView(zones: _zones, isLoading: _isLoadingZoneMap),
                  ],
                ),
              ),
              if (_selectedTab == 1) ...[
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    localizations.zoneBreakdown,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                _ZoneBreakdownCard(zones: _zones, isLoading: _isLoadingZoneMap),
              ],
              if (_selectedTab == 0) ...[
                const SizedBox(height: 16),
                const AnalyticsEventsList(),
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
                  title: localizations.frameSnapshots,
                  description: localizations.capturedFromFootage,
                  snapshotImages: _employeeSnapshots,
                  isLoading: _isLoadingSnapshots,
                  error: _snapshotsError,
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
                if (widget.userRole.toLowerCase() == 'admin')
                  const DownloadReportWidget(
                    customButtonText: 'Download PDF',
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  final Color color;
  final String label;
  final int count;
  final String peakTime;

  const _EventCard({
    required this.color,
    required this.label,
    required this.count,
    required this.peakTime,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = (screenWidth - 56) / 3; // Account for padding and gaps

    // Responsive font sizes based on available width
    final double labelFontSize = cardWidth < 100 ? 11 : (cardWidth < 120 ? 12 : 14);
    final double countFontSize = cardWidth < 100 ? 20 : (cardWidth < 120 ? 22 : 24);
    final double peakFontSize = cardWidth < 100 ? 10 : (cardWidth < 120 ? 11 : 12);
    final double iconSize = cardWidth < 100 ? 10 : 12;
    final double cardPadding = cardWidth < 100 ? 12 : 16;

    return Container(
      padding: EdgeInsets.all(cardPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: iconSize,
                height: iconSize,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: labelFontSize,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF4B5563),
                    height: 1.1,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: cardWidth < 100 ? 8 : 12),
          Text(
            '$count',
            style: TextStyle(
              fontSize: countFontSize,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              height: 1.0,
            ),
          ),
          const SizedBox(height: 4),
          SizedBox(
            height: cardWidth < 100 ? 14 : 16,
            child: peakTime.isNotEmpty
                ? Text(
                    'Peak: $peakTime',
                    style: TextStyle(
                      fontSize: peakFontSize,
                      color: const Color(0xFF6B7280),
                      height: 1.2,
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

class _LoadingCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = (screenWidth - 56) / 3;

    final double iconSize = cardWidth < 100 ? 10 : 12;
    final double cardPadding = cardWidth < 100 ? 12 : 16;
    final double labelWidth = cardWidth < 100 ? 40 : 60;
    final double labelHeight = cardWidth < 100 ? 12 : 14;
    final double countWidth = cardWidth < 100 ? 25 : 30;
    final double countHeight = cardWidth < 100 ? 20 : 24;
    final double peakWidth = cardWidth < 100 ? 60 : 80;
    final double peakHeight = cardWidth < 100 ? 10 : 12;

    return Container(
      padding: EdgeInsets.all(cardPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: iconSize,
                height: iconSize,
                decoration: const BoxDecoration(
                  color: Color(0xFFE5E7EB),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Container(
                width: labelWidth,
                height: labelHeight,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
          SizedBox(height: cardWidth < 100 ? 8 : 12),
          Container(
            width: countWidth,
            height: countHeight,
            decoration: BoxDecoration(
              color: const Color(0xFFE5E7EB),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 4),
          SizedBox(
            height: cardWidth < 100 ? 14 : 16,
            child: Container(
              width: peakWidth,
              height: peakHeight,
              decoration: BoxDecoration(
                color: const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ],
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



class _TimeActivityView extends StatefulWidget {
  const _TimeActivityView();

  @override
  State<_TimeActivityView> createState() => _TimeActivityViewState();
}

class _TimeActivityViewState extends State<_TimeActivityView> {
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

          debugPrint('Parsed $type event at hour $hour from timestamp: $timestamp');
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

    debugPrint('Peak times calculated:');
    debugPrint('Incident peak: $_incidentPeakTime');
    debugPrint('Behavior peak: $_behaviorPeakTime');
    debugPrint('Away time peak: $_awayTimePeakTime');
  }

  String _findPeakTime(Map<int, int> hourCounts) {
    if (hourCounts.isEmpty) {
      debugPrint('No hour counts available for peak time calculation');
      return '';
    }

    int maxCount = 0;
    int peakHour = 0;

    hourCounts.forEach((hour, count) {
      debugPrint('Hour $hour has $count events');
      if (count > maxCount) {
        maxCount = count;
        peakHour = hour;
      }
    });

    debugPrint('Peak hour determined: $peakHour with $maxCount events');

    // Format hour as 12-hour format
    if (peakHour == 0) return '12:00 AM';
    if (peakHour < 12) return '$peakHour:00 AM';
    if (peakHour == 12) return '12:00 PM';
    return '${peakHour - 12}:00 PM';
  }

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
                        Text(
                          AppLocalizations.of(context)!.totalEvents,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Color(0xFF737373),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '$_totalEvents',
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
        if (!_isLoading) ...[
          // Event cards with counts and peak times
          Row(
            children: [
              Expanded(
                child: _EventCard(
                  color: Color(0xFF14B8A6),
                  label: AppLocalizations.of(context)!.incident,
                  count: _incidentEvents,
                  peakTime: _incidentPeakTime,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _EventCard(
                  color: Color(0xFFF97316),
                  label: AppLocalizations.of(context)!.behaviour,
                  count: _behaviorEvents,
                  peakTime: _behaviorPeakTime,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _EventCard(
                  color: Color(0xFFFACC15),
                  label: AppLocalizations.of(context)!.awaytime,
                  count: _awayTimeEvents,
                  peakTime: _awayTimePeakTime,
                ),
              ),
            ],
          ),
        ] else ...[
          // Loading state for cards
          Row(
            children: [
              Expanded(child: _LoadingCard()),
              const SizedBox(width: 12),
              Expanded(child: _LoadingCard()),
              const SizedBox(width: 12),
              Expanded(child: _LoadingCard()),
            ],
          ),
        ],
      ],
    );
  }
}

class ZoneMapView extends StatelessWidget {
  final List<Map<String, dynamic>> zones;
  final bool isLoading;

  const ZoneMapView({
    super.key,
    required this.zones,
    required this.isLoading,
  });

  // Helper method to get zone data by index
  Map<String, dynamic> _getZoneData(int index) {
    if (isLoading || zones.isEmpty || index >= zones.length) {
      return {'name': 'Loading...', 'violation_count': 0};
    }
    return zones[index];
  }

  // Helper method to get zone name by index
  String _getZoneName(int index) {
    final zoneData = _getZoneData(index);
    return zoneData['name'] ?? 'Unknown Zone';
  }

  // Helper method to get violation count by index
  int _getViolationCount(int index) {
    final zoneData = _getZoneData(index);
    return zoneData['violation_count'] ?? 0;
  }

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

                // Zone A card (first zone)
                Positioned(
                  left: isSmall ? 15 : 20,
                  top: isSmall ? 25 : 30,
                  child: _ZoneCardStyled(
                    label: _getZoneName(0), // Zone A
                    incidents: _getViolationCount(0),
                    incidentLabel: AppLocalizations.of(context)!.incident,
                    width: cardWidth,
                    height: cardHeight,
                    shadow: true,
                    fontSize: cardFont,
                    subtitleFontSize: subtitleFont,
                    subtitleSpace: cardTitleSpace,
                  ),
                ),
                // Zone B card (second zone)
                Positioned(
                  left: isSmall ? 135 : 190,
                  top: isSmall ? 85 : 120,
                  child: _ZoneCardStyled(
                    label: _getZoneName(1), // Zone B
                    incidents: _getViolationCount(1),
                    incidentLabel: AppLocalizations.of(context)!.incident,
                    width: cardWidth,
                    height: cardHeight,
                    shadow: true,
                    fontSize: cardFont,
                    subtitleFontSize: subtitleFont,
                    subtitleSpace: cardTitleSpace,
                  ),
                ),
                // Zone C card (third zone)
                Positioned(
                  left: isSmall ? 70 : 100,
                  top: isSmall ? 165 : 220,
                  child: _ZoneCardStyled(
                    label: _getZoneName(2), // Zone C
                    incidents: _getViolationCount(2),
                    incidentLabel: AppLocalizations.of(context)!.incident,
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
                  color: Colors.black.withValues(alpha: 0.13),
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
              '$incidents $incidentLabel',
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
  final List<Map<String, dynamic>> zones;
  final bool isLoading;

  const _ZoneBreakdownCard({
    required this.zones,
    required this.isLoading,
  });

  // Helper methods to get zone data (using first zone as example)
  Map<String, dynamic> get _firstZone {
    if (isLoading || zones.isEmpty) {
      return {'name': 'Loading...', 'time_spent_hours': 0.0, 'violation_count': 0, 'behavior_score_percentage': 0.0, 'away_time_hours': 0.0};
    }
    return zones.first;
  }

  String get _zoneName => _firstZone['name'] ?? 'Unknown Zone';

  String get _timeSpent {
    final hours = _firstZone['time_spent_hours'] ?? 0.0;
    final totalMinutes = (hours * 60).round();
    final displayHours = totalMinutes ~/ 60;
    final displayMinutes = totalMinutes % 60;
    return '${displayHours} hr ${displayMinutes} min';
  }

  int get _violationCount => _firstZone['violation_count'] ?? 0;

  String get _behaviorPercentage {
    final percentage = _firstZone['behavior_score_percentage'] ?? 0.0;
    return '${percentage.toStringAsFixed(0)}%';
  }

  String get _awayTime {
    final awayHours = _firstZone['away_time_hours'] ?? 0.0;
    if (awayHours == 0) return '0 time';
    if (awayHours < 1) return '1 time';
    return '${awayHours.toStringAsFixed(0)} time${awayHours > 1 ? 's' : ''}';
  }

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
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _zoneName,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          Table(
            columnWidths: const {0: FlexColumnWidth(1), 1: FlexColumnWidth(1)},
            children: [
              TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      AppLocalizations.of(context)!.timeSpent,
                      style: const TextStyle(fontSize: 15, color: Color(0xFF6B7280)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        AppLocalizations.of(context)!.incidents,
                        style: const TextStyle(
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
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      _timeSpent,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        _violationCount.toString(),
                        style: const TextStyle(
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
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      AppLocalizations.of(context)!.behavior,
                      style: const TextStyle(fontSize: 15, color: Color(0xFF6B7280)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        AppLocalizations.of(context)!.awayTime,
                        style: const TextStyle(
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
                    _behaviorPercentage,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      _awayTime,
                      style: const TextStyle(
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
