import 'package:flutter/material.dart';
import 'package:insight/l10n/app_localizations.dart';
import '../widgets/behavior_score_widget.dart';
import '../widgets/info_note_widget.dart';
import '../widgets/performance_comparison_widget.dart';
import '../widgets/simple_performance_chart.dart';
import '../widgets/staff_comparison_chart.dart';
import '../widgets/away_time_widget.dart';
import '../widgets/frame_snapshots_widget.dart';

import '../widgets/download_report_widget.dart';
import '../services/ai_api_service.dart';
import 'staff_screen.dart';

class EmployeeProfileScreen extends StatefulWidget {
  final StaffMember staffMember;
  final String userRole;

  const EmployeeProfileScreen({
    Key? key,
    required this.staffMember,
    required this.userRole,
  }) : super(key: key);

  @override
  State<EmployeeProfileScreen> createState() => _EmployeeProfileScreenState();
}

class _EmployeeProfileScreenState extends State<EmployeeProfileScreen> {
  final AiApiService _aiApiService = AiApiService();
  int? _productivityScore;
  bool _isLoadingProductivity = true;
  String? _productivityError;

  // Frame snapshots state
  List<String> _snapshotImages = [];
  bool _isLoadingSnapshots = true;
  String? _snapshotsError;

  // Break time state
  double? _averageBreakDuration;
  bool _isLoadingBreakTime = true;
  String? _breakTimeError;

  // Work hours state
  double? _totalWorkHours;
  double? _averageWorkHours; // from API summary
  double? _attendanceRate;
  bool _isLoadingWorkHours = true;
  String? _workHoursError;

  // Zone absence state
  String? _zoneAbsenceMessage;
  String? _zoneName;
  bool _isLoadingZoneAbsence = true;
  String? _zoneAbsenceError;

  @override
  void initState() {
    super.initState();
    print(
      '🏗️ EmployeeProfileScreen initialized for: "${widget.staffMember.name}"',
    );
    print('📏 Name length: ${widget.staffMember.name.length}');
    print(
      '🔤 Name characters: ${widget.staffMember.name.runes.map((r) => String.fromCharCode(r)).join(', ')}',
    );
    _loadProductivityData();
    _loadFrameSnapshots();
    _loadBreakTimeData();
    _loadWorkHoursData();
    _loadZoneAbsenceData();
  }

  // Helper function to safely get first name
  String _getFirstName() {
    final nameParts = widget.staffMember.name
        .split(' ')
        .where((name) => name.isNotEmpty)
        .toList();
    return nameParts.isNotEmpty ? nameParts.first : widget.staffMember.name;
  }

  // Helper function to safely get initials
  String _getInitials() {
    return widget.staffMember.name
        .split(' ')
        .where((name) => name.isNotEmpty)
        .map((name) => name[0])
        .join('')
        .toUpperCase();
  }

