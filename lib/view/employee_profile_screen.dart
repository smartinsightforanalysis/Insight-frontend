import 'package:flutter/material.dart';
import '../widgets/behavior_score_widget.dart';
import '../widgets/info_note_widget.dart';
import '../widgets/performance_comparison_widget.dart';
import '../widgets/simple_performance_chart.dart';
import '../widgets/staff_comparison_chart.dart';
import '../widgets/away_time_widget.dart';
import '../widgets/frame_snapshots_widget.dart';
import '../widgets/video_review_widget.dart';
import '../widgets/download_report_widget.dart';
import 'staff_screen.dart';

class EmployeeProfileScreen extends StatelessWidget {
  final StaffMember staffMember;
  final String userRole;

  const EmployeeProfileScreen({
    Key? key,
    required this.staffMember,
    required this.userRole,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                    icon: const Icon(Icons.chevron_left, color: Colors.black, size: 28),
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
                    backgroundImage: AssetImage(staffMember.avatar),
                    child: staffMember.avatar.isEmpty
                        ? Text(
                            staffMember.name.split(' ').map((name) => name[0]).join('').toUpperCase(),
                            style: TextStyle(
                              fontSize: _getResponsiveImageRadius(context) * 0.5,
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
                          staffMember.name,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: _getResponsiveNameFontSize(context),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: _getResponsiveTextSpacing(context)),
                        Text(
                          staffMember.role,
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
              productivityScore: 92,
              attendanceScore: 88,
            ),
            const SizedBox(height: 16),

            // Info Note - Outside behavior score
            InfoNoteWidget(
              message: 'Kamran shah is 6% more productive than average',
            ),
            const SizedBox(height: 16),
            
            // Performance Comparison
            PerformanceComparisonWidget(
              avgDailyScore: 85,
              workTimePercentage: 75,
            ),
            const SizedBox(height: 16),
            
            // Shah's Performance Chart
            SimplePerformanceChart(
              title: "Shah's Performance",
              data: const [60, 85, 70, 45, 30, 90, 75],
            ),
            const SizedBox(height: 16),

            // Compare Staff Chart
            StaffComparisonChart(
              title: "Compare Staff",
              data: const [50, 72, 93, 57, 29, 91, 75],
              avatars: const [
                'assets/sk.png',
                'assets/jane.png',
                'assets/sarah.png',
                'assets/sk.png',
                'assets/jane.png',
                'assets/sarah.png',
                'assets/sk.png',
              ],
            ),
            const SizedBox(height: 16),
            
            // Away Time
            const AwayTimeWidget(
              title: 'Away time',
              description: 'Kamran is away from assigned zone for 30 minutes',
              duration: 'for 30 minutes',
              additionalInfo: '8 View camera live',
            ),
            const SizedBox(height: 16),
            
            // Frame Snapshots
            const FrameSnapshotsWidget(
              title: 'Frame Snapshots',
              description: 'Captured from security footage',
              snapshotImages: [], // Add actual image paths if available
            ),
            const SizedBox(height: 16),
            
            // Video Review
            const VideoReviewWidget(
              title: 'Video Review',
              description: 'Captured from security footage',
              videoThumbnail: '', // Add actual video thumbnail if available
            ),
            const SizedBox(height: 16),

            // Download Report - Only show for admin users
            if (userRole.toLowerCase() == 'admin') ...[
              const DownloadReportWidget(),
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
