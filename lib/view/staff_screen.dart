import 'package:flutter/material.dart';
import 'package:insight/l10n/app_localizations.dart';
import '../widgets/bottom_bar.dart';
import '../services/ai_api_service.dart';
import 'employee_profile_screen.dart';
import 'report_screen.dart';
import 'admin_dashboard.dart';
import 'user_settings_screen.dart';

class StaffScreen extends StatefulWidget {
  final String userRole;

  const StaffScreen({Key? key, required this.userRole}) : super(key: key);

  @override
  State<StaffScreen> createState() => _StaffScreenState();
}

class _StaffScreenState extends State<StaffScreen> {
  int _currentIndex = 2; // Staff tab is selected
  final TextEditingController _searchController = TextEditingController();

  // API service and data
  final AiApiService _aiApiService = AiApiService();
  List<StaffMember> _staffMembers = [];
  List<StaffMember> _filteredStaffMembers = [];
  bool _isLoading = true;
  String? _errorMessage;

  // Department filtering
  List<String> _departments = [];
  String? _selectedDepartment;

  // Performance level filtering
  List<String> _performanceLevels = [];
  String? _selectedPerformanceLevel;

  @override
  void initState() {
    super.initState();
    _loadEmployees();
    _searchController.addListener(_filterStaff);
  }