  Future<void> _loadFrameSnapshots() async {
    try {
      setState(() {
        _isLoadingSnapshots = true;
        _snapshotsError = null;
      });

      print(
        '🔍 Fetching frame snapshots for employee: ${widget.staffMember.name}',
      );

      // Try with the original name first
      var response = await _aiApiService.getEmployeeFrameSnapshots(
        employeeName: widget.staffMember.name,
      );

      // If no snapshots found, try with different name variations
      if (response['snapshots'] == null ||
          (response['snapshots'] as List).isEmpty) {
        print('🔄 No snapshots found with original name, trying variations...');

        // Try with cleaned name (single spaces)
        final cleanedName = widget.staffMember.name.trim().replaceAll(
          RegExp(r'\s+'),
          ' ',
        );
        if (cleanedName != widget.staffMember.name) {
          print('🔄 Trying with cleaned name: "$cleanedName"');
          response = await _aiApiService.getEmployeeFrameSnapshots(
            employeeName: cleanedName,
          );
        }

        // If still no results and the name contains "Muhammad" and "Talha", try the known working format
        if ((response['snapshots'] == null ||
                (response['snapshots'] as List).isEmpty) &&
            widget.staffMember.name.toLowerCase().contains('muhammad') &&
            widget.staffMember.name.toLowerCase().contains('talha')) {
          print('🔄 Trying with known working format: "Muhammad  Talha"');
          response = await _aiApiService.getEmployeeFrameSnapshots(
            employeeName: "Muhammad  Talha",
          );
        }
      }

      print('📸 Frame snapshots API response: $response');

      // Extract image URLs from the response
      if (response['snapshots'] != null && response['snapshots'] is List) {
        final snapshots = List<Map<String, dynamic>>.from(
          response['snapshots'],
        );
        print('📋 Raw snapshots data: ${snapshots.length} items');

        final imageUrls = <String>[];
        for (final snapshot in snapshots) {
          final imageUrl = snapshot['image_url'];
          print('🔍 Processing snapshot: $imageUrl');
          if (imageUrl != null && imageUrl is String && imageUrl.isNotEmpty) {
            imageUrls.add(imageUrl);
          }
        }

        print(
          '✅ Found ${imageUrls.length} snapshot images for ${widget.staffMember.name}',
        );
        print('🔗 Image URLs: $imageUrls');

        setState(() {
          _snapshotImages = imageUrls;
          _isLoadingSnapshots = false;
        });
      } else {
        print('❌ No snapshots found for employee: ${widget.staffMember.name}');
        print('📋 Response structure: ${response.keys.toList()}');
        setState(() {
          _snapshotImages = [];
          _isLoadingSnapshots = false;
          _snapshotsError =
              'No snapshots available for ${widget.staffMember.name}';
        });
      }
    } catch (e) {
      print('💥 Error loading frame snapshots: $e');
      setState(() {
        _snapshotImages = [];
        _isLoadingSnapshots = false;
        _snapshotsError = 'Failed to load snapshots: $e';
      });
    }
  }

  Future<void> _loadBreakTimeData() async {
    try {
      setState(() {
        _isLoadingBreakTime = true;
        _breakTimeError = null;
      });

      print('🔍 Fetching break time for employee: ${widget.staffMember.name}');

      // Try with the original name first
      var response = await _aiApiService.getEmployeeBreakTime(
        employeeName: widget.staffMember.name,
      );

      // If no data found, try with different name variations
      if (response['break_time_data'] == null ||
          (response['break_time_data'] as List).isEmpty) {
        print(
          '🔄 No break time data found with original name, trying variations...',
        );

        // Try with cleaned name (single spaces)
        final cleanedName = widget.staffMember.name.trim().replaceAll(
          RegExp(r'\s+'),
          ' ',
        );
        if (cleanedName != widget.staffMember.name) {
          print('🔄 Trying with cleaned name: "$cleanedName"');
          response = await _aiApiService.getEmployeeBreakTime(
            employeeName: cleanedName,
          );
        }

        // If still no results and name contains Muhammad and Talha, try known format
        if ((response['break_time_data'] == null ||
                (response['break_time_data'] as List).isEmpty) &&
            widget.staffMember.name.toLowerCase().contains('muhammad') &&
            widget.staffMember.name.toLowerCase().contains('talha')) {
          print('🔄 Trying with known format: "Muhammad  Talha"');
          response = await _aiApiService.getEmployeeBreakTime(
            employeeName: "Muhammad  Talha",
          );
        }
      }

      print('📊 Break time API response: $response');

      // Extract break time data from the response
      if (response['break_time_data'] != null &&
          response['break_time_data'] is List) {
        final breakTimeData = List<Map<String, dynamic>>.from(
          response['break_time_data'],
        );

        if (breakTimeData.isNotEmpty) {
          final employeeBreakData = breakTimeData.first;
          final breakSummary =
              employeeBreakData['break_summary'] as Map<String, dynamic>?;

          if (breakSummary != null &&
              breakSummary['average_break_duration'] != null) {
            final avgDuration = breakSummary['average_break_duration'];
            final duration = avgDuration is num ? avgDuration.toDouble() : null;

            print(
              '✅ Found average break duration for ${widget.staffMember.name}: $duration minutes',
            );

            setState(() {
              _averageBreakDuration = duration;
              _isLoadingBreakTime = false;
            });
          } else {
            print('❌ No break summary found in response');
            setState(() {
              _averageBreakDuration = null;
              _isLoadingBreakTime = false;
              _breakTimeError = 'No break summary available';
            });
          }
        } else {
          print('❌ Empty break time data array');
          setState(() {
            _averageBreakDuration = null;
            _isLoadingBreakTime = false;
            _breakTimeError =
                'No break time data available for ${widget.staffMember.name}';
          });
        }
      } else {
        print(
          '❌ No break time data found for employee: ${widget.staffMember.name}',
        );
        setState(() {
          _averageBreakDuration = null;
          _isLoadingBreakTime = false;
          _breakTimeError =
              'No break time data available for ${widget.staffMember.name}';
        });
      }
    } catch (e) {
      print('💥 Error loading break time data: $e');
      setState(() {
        _averageBreakDuration = null;
        _isLoadingBreakTime = false;
        _breakTimeError = 'Failed to load break time data: $e';
      });
    }
  }

