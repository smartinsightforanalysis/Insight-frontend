import 'package:flutter/material.dart';
import '../widgets/custom_header.dart';
import '../widgets/bottom_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/staff_performance_chart.dart';
import '../widgets/top_employees_widget.dart';
import '../widgets/branch_performance_chart.dart';
import '../widgets/branches_performance_widget.dart';
import '../widgets/recent_behaviours_widget.dart';
import 'staff_screen.dart';
import 'report_screen.dart';
import 'user_settings_screen.dart';

class AdminDashboard extends StatefulWidget {
  final String userRole;

  const AdminDashboard({Key? key, this.userRole = 'admin'}) : super(key: key);

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _currentIndex = 0;
  final ScrollController _scrollController = ScrollController();
  bool _showExportButton = false;
  final GlobalKey _recentBehavioursKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.addListener(_scrollListener);
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    final RenderBox? renderBox =
        _recentBehavioursKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final double widgetStartOffset = offset.dy + _scrollController.offset;

    // Adjust this threshold as needed to make the button appear
    // slightly before or at the exact moment the widget is visible.
    final double visibilityThreshold = MediaQuery.of(context).size.height * 0.7; // Example: 70% of screen height

    if (_scrollController.offset >= widgetStartOffset - visibilityThreshold && !_showExportButton) {
      setState(() {
        _showExportButton = true;
      });
    } else if (_scrollController.offset < widgetStartOffset - visibilityThreshold && _showExportButton) {
      setState(() {
        _showExportButton = false;
      });
    }
  }

  void _onItemTapped(int index) {
    // Handle navigation to different screens
    if (index == 1) { // Reports tab
      setState(() {
        _currentIndex = index;
      });
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => ReportScreen(userRole: widget.userRole),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      ).then((_) {
        // Reset to dashboard tab when returning from report screen
        setState(() {
          _currentIndex = 0;
        });
      });
    } else if (index == 2) { // Staff tab
      setState(() {
        _currentIndex = index;
      });
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => StaffScreen(userRole: widget.userRole),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      ).then((_) {
        // Reset to dashboard tab when returning from staff screen
        setState(() {
          _currentIndex = 0;
        });
      });
    } else if (index == 3) { // Users tab
      setState(() {
        _currentIndex = index;
      });
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => UserSettingsScreen(userRole: widget.userRole),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      );
    } else {
      setState(() {
        _currentIndex = index;
      });
    }
    // Add navigation for other tabs when implemented
  }

  String _getWelcomeMessage() {
    switch (widget.userRole.toLowerCase()) {
      case 'supervisor':
        return 'Welcome, Supervisor';
      case 'auditor':
        return 'Welcome, Auditor';
      case 'admin':
      default:
        return 'Welcome, Admin';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: CustomHeader(
        title: _getWelcomeMessage(),
        subtitle: 'Main Branch',
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Suggestion Bar
              Container(
                padding: EdgeInsets.all(12.0),
                height: 70.0,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F2FE), // Light blue background
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  children: [
                    Text('💡', style: TextStyle(fontSize: 24.0)),
                    SizedBox(width: 8.0),
                    Expanded(
                      child: Text(
                        'Take a 10-min stretch break every 2 hours',
                        style: TextStyle(color: const Color(0xFF6B7280)),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.0),
              // Filter Buttons
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    // "All Branches" Button
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF1F3F6), // Light grey background
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0)
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'All Branches',
                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(width: 4.0),
                          SvgPicture.asset('assets/direction-down.svg', color: Colors.grey[800]),
                        ],
                      ),
                    ),
                    SizedBox(width: 8.0), // Space between buttons
                    // "This Week" Button
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF1F3F6), // Light grey background
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0)
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'This Week',
                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(width: 4.0),
                          SvgPicture.asset('assets/direction-down.svg', color: Colors.grey[800]),
                        ],
                      ),
                    ),
                    SizedBox(width: 8.0), // Space between buttons
                    // "Employee" Button
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF1F3F6), // Light grey background
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0)
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Employee',
                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(width: 4.0),
                          SvgPicture.asset('assets/direction-down.svg', color: Colors.grey[800]),
                        ],
                      ),
                    ),
                    SizedBox(width: 8.0), // Space between buttons
                     // "Behavior Type" Button
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF1F3F6), // Light grey background
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0)
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Behavior Type',
                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(width: 4.0),
                          SvgPicture.asset('assets/direction-down.svg', color: Colors.grey[800]),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.0),
              // Today's Activity Header
              Text(
                'Today\'s Activity',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF333333)),
              ),
              SizedBox(height: 16.0),
              // Activity Cards
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  color: const Color(0xFFF9FAFB), // Background color for activity cards area
                ),
                child: Column(
                  children: [
                    // Average Behaviour Score Card
                    Container(
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0F2FE), // Light blue background
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Average Behaviour score',
                            style: TextStyle(color: const Color(0xFF4B5563)),
                          ),
                          SizedBox(height: 8.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.baseline,
                                    textBaseline: TextBaseline.alphabetic,
                                    children: [
                                      Text(
                                        '247',
                                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.teal[400]),
                                      ),
                                      SizedBox(width: 4.0), // Add some spacing between the number and percentage
                                      Text(
                                        '↑ 2.4%',
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF059669)), // Adjust font size if needed for alignment
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              CircleAvatar(
                                backgroundColor: const Color(0xFFEFF6FF), // Changed background color to #EFF6FF
                                radius: 26.0,
                                child: SvgPicture.asset(
                                   'assets/onb2.svg',
                                   height: 20.0,
                                   // The SVG has an intrinsic aspect ratio, no need for width if height is set
                                   // color: Colors.teal[400], // Keep original color if desired, or let SVG color show
                                 ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.0),
                    // Top Branch and Productivity Row
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Top Branch Card
                          Expanded(
                            child: Container(
                               padding: EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE0F2FE), // Light blue background
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                         Text(
                                          'Top Branch',
                                          style: TextStyle(color: const Color(0xFF4B5563)),
                                        ),
                                         SizedBox(height: 8.0),
                                          FittedBox(
                                           fit: BoxFit.scaleDown,
                                           alignment: Alignment.centerLeft,
                                           child: Text(
                                             'Downtown',
                                             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF2E7D32)),
                                             overflow: TextOverflow.ellipsis,
                                             maxLines: 1,
                                           ),
                                         ),
                                      ],
                                    ),
                                  ),
                                  Align(
                                      alignment: Alignment.center,
                                      child: CircleAvatar(
                                        backgroundColor: const Color(0xFFD1FAE5),
                                        radius: 26.0,
                                        child: Icon(Icons.emoji_events, color: const Color(0xFF209A9F), size: 30.0),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 16.0),
                          // Productivity Card
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE0F2FE), // Light blue background
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Productivity',
                                          style: TextStyle(color: const Color(0xFF4B5563)),
                                        ),
                                        SizedBox(height: 8.0),
                                        FittedBox(
                                          fit: BoxFit.scaleDown,
                                          alignment: Alignment.centerLeft,
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.baseline,
                                            textBaseline: TextBaseline.alphabetic,
                                            children: [
                                              Text(
                                                '87%',
                                                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.teal[400]),
                                              ),
                                              SizedBox(width: 4.0),
                                              Text(
                                                '↑ 2.4%',
                                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF059669)),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  CircleAvatar(
                                    backgroundColor: const Color(0xFFEFF6FF), // Changed background color to #EFF6FF
                                    radius: 26.0,
                                    child: SvgPicture.asset(
                                       'assets/prod.svg',
                                       height: 30.0, // Set the height to match the previous icon size
                                       // The SVG has an intrinsic aspect ratio, no need for width if height is set
                                     ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.0),
                    // Underperforming Zones Card
                     Container(
                             padding: EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE0F2FE), // Light blue background
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                 Text(
                                  'Underperforming zones',
                                  style: TextStyle(color: const Color(0xFF4B5563)),
                                ),
                                 SizedBox(height: 8.0),
                                  Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Zone 4',
                                       style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.red[700]),
                                    ),
                                     CircleAvatar(
                                      backgroundColor: Colors.red[100],
                                      child: Icon(Icons.arrow_downward, color: Colors.red[700]),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                  ],
                ),
              ),
              // CLONED AI INSIGHTS SECTION
              SizedBox(height: 24.0),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AI Insights',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF111111)),
                    ),
                    SizedBox(height: 16.0),
                    // Attendance Pattern Card
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(bottom: 16.0),
                      padding: EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x0F000000),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset('assets/robot.svg', width: 22, height: 22),
                              SizedBox(width: 8.0),
                              Text(
                                'Attendance Pattern',
                                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 17, color: Color(0xFF222222)),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.0),
                          Text(
                            'High absenteeism detected on Mondays.\nConsider reviewing work schedules.',
                            style: TextStyle(fontSize: 16, color: Color(0xFF4B5563)),
                          ),
                        ],
                      ),
                    ),
                    // Performance Insight Card
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x0F000000),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset('assets/bulb.svg', width: 22, height: 22),
                              SizedBox(width: 8.0),
                              Text(
                                'Performance Insight',
                                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 17, color: Color(0xFF222222)),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.0),
                          Text(
                            'Team engagement peaks during afternoon shifts. Optimize task allocation.',
                            style: TextStyle(fontSize: 16, color: Color(0xFF4B5563)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.0),
              StaffPerformanceChart(
                title: "Staff Performance",
                data: const [50, 72, 93, 57, 29, 91, 75],
                avatars: const [
                  'assets/sk.png',
                  'assets/jane.png',
                  'assets/sk.png',
                  'assets/jane.png',
                  'assets/sk.png',
                  'assets/jane.png',
                  'assets/sk.png',
                ],
              ),
              SizedBox(height: 24.0),
              TopEmployeesWidget(),
              SizedBox(height: 24.0),
              BranchPerformanceChart(),
              SizedBox(height: 24.0),
              BranchesPerformanceWidget(),
              SizedBox(height: 24.0),
              RecentBehavioursWidget(key: _recentBehavioursKey),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
      floatingActionButton: _showExportButton
          ? FloatingActionButton.extended(
              onPressed: () {
                // Handle export report button tap
              },
              label: const Text(
                'Export Report',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              icon: SvgPicture.asset(
                'assets/export.svg',
                width: 16,
                height: 16,
                colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              ),
              backgroundColor: const Color(0xFF209A9F), // Teal color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0), // Rounded corners
              ),
              elevation: 4.0,
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
} 