  void _filterStaff() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredStaffMembers = _staffMembers.where((staff) {
        // Text search filter
        bool matchesSearch =
            query.isEmpty ||
            staff.name.toLowerCase().contains(query) ||
            staff.role.toLowerCase().contains(query) ||
            staff.employeeId.toLowerCase().contains(query);

        // Department filter
        bool matchesDepartment =
            _selectedDepartment == null ||
            _selectedDepartment == 'All Departments' ||
            staff.department == _selectedDepartment;

        // Performance level filter
        bool matchesPerformance =
            _selectedPerformanceLevel == null ||
            _selectedPerformanceLevel == 'All Performance' ||
            staff.performanceLevel == _selectedPerformanceLevel;

        return matchesSearch && matchesDepartment && matchesPerformance;
      }).toList();
    });
  }

  Future<void> _loadEmployees() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final response = await _aiApiService.getEmployeesList();

      if (response['employees'] != null) {
        final employees = List<Map<String, dynamic>>.from(
          response['employees'],
        );

        // Extract unique departments and performance levels
        Set<String> departmentSet = {};
        Set<String> performanceLevelSet = {};
        List<StaffMember> staffMembers = [];

        for (var employee in employees) {
          // Convert behavior_score to percentage (0-100)
          double behaviorScore = (employee['behavior_score'] ?? 0.0).toDouble();
          int scorePercentage = (behaviorScore * 100 / 20).round().clamp(
            0,
            100,
          ); // Assuming max score is 20

          // Fetch attendance data for this employee
          int attendanceRate = scorePercentage; // Default fallback

          final employeeId = employee['employee_id']?.toString() ?? '';
          if (employeeId.isNotEmpty) {
            try {
              final attendanceResponse = await _aiApiService
                  .getEmployeeAttendance(employeeId: employeeId);

              // Check if response has valid attendance data
              final summary = attendanceResponse['summary'];
              if (summary != null && summary is Map<String, dynamic>) {
                final rate = summary['attendance_rate'];
                if (rate != null && rate is num) {
                  attendanceRate = rate.round().clamp(0, 100);
                }
              }
            } catch (e) {
              // Use behavior score as fallback if attendance API fails
              // Silent fallback - attendance data not critical for app function
            }
          }

          // Extract department and performance level from employee data
          String department = employee['department'] ?? 'Unknown Department';
          String performanceLevel =
              employee['performance_level'] ?? 'Unknown Performance';
          departmentSet.add(department);
          performanceLevelSet.add(performanceLevel);

          staffMembers.add(
            StaffMember(
              employeeId: employee['employee_id'] ?? '',
              name: employee['name'] ?? 'Unknown',
              role: employee['position'] ?? 'Unknown Position',
              score: scorePercentage,
              avatar: '', // No avatar from API, will use initials
              status: employee['status'] ?? 'inactive',
              attendanceCount: employee['attendance_count'] ?? 0,
              violationCount: employee['violation_count'] ?? 0,
              zones: List<String>.from(employee['zones'] ?? []),
              lastSeen: employee['last_seen'],
              attendanceRate: attendanceRate,
              department: department,
              performanceLevel: performanceLevel,
            ),
          );
        }

        // Sort departments and performance levels alphabetically
        List<String> sortedDepartments = departmentSet.toList()..sort();
        List<String> sortedPerformanceLevels = performanceLevelSet.toList()
          ..sort();

        setState(() {
          _staffMembers = staffMembers;
          _filteredStaffMembers = List.from(_staffMembers);
          _departments = sortedDepartments;
          _performanceLevels = sortedPerformanceLevels;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'No employees data found';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading employees: $e';
        _isLoading = false;
      });
    }
  }

  // Removed _mapPerformanceLevelToRole method since we now use actual position from API

  void _onItemTapped(int index) {
    if (index == 0) {
      // Dashboard tab
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              AdminDashboard(userRole: widget.userRole),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      );
    } else if (index == 1) {
      // Reports tab
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              ReportScreen(userRole: widget.userRole),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      );
    } else if (index == 3) {
      // Users tab
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              UserSettingsScreen(userRole: widget.userRole),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      );
    }
  }

  Color _getScoreColor(int score) {
    if (score >= 85) {
      return const Color(0xFF065F46); // Green
    } else if (score >= 60) {
      return const Color(0xFF92400E); // Yellow/Orange
    } else {
      return const Color(0xFF991B1B); // Red
    }
  }

  Color _getScoreBackgroundColor(int score) {
    if (score >= 85) {
      return const Color(0xFFD1FAE5); // Light green
    } else if (score >= 60) {
      return const Color(0xFFFEF3C7); // Light yellow
    } else {
      return const Color(0xFFFEE2E2); // Light red
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: kToolbarHeight + 35,
        automaticallyImplyLeading: false,
        centerTitle: false,
        shape: const Border(
          bottom: BorderSide(color: Color(0xFFE5E7EB), width: 1),
        ),
        title: Text(
          localizations?.staff ?? 'Staff',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: localizations?.searchStaff ?? 'Search Staff..',
                  hintStyle: const TextStyle(
                    color: Color(0xFF9CA3AF),
                    fontSize: 16,
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Color(0xFF9CA3AF),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Filter Buttons Row
            Row(
              children: [
                // All Departments Dropdown
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        color: const Color(0xFFE5E7EB),
                        width: 1,
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedDepartment,
                        hint: Text(
                          localizations?.allDepartments ?? 'All Departments',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        isExpanded: true,
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          size: 20,
                          color: Colors.black,
                        ),
                        items: [
                          DropdownMenuItem<String>(
                            value: null,
                            child: Text(
                              localizations?.allDepartments ??
                                  'All Departments',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          ..._departments.map((String department) {
                            return DropdownMenuItem<String>(
                              value: department,
                              child: Text(
                                department,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            );
                          }).toList(),
                        ],
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedDepartment = newValue;
                          });
                          _filterStaff();
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Performance Level Filter Dropdown
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        color: const Color(0xFFE5E7EB),
                        width: 1,
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedPerformanceLevel,
                        hint: Text(
                          'All Performance',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        isExpanded: true,
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          size: 20,
                          color: Colors.black,
                        ),
                        items: [
                          DropdownMenuItem<String>(
                            value: null,
                            child: Text(
                              'All Performance',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          ..._performanceLevels.map((String performanceLevel) {
                            return DropdownMenuItem<String>(
                              value: performanceLevel,
                              child: Text(
                                performanceLevel.toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            );
                          }).toList(),
                        ],
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedPerformanceLevel = newValue;
                          });
                          _filterStaff();
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Staff List
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _errorMessage != null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _errorMessage!,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _loadEmployees,
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    )
                  : _filteredStaffMembers.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.people_outline,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _searchController.text.isNotEmpty
                                ? 'No employees found matching "${_searchController.text}"'
                                : 'No employees found',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _loadEmployees,
                      child: ListView.builder(
                        itemCount: _filteredStaffMembers.length,
                        itemBuilder: (context, index) {
                          final staff = _filteredStaffMembers[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withValues(alpha: 0.1),
                                  spreadRadius: 1,
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: GestureDetector(
                              onTap: () {
                                // Navigate to employee profile screen
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder:
                                        (
                                          context,
                                          animation,
                                          secondaryAnimation,
                                        ) => EmployeeProfileScreen(
                                          staffMember: staff,
                                          userRole: widget.userRole,
                                        ),
                                    transitionDuration: Duration.zero,
                                    reverseTransitionDuration: Duration.zero,
                                  ),
                                );
                              },
                              child: Row(
                                children: [
                                  // Profile Picture
                                  CircleAvatar(
                                    radius: 24,
                                    backgroundColor: const Color(0xFFE5E7EB),
                                    backgroundImage: staff.avatar.isNotEmpty
                                        ? AssetImage(staff.avatar)
                                        : null,
                                    child: staff.avatar.isEmpty
                                        ? Text(
                                            staff.name
                                                .split(' ')
                                                .map(
                                                  (name) => name.isNotEmpty
                                                      ? name[0]
                                                      : '',
                                                )
                                                .join('')
                                                .toUpperCase(),
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xFF6B7280),
                                            ),
                                          )
                                        : null,
                                  ),
                                  const SizedBox(width: 16),

                                  // Name and Role
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          staff.name,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          staff
                                              .role, // Now shows actual position from API
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Color(0xFF6B7280),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Score Badge
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _getScoreBackgroundColor(
                                        staff.score,
                                      ),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      '${staff.score}%',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: _getScoreColor(staff.score),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        userRole: widget.userRole,
      ),
    );
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterStaff);
    _searchController.dispose();
    super.dispose();
  }
}

class StaffMember {
  final String employeeId;
  final String name;
  final String role;
  final int score;
  final String avatar;
  final String status;
  final int attendanceCount;
  final int violationCount;
  final List<String> zones;
  final String? lastSeen;
  final int? attendanceRate;
  final String department;
  final String performanceLevel;

  StaffMember({
    required this.employeeId,
    required this.name,
    required this.role,
    required this.score,
    required this.avatar,
    required this.status,
    required this.attendanceCount,
    required this.violationCount,
    required this.zones,
    this.lastSeen,
    this.attendanceRate,
    required this.department,
    required this.performanceLevel,
  });

  // Safe getter for attendance rate
  int get safeAttendanceRate => attendanceRate ?? score;

  // Removed getTranslatedRole method since we now show actual position from API
}