  Future<void> _loadWorkHoursData() async {
    try {
      setState(() {
        _isLoadingWorkHours = true;
        _workHoursError = null;
      });

      print('🔍 Fetching work hours for employee: ${widget.staffMember.name}');

      // Try with the original name first
      var response = await _aiApiService.getEmployeeWorkHours(
        employeeName: widget.staffMember.name,
      );

      // If no data found, try with different name variations
      if (response['work_hours_data'] == null ||
          (response['work_hours_data'] as List).isEmpty) {
        print(
          '🔄 No work hours data found with original name, trying variations...',
        );

        // Try with cleaned name (single spaces)
        final cleanedName = widget.staffMember.name.trim().replaceAll(
          RegExp(r'\s+'),
          ' ',
        );
        if (cleanedName != widget.staffMember.name) {
          print('🔄 Trying with cleaned name: "$cleanedName"');
          response = await _aiApiService.getEmployeeWorkHours(
            employeeName: cleanedName,
          );
        }

        // If still no results and name contains Muhammad and Talha, try known format
        if ((response['work_hours_data'] == null ||
                (response['work_hours_data'] as List).isEmpty) &&
            widget.staffMember.name.toLowerCase().contains('muhammad') &&
            widget.staffMember.name.toLowerCase().contains('talha')) {
          print('🔄 Trying with known format: "Muhammad  Talha"');
          response = await _aiApiService.getEmployeeWorkHours(
            employeeName: "Muhammad  Talha",
          );
        }
      }

      print('📊 Work hours API response: $response');

      // Extract work hours data from the response
      if (response['work_hours_data'] != null &&
          response['work_hours_data'] is List) {
        final workHoursData = List<Map<String, dynamic>>.from(
          response['work_hours_data'],
        );

        if (workHoursData.isNotEmpty) {
          final employeeWorkData = workHoursData.first;
          final totalHours = employeeWorkData['total_hours'];
          final attendanceRate = employeeWorkData['attendance_rate'];

          final hours = totalHours is num ? totalHours.toDouble() : null;
          final attendance = attendanceRate is num
              ? attendanceRate.toDouble()
              : null;

          // Also get average hours from summary
          final summary = response['summary'] as Map<String, dynamic>?;
          final avgHours = summary?['average_hours'];
          final averageHours = avgHours is num ? avgHours.toDouble() : null;

          print(
            '✅ Found work hours for ${widget.staffMember.name}: $hours hours, $attendance% attendance, avg: $averageHours hours',
          );

          setState(() {
            _totalWorkHours = hours;
            _averageWorkHours = averageHours;
            _attendanceRate = attendance;
            _isLoadingWorkHours = false;
          });
        } else {
          print('❌ Empty work hours data array');
          setState(() {
            _totalWorkHours = null;
            _attendanceRate = null;
            _isLoadingWorkHours = false;
            _workHoursError =
                'No work hours data available for ${widget.staffMember.name}';
          });
        }
      } else {
        print(
          '❌ No work hours data found for employee: ${widget.staffMember.name}',
        );
        setState(() {
          _totalWorkHours = null;
          _attendanceRate = null;
          _isLoadingWorkHours = false;
          _workHoursError =
              'No work hours data available for ${widget.staffMember.name}';
        });
      }
    } catch (e) {
      print('💥 Error loading work hours data: $e');
      setState(() {
        _totalWorkHours = null;
        _attendanceRate = null;
        _isLoadingWorkHours = false;
        _workHoursError = 'Failed to load work hours data: $e';
      });
    }
  }

