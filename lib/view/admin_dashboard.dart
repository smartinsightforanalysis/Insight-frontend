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
import '../services/ai_api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:insight/view/download_progress_screen.dart';
import 'package:insight/l10n/app_localizations.dart';


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
  final AiApiService _aiApiService = AiApiService();
  Map<String, dynamic>? _currentBranch;
  String _currentBranchName = 'Main Branch';
  String? _currentBranchId;

  // AI API data
  double? _averageBehaviorScore;
  bool _isLoadingBehaviorScore = true;
  String? _topBranchName;
  bool _isLoadingTopBranch = true;
  double? _overallProductivity;
  bool _isLoadingProductivity = true;
  List<Map<String, dynamic>> _underperformingZones = [];
  bool _isLoadingUnderperformingZones = true;
  Map<String, dynamic>? _performanceInsight;
  List<Map<String, dynamic>> _branchPerformanceData = [];
  bool _isLoadingBranchPerformance = true;
  String _selectedBranchPeriod = '1d'; // Default to daily
  List<Map<String, dynamic>> _recentBehaviors = [];
  int _totalEvents = 0;
  Map<String, dynamic> _behaviorSummary = {};
  String _timePeriod = 'Last 24 hours';
  bool _isLoadingRecentBehaviors = true;
  List<String> _recommendations = [];
  bool _isLoadingPerformanceInsight = true;
  List<Map<String, dynamic>> _topEmployees = [];
  bool _isLoadingTopEmployees = true;

  // Filter dropdown management
  List<Map<String, dynamic>> _allBranches = [];
  String _selectedFilterBranch = 'All Branches';
  String? _selectedFilterBranchId;

  @override
  void initState() {
    super.initState();
    _loadDefaultBranch();
    _loadAverageBehaviorScore();
    _loadTopBranch();
    _loadProductivity();
    _loadUnderperformingZones();
    _loadPerformanceInsight();
    _loadTopEmployees();
    _loadBranchPerformance();
    _loadRecentBehaviors();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.addListener(_scrollListener);
      // Show secret key modal after dashboard loads
      _showSecretKeyModal();
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

  Future<void> _loadAverageBehaviorScore() async {
    try {
      setState(() {
        _isLoadingBehaviorScore = true;
      });

      final response = await _aiApiService.getAverageBehaviorScore();

      if (response['average_behavior_score'] != null) {
        setState(() {
          _averageBehaviorScore = response['average_behavior_score'].toDouble();
          _isLoadingBehaviorScore = false;
        });
      } else {
        setState(() {
          _isLoadingBehaviorScore = false;
        });
      }
    } catch (e) {
      print('Error loading average behavior score: $e');
      setState(() {
        _isLoadingBehaviorScore = false;
      });
    }
  }

  Future<void> _loadTopBranch() async {
    try {
      setState(() {
        _isLoadingTopBranch = true;
      });

      final response = await _aiApiService.getTopBranch();

      if (response['top_branch'] != null &&
          response['top_branch']['name'] != null) {
        setState(() {
          _topBranchName = response['top_branch']['name'];
          _isLoadingTopBranch = false;
        });
      } else {
        setState(() {
          _isLoadingTopBranch = false;
        });
      }
    } catch (e) {
      print('Error loading top branch: $e');
      setState(() {
        _isLoadingTopBranch = false;
      });
    }
  }

  Future<void> _loadProductivity() async {
    try {
      setState(() {
        _isLoadingProductivity = true;
      });

      final response = await _aiApiService.getProductivity();

      if (response['overall_productivity'] != null) {
        setState(() {
          _overallProductivity = response['overall_productivity'].toDouble();
          _isLoadingProductivity = false;
        });
      } else {
        setState(() {
          _isLoadingProductivity = false;
        });
      }
    } catch (e) {
      print('Error loading productivity: $e');
      setState(() {
        _isLoadingProductivity = false;
      });
    }
  }

  Future<void> _loadUnderperformingZones() async {
    try {
      setState(() {
        _isLoadingUnderperformingZones = true;
      });

      final response = await _aiApiService.getUnderperformingZones();

      if (response['underperforming_zones'] != null) {
        setState(() {
          _underperformingZones = List<Map<String, dynamic>>.from(
            response['underperforming_zones'],
          );
          _isLoadingUnderperformingZones = false;
        });
      } else {
        setState(() {
          _isLoadingUnderperformingZones = false;
        });
      }
    } catch (e) {
      print('Error loading underperforming zones: $e');
      setState(() {
        _isLoadingUnderperformingZones = false;
      });
    }
  }

  Future<void> _loadPerformanceInsight() async {
    try {
      setState(() {
        _isLoadingPerformanceInsight = true;
      });

      final response = await _aiApiService.getPerformanceInsight();

      if (response['insights'] != null && response['insights'].isNotEmpty) {
        setState(() {
          _performanceInsight = response['insights'][0]; // Get first insight
          _recommendations = List<String>.from(
            response['recommendations'] ?? [],
          );
          _isLoadingPerformanceInsight = false;
        });
      } else {
        setState(() {
          _isLoadingPerformanceInsight = false;
        });
      }
    } catch (e) {
      print('Error loading performance insight: $e');
      setState(() {
        _isLoadingPerformanceInsight = false;
      });
    }
  }

  Future<void> _loadTopEmployees() async {
    try {
      setState(() {
        _isLoadingTopEmployees = true;
      });

      final response = await _aiApiService.getTop5Employees();

      if (response['top_employees'] != null) {
        setState(() {
          _topEmployees = List<Map<String, dynamic>>.from(
            response['top_employees'],
          );
          _isLoadingTopEmployees = false;
        });
      } else {
        setState(() {
          _isLoadingTopEmployees = false;
        });
      }
    } catch (e) {
      print('Error loading top employees: $e');
      setState(() {
        _isLoadingTopEmployees = false;
      });
    }
  }

  Future<void> _loadBranchPerformance([String? period]) async {
    try {
      setState(() {
        _isLoadingBranchPerformance = true;
      });

      final periodToUse = period ?? _selectedBranchPeriod;
      final response = await _aiApiService.getBranchPerformance(period: periodToUse);

      if (response['branches'] != null) {
        setState(() {
          _branchPerformanceData = List<Map<String, dynamic>>.from(
            response['branches'],
          );
          _isLoadingBranchPerformance = false;
        });
      } else {
        setState(() {
          _branchPerformanceData = [];
          _isLoadingBranchPerformance = false;
        });
      }
    } catch (e) {
      print('Error loading branch performance: $e');
      setState(() {
        _branchPerformanceData = [];
        _isLoadingBranchPerformance = false;
      });
    }
  }

  void _onBranchPeriodChanged(String period) {
    setState(() {
      _selectedBranchPeriod = period;
    });
    _loadBranchPerformance(period);
  }

  Future<void> _loadRecentBehaviors() async {
    try {
      setState(() {
        _isLoadingRecentBehaviors = true;
      });

      final response = await _aiApiService.getRecentBehaviors();

      setState(() {
        _recentBehaviors = List<Map<String, dynamic>>.from(
          response['recent_behaviors'] ?? [],
        );
        _totalEvents = response['total_events'] ?? 0;
        _behaviorSummary = Map<String, dynamic>.from(
          response['behavior_summary'] ?? {},
        );
        _timePeriod = response['time_period']?.toString() ?? 'Last 24 hours';
        _isLoadingRecentBehaviors = false;
      });
    } catch (e) {
      print('Error loading recent behaviors: $e');
      setState(() {
        _recentBehaviors = [];
        _totalEvents = 0;
        _behaviorSummary = {};
        _timePeriod = 'Last 24 hours';
        _isLoadingRecentBehaviors = false;
      });
    }
  }

  Future<void> _refreshDashboardData() async {
    await Future.wait([
      _loadDefaultBranch(),
      _loadAverageBehaviorScore(),
      _loadTopBranch(),
      _loadProductivity(),
      _loadUnderperformingZones(),
      _loadPerformanceInsight(),
      _loadTopEmployees(),
      _loadBranchPerformance(),
      _loadRecentBehaviors(),
    ]);
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

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          AppLocalizations.of(context)?.filterApplied(branchName) ??
              'Filter applied: $branchName',
        ),
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
                    Text(
                      AppLocalizations.of(context)?.filterByBranch ??
                          'Filter by Branch',
                      style: const TextStyle(
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
                      AppLocalizations.of(context)?.allBranches ??
                          'All Branches',
                      AppLocalizations.of(context)?.showDataFromAllBranches ??
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
    final localizations = AppLocalizations.of(context);
    switch (widget.userRole.toLowerCase()) {
      case 'supervisor':
        return localizations?.welcomeSupervisor ?? 'Welcome, Supervisor';
      case 'auditor':
        return localizations?.welcomeAuditor ?? 'Welcome, Auditor';
      case 'admin':
      default:
        return localizations?.welcomeAdmin ?? 'Welcome, Admin';
    }
  }

  void _showSecretKeyModal() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFFF4F7FB),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppLocalizations.of(context)?.doYouHaveSecretKey ??
                      'Do you have a secret key? If Yes',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF111827),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xFF209A9F),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      hintText: 'Enter your secret key',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF209A9F),
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: const Text(
                          'YES',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[300],
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: const Text(
                          'NO',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF111827),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
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
      body: RefreshIndicator(
        onRefresh: _refreshDashboardData,
        child: SingleChildScrollView(
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
                          AppLocalizations.of(
                                context,
                              )?.stretchBreakSuggestion ??
                              'Take a 10-min stretch break every 2 hours',
                          style: TextStyle(color: const Color(0xFF6B7280)),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.0),
                SizedBox(height: 24.0),
                // Today's Activity Header
                Text(
                  AppLocalizations.of(context)?.todaysActivity ??
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
                          color: const Color(
                            0xFFE0F2FE,
                          ), // Light blue background
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(
                                    context,
                                  )?.averageBehaviourScore ??
                                  'Average Behaviour Score',
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
                                        _isLoadingBehaviorScore
                                            ? SizedBox(
                                                width: 24,
                                                height: 24,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                        Color
                                                      >(Colors.teal[400]!),
                                                ),
                                              )
                                            : Text(
                                                _averageBehaviorScore
                                                        ?.toStringAsFixed(1) ??
                                                    '0.0',
                                                style: TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.teal[400],
                                                ),
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
                                            AppLocalizations.of(
                                                  context,
                                                )?.topBranch ??
                                                'Top Branch',
                                            style: TextStyle(
                                              color: const Color(0xFF4B5563),
                                            ),
                                          ),
                                          SizedBox(height: 8.0),
                                          FittedBox(
                                            fit: BoxFit.scaleDown,
                                            alignment: Alignment.centerLeft,
                                            child: _isLoadingTopBranch
                                                ? SizedBox(
                                                    width: 20,
                                                    height: 20,
                                                    child: CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                      valueColor:
                                                          AlwaysStoppedAnimation<
                                                            Color
                                                          >(
                                                            const Color(
                                                              0xFF2E7D32,
                                                            ),
                                                          ),
                                                    ),
                                                  )
                                                : Text(
                                                    _topBranchName ?? 'Unknow',
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: const Color(
                                                        0xFF2E7D32,
                                                      ),
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                  ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.center,
                                      child: CircleAvatar(
                                        backgroundColor: const Color(
                                          0xFFD1FAE5,
                                        ),
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
                                            AppLocalizations.of(
                                                  context,
                                                )?.productivity ??
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
                                                _isLoadingProductivity
                                                    ? SizedBox(
                                                        width: 24,
                                                        height: 24,
                                                        child: CircularProgressIndicator(
                                                          strokeWidth: 2,
                                                          valueColor:
                                                              AlwaysStoppedAnimation<
                                                                Color
                                                              >(
                                                                Colors
                                                                    .teal[400]!,
                                                              ),
                                                        ),
                                                      )
                                                    : Text(
                                                        '${((_overallProductivity ?? 0) * 100).toStringAsFixed(0)}%',
                                                        style: TextStyle(
                                                          fontSize: 24,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              Colors.teal[400],
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
                          color: const Color(
                            0xFFE0F2FE,
                          ), // Light blue background
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(
                                    context,
                                  )?.underperformingZones ??
                                  'Underperforming zones',
                              style: TextStyle(color: const Color(0xFF4B5563)),
                            ),
                            SizedBox(height: 8.0),
                            _isLoadingUnderperformingZones
                                ? Center(
                                    child: SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Colors.red[700]!,
                                            ),
                                      ),
                                    ),
                                  )
                                : _underperformingZones.isEmpty
                                ? Text(
                                    'No underperforming zones',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[600],
                                    ),
                                  )
                                : Column(
                                    children: _underperformingZones.map((zone) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 8.0,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Zone ${zone['zone']}',
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w900,
                                                      color: Colors.red[700],
                                                    ),
                                                  ),
                                                  Text(
                                                    '${zone['violations']} violations • ${((zone['productivity_score'] ?? 0) * 100).toStringAsFixed(0)}% productivity',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey[600],
                                                    ),
                                                  ),
                                                ],
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
                                      );
                                    }).toList(),
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
                        AppLocalizations.of(context)?.aiInsights ??
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
                                  AppLocalizations.of(
                                        context,
                                      )?.attendancePattern ??
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
                              AppLocalizations.of(
                                    context,
                                  )?.highAbsenteeismDetected ??
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
                                  AppLocalizations.of(
                                        context,
                                      )?.performanceInsight ??
                                      AppLocalizations.of(
                                        context,
                                      )?.performanceInsight ??
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
                            _isLoadingPerformanceInsight
                                ? Center(
                                    child: SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Color(0xFF4B5563),
                                            ),
                                      ),
                                    ),
                                  )
                                : _performanceInsight == null
                                ? Text(
                                    'No performance insights available',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[600],
                                    ),
                                  )
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _performanceInsight!['title'] ??
                                            'Performance Insight',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF222222),
                                        ),
                                      ),
                                      SizedBox(height: 8.0),
                                      Text(
                                        _performanceInsight!['message'] ??
                                            'No message available',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Color(0xFF4B5563),
                                        ),
                                      ),
                                      if (_recommendations.isNotEmpty) ...[
                                        SizedBox(height: 12.0),
                                        Text(
                                          'Recommendations:',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF222222),
                                          ),
                                        ),
                                        SizedBox(height: 6.0),
                                        ...(_recommendations
                                            .take(3)
                                            .map(
                                              (recommendation) => Padding(
                                                padding: const EdgeInsets.only(
                                                  bottom: 4.0,
                                                ),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      '• ',
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color: Color(
                                                          0xFF4B5563,
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        recommendation,
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: Color(
                                                            0xFF4B5563,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                            .toList()),
                                      ],
                                    ],
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.0),
                StaffPerformanceChart(
                  title:
                      AppLocalizations.of(context)?.staffPerformance ??
                      "Staff Performance",
                  data: const [50, 72, 93, 57, 29, 91, 75],
                ),
                SizedBox(height: 24.0),
                TopEmployeesWidget(
                  employees: _topEmployees,
                  isLoading: _isLoadingTopEmployees,
                ),
                SizedBox(height: 24.0),
                BranchPerformanceChart(
                  branches: _branchPerformanceData,
                  isLoading: _isLoadingBranchPerformance,
                  onPeriodChanged: _onBranchPeriodChanged,
                ),
                SizedBox(height: 24.0),
                BranchesPerformanceWidget(
                  branches: _branchPerformanceData,
                  isLoading: _isLoadingBranchPerformance,
                ),
                SizedBox(height: 24.0),
                RecentBehavioursWidget(
                  key: _recentBehavioursKey,
                  recentBehaviors: _recentBehaviors,
                  totalEvents: _totalEvents,
                  behaviorSummary: _behaviorSummary,
                  timePeriod: _timePeriod,
                  isLoading: _isLoadingRecentBehaviors,
                ),
              ],
            ),
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
              label: Text(
                AppLocalizations.of(context)?.exportReport ?? 'Export Report',
                style: const TextStyle(
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
