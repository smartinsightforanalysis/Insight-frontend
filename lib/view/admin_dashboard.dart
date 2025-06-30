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
import '../services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:insight/view/download_progress_screen.dart';

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

  // Branch management
  final ApiService _apiService = ApiService();
  Map<String, dynamic>? _currentBranch;
  String _currentBranchName = 'Main Branch';
  String? _currentBranchId;

  // Filter dropdown management
  List<Map<String, dynamic>> _allBranches = [];
  String _selectedFilterBranch = 'All Branches';
  String? _selectedFilterBranchId;

  @override
  void initState() {
    super.initState();
    _loadDefaultBranch();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.addListener(_scrollListener);
    });
  }

  Future<void> _loadDefaultBranch() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedBranchId = prefs.getString('selected_branch_id');
      final savedBranchName = prefs.getString('selected_branch_name');

      final response = await _apiService.getAllBranches();
      final branches = List<Map<String, dynamic>>.from(
        response['branches'] ?? [],
      );

      if (branches.isNotEmpty) {
        Map<String, dynamic>? selectedBranch;

        // Try to find the previously selected branch
        if (savedBranchId != null) {
          selectedBranch = branches.firstWhere(
            (branch) => (branch['id'] ?? branch['_id']) == savedBranchId,
            orElse: () => {},
          );
        }

        // If no saved branch or saved branch not found, use the first branch
        if (selectedBranch == null || selectedBranch.isEmpty) {
          selectedBranch = branches.first;
        }

        setState(() {
          _currentBranch = selectedBranch;
          _currentBranchName = selectedBranch!['branchName'] ?? 'Main Branch';
          _currentBranchId = selectedBranch['id'] ?? selectedBranch['_id'];
          _allBranches = branches;
        });
      } else if (savedBranchName != null) {
        // If no branches from API but we have a saved name, use it
        setState(() {
          _currentBranchName = savedBranchName;
        });
      }
    } catch (e) {
      // If there's an error loading branches, keep the default "Main Branch"
      print('Error loading default branch: $e');
    }
  }

  void _onBranchChanged(Map<String, dynamic> selectedBranch) {
    setState(() {
      _currentBranch = selectedBranch;
      _currentBranchName = selectedBranch['branchName'] ?? 'Unknown Branch';
      _currentBranchId = selectedBranch['id'] ?? selectedBranch['_id'];
    });

    // Save the selected branch to preferences
    _saveBranchSelection();

    // Refresh branches list to include any newly added branches
    _refreshBranchesList();

    // You can add additional logic here like:
    // - Refresh dashboard data for the selected branch
    // - Analytics tracking

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Switched to ${_currentBranchName}'),
        backgroundColor: const Color(0xFF209A9F),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _refreshBranchesList() async {
    try {
      final response = await _apiService.getAllBranches();
      final branches = List<Map<String, dynamic>>.from(
        response['branches'] ?? [],
      );
      setState(() {
        _allBranches = branches;
      });
    } catch (e) {
      print('Error refreshing branches list: $e');
    }
  }

  Future<void> _saveBranchSelection() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (_currentBranchId != null) {
        await prefs.setString('selected_branch_id', _currentBranchId!);
      }
      await prefs.setString('selected_branch_name', _currentBranchName);
    } catch (e) {
      print('Error saving branch selection: $e');
    }
  }

  void _onFilterBranchSelected(String branchName, String? branchId) {
    setState(() {
      _selectedFilterBranch = branchName;
      _selectedFilterBranchId = branchId;
    });

    // You can add logic here to filter dashboard data based on selected branch
    // For example: refresh charts, update statistics, etc.

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Filter applied: $branchName'),
        backgroundColor: const Color(0xFF209A9F),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showBranchFilterDropdown() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.6,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(21),
              topRight: Radius.circular(21),
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Filter by Branch',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    // "All Branches" option
                    _buildFilterBranchItem(
                      'All Branches',
                      'Show data from all branches',
                      null,
                      _selectedFilterBranch == 'All Branches',
                    ),
                    const Divider(height: 1),
                    // Individual branches
                    ..._allBranches.map((branch) {
                      final branchName =
                          branch['branchName'] ?? 'Unknown Branch';
                      final branchId = branch['id'] ?? branch['_id'];
                      final isSelected = _selectedFilterBranchId == branchId;

                      return _buildFilterBranchItem(
                        branchName,
                        branch['branchAddress'] ?? 'No address',
                        branchId,
                        isSelected,
                      );
                    }).toList(),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterBranchItem(
    String name,
    String subtitle,
    String? branchId,
    bool isSelected,
  ) {
    return InkWell(
      onTap: () {
        _onFilterBranchSelected(name, branchId);
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF209A9F).withOpacity(0.1)
              : Colors.transparent,
        ),
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: Icon(
                branchId == null ? Icons.business : Icons.location_on,
                color: isSelected
                    ? const Color(0xFF209A9F)
                    : const Color(0xFF9CA3AF),
                size: 20,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? const Color(0xFF209A9F)
                          : const Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: Color(0xFF209A9F),
                size: 20,
              ),
          ],
        ),
      ),
    );
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
    final double visibilityThreshold =
        MediaQuery.of(context).size.height *
        0.7; // Example: 70% of screen height

    if (_scrollController.offset >= widgetStartOffset - visibilityThreshold &&
        !_showExportButton) {
      setState(() {
        _showExportButton = true;
      });
    } else if (_scrollController.offset <
            widgetStartOffset - visibilityThreshold &&
        _showExportButton) {
      setState(() {
        _showExportButton = false;
      });
    }
  }

  void _onItemTapped(int index) {
    // Handle navigation to different screens
    if (index == 1) {
      // Reports tab
      setState(() {
        _currentIndex = index;
      });
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              ReportScreen(userRole: widget.userRole),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      ).then((_) {
        // Reset to dashboard tab when returning from report screen
        setState(() {
          _currentIndex = 0;
        });
      });
    } else if (index == 2) {
      // Staff tab
      setState(() {
        _currentIndex = index;
      });
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              StaffScreen(userRole: widget.userRole),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      ).then((_) {
        // Reset to dashboard tab when returning from staff screen
        setState(() {
          _currentIndex = 0;
        });
      });
    } else if (index == 3) {
      // Users tab
      setState(() {
        _currentIndex = index;
      });
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              UserSettingsScreen(userRole: widget.userRole),
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
        subtitle: _currentBranchName,
        currentBranchId: _currentBranchId,
        onBranchChanged: _onBranchChanged,
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
                      onPressed: _showBranchFilterDropdown,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(
                          0xFFF1F3F6,
                        ), // Keep consistent light grey background
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 12.0,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _selectedFilterBranch,
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(width: 4.0),
                          SvgPicture.asset(
                            'assets/direction-down.svg',
                            color: Colors.grey[800],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8.0), // Space between buttons
                    // "This Week" Button
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(
                          0xFFF1F3F6,
                        ), // Light grey background
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 12.0,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'This Week',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(width: 4.0),
                          SvgPicture.asset(
                            'assets/direction-down.svg',
                            color: Colors.grey[800],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8.0), // Space between buttons
                    // "Employee" Button
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(
                          0xFFF1F3F6,
                        ), // Light grey background
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 12.0,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Employee',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(width: 4.0),
                          SvgPicture.asset(
                            'assets/direction-down.svg',
                            color: Colors.grey[800],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8.0), // Space between buttons
                    // "Behavior Type" Button
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(
                          0xFFF1F3F6,
                        ), // Light grey background
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 12.0,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Behavior Type',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(width: 4.0),
                          SvgPicture.asset(
                            'assets/direction-down.svg',
                            color: Colors.grey[800],
                          ),
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
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              SizedBox(height: 16.0),
              // Activity Cards
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  color: const Color(
                    0xFFF9FAFB,
                  ), // Background color for activity cards area
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.baseline,
                                    textBaseline: TextBaseline.alphabetic,
                                    children: [
                                      Text(
                                        '247',
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.teal[400],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 4.0,
                                      ), // Add some spacing between the number and percentage
                                      Text(
                                        '↑ 2.4%',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFF059669),
                                        ), // Adjust font size if needed for alignment
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              CircleAvatar(
                                backgroundColor: const Color(
                                  0xFFEFF6FF,
                                ), // Changed background color to #EFF6FF
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
                                color: const Color(
                                  0xFFE0F2FE,
                                ), // Light blue background
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Top Branch',
                                          style: TextStyle(
                                            color: const Color(0xFF4B5563),
                                          ),
                                        ),
                                        SizedBox(height: 8.0),
                                        FittedBox(
                                          fit: BoxFit.scaleDown,
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Downtown',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: const Color(0xFF2E7D32),
                                            ),
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
                                      child: Icon(
                                        Icons.emoji_events,
                                        color: const Color(0xFF209A9F),
                                        size: 30.0,
                                      ),
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
                                color: const Color(
                                  0xFFE0F2FE,
                                ), // Light blue background
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Productivity',
                                          style: TextStyle(
                                            color: const Color(0xFF4B5563),
                                          ),
                                        ),
                                        SizedBox(height: 8.0),
                                        FittedBox(
                                          fit: BoxFit.scaleDown,
                                          alignment: Alignment.centerLeft,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.baseline,
                                            textBaseline:
                                                TextBaseline.alphabetic,
                                            children: [
                                              Text(
                                                '87%',
                                                style: TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.teal[400],
                                                ),
                                              ),
                                              SizedBox(width: 4.0),
                                              Text(
                                                '↑ 2.4%',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: const Color(
                                                    0xFF059669,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  CircleAvatar(
                                    backgroundColor: const Color(
                                      0xFFEFF6FF,
                                    ), // Changed background color to #EFF6FF
                                    radius: 26.0,
                                    child: SvgPicture.asset(
                                      'assets/prod.svg',
                                      height:
                                          30.0, // Set the height to match the previous icon size
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
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.red[700],
                                ),
                              ),
                              CircleAvatar(
                                backgroundColor: Colors.red[100],
                                child: Icon(
                                  Icons.arrow_downward,
                                  color: Colors.red[700],
                                ),
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
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111111),
                      ),
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
                              SvgPicture.asset(
                                'assets/robot.svg',
                                width: 22,
                                height: 22,
                              ),
                              SizedBox(width: 8.0),
                              Text(
                                'Attendance Pattern',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 17,
                                  color: Color(0xFF222222),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.0),
                          Text(
                            'High absenteeism detected on Mondays.\nConsider reviewing work schedules.',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF4B5563),
                            ),
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
                              SvgPicture.asset(
                                'assets/bulb.svg',
                                width: 22,
                                height: 22,
                              ),
                              SizedBox(width: 8.0),
                              Text(
                                'Performance Insight',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 17,
                                  color: Color(0xFF222222),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.0),
                          Text(
                            'Team engagement peaks during afternoon shifts. Optimize task allocation.',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF4B5563),
                            ),
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
        userRole: widget.userRole,
      ),
      floatingActionButton: _showExportButton
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const DownloadProgressScreen(),
                  ),
                );
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
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
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