  Future<void> _loadZoneAbsenceData() async {
    try {
      setState(() {
        _isLoadingZoneAbsence = true;
        _zoneAbsenceError = null;
      });

      print(
        '🔍 Fetching zone absence for employee: ${widget.staffMember.name}',
      );

      // Try with the original name first
      var response = await _aiApiService.getEmployeeZoneAbsence(
        employeeName: widget.staffMember.name,
      );

      // If no data found, try with different name variations
      if (response['absence_events'] == null ||
          (response['absence_events'] as List).isEmpty) {
        print(
          '🔄 No zone absence data found with original name, trying variations...',
        );

        // Try with cleaned name (single spaces)
        final cleanedName = widget.staffMember.name.trim().replaceAll(
          RegExp(r'\s+'),
          ' ',
        );
        if (cleanedName != widget.staffMember.name) {
          print('🔄 Trying with cleaned name: "$cleanedName"');
          response = await _aiApiService.getEmployeeZoneAbsence(
            employeeName: cleanedName,
          );
        }

        // If still no results and name contains Muhammad and Talha, try known format
        if ((response['absence_events'] == null ||
                (response['absence_events'] as List).isEmpty) &&
            widget.staffMember.name.toLowerCase().contains('muhammad') &&
            widget.staffMember.name.toLowerCase().contains('talha')) {
          print('🔄 Trying with known format: "Muhammad  Talha"');
          response = await _aiApiService.getEmployeeZoneAbsence(
            employeeName: "Muhammad  Talha",
          );
        }
      }

      print('📊 Zone absence API response: $response');

      // Extract zone absence data from the response
      if (response['absence_events'] != null &&
          response['absence_events'] is List) {
        final absenceEvents = List<Map<String, dynamic>>.from(
          response['absence_events'],
        );

        if (absenceEvents.isNotEmpty) {
          final firstEvent = absenceEvents.first;
          final message = firstEvent['message'] as String?;
          final zoneName = firstEvent['zone_name'] as String?;

          print(
            '✅ Found zone absence for ${widget.staffMember.name}: $message, zone: $zoneName',
          );

          setState(() {
            _zoneAbsenceMessage = message;
            _zoneName = zoneName;
            _isLoadingZoneAbsence = false;
          });
        } else {
          print('❌ Empty zone absence events array');
          setState(() {
            _zoneAbsenceMessage = null;
            _zoneName = null;
            _isLoadingZoneAbsence = false;
            _zoneAbsenceError =
                'No zone absence data available for ${widget.staffMember.name}';
          });
        }
      } else {
        print(
          '❌ No zone absence data found for employee: ${widget.staffMember.name}',
        );
        setState(() {
          _zoneAbsenceMessage = null;
          _zoneName = null;
          _isLoadingZoneAbsence = false;
          _zoneAbsenceError =
              'No zone absence data available for ${widget.staffMember.name}';
        });
      }
    } catch (e) {
      print('💥 Error loading zone absence data: $e');
      setState(() {
        _zoneAbsenceMessage = null;
        _zoneName = null;
        _isLoadingZoneAbsence = false;
        _zoneAbsenceError = 'Failed to load zone absence data: $e';
      });
    }
  }

  Future<void> _loadProductivityData() async {
    try {
      setState(() {
        _isLoadingProductivity = true;
        _productivityError = null;
      });

      print(
        '🔍 Fetching productivity for employee: ${widget.staffMember.name}',
      );

      final response = await _aiApiService.getAllEmployeesProductivity();

      print('📊 Productivity API response: $response');

      // Find the specific employee's data
      if (response['employees'] != null && response['employees'] is List) {
        final employees = List<Map<String, dynamic>>.from(
          response['employees'],
        );

        // Look for the employee by name (case-insensitive)
        final employeeData = employees.firstWhere(
          (emp) =>
              emp['employee']?.toString().toLowerCase() ==
              widget.staffMember.name.toLowerCase(),
          orElse: () => <String, dynamic>{},
        );

        if (employeeData.isNotEmpty &&
            employeeData['productivity_score'] != null) {
          final score = employeeData['productivity_score'];
          final calculatedScore = (score is num)
              ? score.round().clamp(0, 100)
              : null;

          print(
            '✅ Productivity score found for ${widget.staffMember.name}: $score -> $calculatedScore%',
          );

          setState(() {
            _productivityScore = calculatedScore;
            _isLoadingProductivity = false;
          });
        } else {
          print(
            '❌ No productivity data found for employee: ${widget.staffMember.name}',
          );
          print(
            'Available employees: ${employees.map((e) => e['employee']).toList()}',
          );
          setState(() {
            _productivityScore = null;
            _isLoadingProductivity = false;
            _productivityError =
                'No productivity data available for ${widget.staffMember.name}';
          });
        }
      } else {
        print('❌ No employees array in response');
        setState(() {
          _productivityScore = null;
          _isLoadingProductivity = false;
          _productivityError = 'Invalid productivity data format';
        });
      }
    } catch (e) {
      print('💥 Error loading productivity data: $e');
      setState(() {
        _productivityScore = null;
        _isLoadingProductivity = false;
        _productivityError = 'Failed to load productivity data: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(_getResponsiveAppBarHeight(context)),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false, // Remove default leading
          centerTitle: false,
          flexibleSpace: SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                top: _getResponsiveContentPadding(context),
                bottom: 8.0,
              ),
              child: Row(
                children: [
                  // Back Button - Aligned with profile image
                  IconButton(
                    icon: const Icon(
                      Icons.chevron_left,
                      color: Colors.black,
                      size: 28,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  SizedBox(width: _getResponsiveBackButtonSpacing(context)),

                  // Profile Picture - Responsive size
                  CircleAvatar(
                    radius: _getResponsiveImageRadius(context),
                    backgroundColor: const Color(0xFFE5E7EB),
                    backgroundImage: AssetImage(widget.staffMember.avatar),
                    child: widget.staffMember.avatar.isEmpty
                        ? Text(
                            _getInitials(),
                            style: TextStyle(
                              fontSize:
                                  _getResponsiveImageRadius(context) * 0.5,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF6B7280),
                            ),
                          )
                        : null,
                  ),
                  SizedBox(width: _getResponsiveSpacing(context)),

                  // Name and Role
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.staffMember.name,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: _getResponsiveNameFontSize(context),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: _getResponsiveTextSpacing(context)),
                        Text(
                          widget
                              .staffMember
                              .role, // Now shows actual position from API
                          style: TextStyle(
                            color: const Color(0xFF4B5563),
                            fontSize: _getResponsiveRoleFontSize(context),
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Behavior Score
            BehaviorScoreWidget(
              productivityScore: widget.staffMember.score,
              attendanceScore: widget.staffMember.safeAttendanceRate,
              realProductivityScore: _productivityScore,
              isLoadingProductivity: _isLoadingProductivity,
            ),
            const SizedBox(height: 16),

            // Info Note - Outside behavior score
            InfoNoteWidget(
              message: localizations.moreProductiveThanAverage(
                _getFirstName(),
                '${(widget.staffMember.score - 50).abs()}', // Calculate difference from average (50%)
              ),
            ),
            const SizedBox(height: 16),

            // Performance Comparison
            PerformanceComparisonWidget(
              avgDailyScore: widget.staffMember.score,
              workTimePercentage: widget
                  .staffMember
                  .score, // Using behavior score as work time percentage
              averageBreakDuration: _averageBreakDuration,
              isLoadingBreakTime: _isLoadingBreakTime,
              breakTimeError: _breakTimeError,
              totalWorkHours: _totalWorkHours,
              averageWorkHours: _averageWorkHours,
              attendanceRate: _attendanceRate,
              isLoadingWorkHours: _isLoadingWorkHours,
              workHoursError: _workHoursError,
            ),
            const SizedBox(height: 16),

            // Employee's Performance Chart
            SimplePerformanceChart(
              title: "${_getFirstName()}'s ${localizations.performance}",
              data: const [60, 85, 70, 45, 30, 90, 75], // Fallback data
              employeeName: widget.staffMember.name,
            ),
            const SizedBox(height: 16),

            // Compare Staff Chart
            StaffComparisonChart(
              title: localizations.compareStaff,
              data: const [50, 72, 93, 57, 29, 91, 75],
            ),
            const SizedBox(height: 16),

            // Away Time
            AwayTimeWidget(
              title: localizations.awayTime,
              description: localizations.awayFromZone(
                _getFirstName(),
                '30 ${localizations.minutes}',
              ),
              duration:
                  '${localizations.forDuration} 30 ${localizations.minutes}',
              additionalInfo: '8 ${localizations.viewCameraLive}',
              zoneAbsenceMessage: _zoneAbsenceMessage,
              zoneName: _zoneName,
              isLoadingZoneAbsence: _isLoadingZoneAbsence,
              zoneAbsenceError: _zoneAbsenceError,
            ),
            const SizedBox(height: 16),

            // Frame Snapshots
            FrameSnapshotsWidget(
              title: localizations.frameSnapshots,
              description: localizations.capturedFromFootage,
              snapshotImages: _snapshotImages,
              isLoading: _isLoadingSnapshots,
              error: _snapshotsError,
            ),
            const SizedBox(height: 16),

            // Download Report - Only show for admin users
            if (widget.userRole.toLowerCase() == 'admin') ...[
              DownloadReportWidget(employeeName: widget.staffMember.name),
              const SizedBox(height: 20),
            ] else ...[
              const SizedBox(height: 20),
            ],
          ],
        ),
      ),
    );
  }

  // Responsive helper methods
  double _getResponsiveAppBarHeight(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 360) {
      return 100.0; // Increased height for small screens
    } else if (screenWidth < 400) {
      return 110.0; // Increased height for medium screens
    } else {
      return 120.0; // Increased height for larger screens
    }
  }

  double _getResponsiveBackButtonSpacing(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 360) {
      return 8.0;
    } else if (screenWidth < 400) {
      return 12.0;
    } else {
      return 16.0;
    }
  }

  double _getResponsiveContentPadding(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 360) {
      return 16.0;
    } else if (screenWidth < 400) {
      return 20.0;
    } else {
      return 24.0;
    }
  }

  double _getResponsiveImageRadius(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 360) {
      return 28.0; // 56px diameter for small screens
    } else if (screenWidth < 400) {
      return 30.0; // 60px diameter for medium screens
    } else {
      return 32.0; // 64px diameter for larger screens
    }
  }

  double _getResponsiveSpacing(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 360) {
      return 12.0;
    } else if (screenWidth < 400) {
      return 14.0;
    } else {
      return 16.0;
    }
  }

  double _getResponsiveNameFontSize(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 360) {
      return 16.0;
    } else if (screenWidth < 400) {
      return 17.0;
    } else {
      return 18.0;
    }
  }

  double _getResponsiveRoleFontSize(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 360) {
      return 11.0;
    } else if (screenWidth < 400) {
      return 11.5;
    } else {
      return 12.0;
    }
  }

  double _getResponsiveTextSpacing(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 360) {
      return 2.0;
    } else if (screenWidth < 400) {
      return 3.0;
    } else {
      return 4.0;
    }
  }
}
