import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:insight/view/admin_dashboard.dart';
import 'package:insight/view/edit_profile_screen.dart';
import 'package:insight/view/manage_branch_screen.dart';
import 'package:insight/view/manage_users_screen.dart';
import 'package:insight/view/report_screen.dart';
import 'package:insight/view/staff_screen.dart';
import 'package:insight/widgets/bottom_bar.dart';
import 'package:insight/view/login.dart';
import 'package:insight/services/user_session.dart';
import 'package:insight/services/api_service.dart';
import 'package:insight/services/ai_api_service.dart';
import 'package:insight/utils/image_utils.dart';
import 'package:insight/l10n/app_localizations.dart';
import 'package:insight/widgets/language_switcher_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSettingsScreen extends StatefulWidget {
  final String userRole;

  const UserSettingsScreen({super.key, required this.userRole});

  @override
  State<UserSettingsScreen> createState() => _UserSettingsScreenState();
}

class _UserSettingsScreenState extends State<UserSettingsScreen> {
  final int _currentIndex = 3;

  void _onItemTapped(int index) {
    if (index == _currentIndex) return;

    Widget page;
    switch (index) {
      case 0:
        page = AdminDashboard(userRole: widget.userRole);
        break;
      case 1:
        page = ReportScreen(userRole: widget.userRole);
        break;
      case 2:
        page = StaffScreen(userRole: widget.userRole);
        break;
      case 3:
        page = UserSettingsScreen(userRole: widget.userRole);
        break;
      default:
        return;
    }
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionDuration: Duration.zero,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _UserProfileSection(userRole: widget.userRole),
                const SizedBox(height: 24),
                if (_isAdminUser()) ...[
                  const _NotificationPreferencesSection(),
                  const SizedBox(height: 24),
                  const _ReportSettingsSection(),
                  const SizedBox(height: 24),
                  const _ManageSection(),
                  const SizedBox(height: 24),
                  _AiAlertSensitivitySection(),
                  const SizedBox(height: 24),
                ],
                const _PrivacyAndSecuritySection(),
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
    );
  }

  bool _isAdminUser() {
    return widget.userRole.toLowerCase() == 'admin';
  }
}

class _UserProfileSection extends StatefulWidget {
  final String userRole;

  const _UserProfileSection({required this.userRole});

  @override
  State<_UserProfileSection> createState() => _UserProfileSectionState();
}

class _UserProfileSectionState extends State<_UserProfileSection> {
  String? _displayName;
  String? _email;
  String? _profilePicture;
  bool _isLoading = true;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh data when returning to this screen
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userSession = UserSession.instance;

    // First load from session (fast)
    setState(() {
      _displayName = userSession.userDisplayName;
      _email = userSession.userEmail;
      _profilePicture = userSession.userProfilePicture;
      _isLoading = false;
    });

    // Then try to refresh from server (to get latest data)
    try {
      if (userSession.userId != null && userSession.currentToken != null) {
        final response = await _apiService.getProfile(
          userSession.userId!,
          userSession.currentToken!,
        );

        final user = response['user'];
        userSession.updateUserData(user);

        // Update UI with fresh data
        if (mounted) {
          setState(() {
            _displayName = user['displayName'];
            _email = user['email'];
            _profilePicture = user['profilePicture'];
          });
        }
      }
    } catch (e) {
      // If refresh fails, just continue with cached data
      print('Failed to refresh profile data: $e');
    }
  }

  Widget _buildProfileImage() {
    if (_profilePicture != null && _profilePicture!.isNotEmpty) {
      // Handle base64 image
      if (_profilePicture!.startsWith('data:image')) {
        try {
          final base64String = ImageUtils.extractBase64FromDataUrl(
            _profilePicture!,
          );
          if (base64String != null) {
            final bytes = base64Decode(base64String);
            return CircleAvatar(
              radius: 30,
              backgroundImage: MemoryImage(bytes),
            );
          }
        } catch (e) {
          // If base64 decoding fails, fall back to default
        }
      }
      // Handle network image URL
      return CircleAvatar(
        radius: 30,
        backgroundImage: NetworkImage(_profilePicture!),
        onBackgroundImageError: (exception, stackTrace) {
          // If network image fails, fall back to default
        },
      );
    }

    // Default avatar
    return const CircleAvatar(
      radius: 30,
      backgroundColor: Color(0xFFE5E7EB),
      child: Icon(Icons.person, size: 30, color: Color(0xFF9CA3AF)),
    );
  }

  String _getDisplayText() {
    // If user has a display name, use it; otherwise use role
    if (_displayName != null && _displayName!.isNotEmpty) {
      return _displayName!;
    }
    return _getRoleDisplayName(widget.userRole);
  }

  String _getEmailText() {
    // Use actual user email if available
    if (_email != null && _email!.isNotEmpty) {
      return _email!;
    }
    return AppLocalizations.of(context)?.noEmailSet ?? 'No email set';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const EditProfileScreen()),
        );
        // Refresh user data when returning from edit profile
        if (result != null || mounted) {
          _loadUserData();
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: _isLoading
            ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: CircularProgressIndicator(color: Color(0xFF209A9F)),
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildProfileImage(),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _getDisplayText(),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _getEmailText(),
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF6B7280),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  Row(
                    children: [
                      Text(
                        AppLocalizations.of(context)?.editProfile ?? 'Edit Profile',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF374151),
                        ),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Color(0xFF9CA3AF),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }

  String _getRoleDisplayName(String role) {
    final localizations = AppLocalizations.of(context);
    switch (role.toLowerCase()) {
      case 'auditor':
        return localizations?.auditor ?? 'Auditor';
      case 'supervisor':
        return localizations?.supervisor ?? 'Supervisor';
      case 'admin':
        return localizations?.admin ?? 'Admin';
      default:
        return localizations?.user ?? 'User';
    }
  }
}

class _NotificationPreferencesSection extends StatefulWidget {
  const _NotificationPreferencesSection();

  @override
  State<_NotificationPreferencesSection> createState() =>
      _NotificationPreferencesSectionState();
}

class _NotificationPreferencesSectionState
    extends State<_NotificationPreferencesSection> {
  bool harassmentAlerts = false;
  bool inactivityNotifications = false;
  bool mobileUsageAlerts = true;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return _buildSection(
      context,
      title: localizations?.notificationPreferences ?? 'Notification Preferences',
      child: Column(
        children: [
          _buildSwitchTile(
            title: localizations?.harassmentAlerts ?? 'Harassment Alerts',
            subtitle: localizations?.harassmentAlertsSubtitle ?? 'Receive alerts for potential harassment incidents',
            value: harassmentAlerts,
            onChanged: (val) => setState(() => harassmentAlerts = val),
          ),
          const SizedBox(height: 16),
          _buildSwitchTile(
            title: localizations?.inactivityNotifications ?? 'Inactivity Notifications',
            subtitle: localizations?.inactivityNotificationsSubtitle ?? 'Receive notifications when no activity is detected',
            value: inactivityNotifications,
            onChanged: (val) => setState(() => inactivityNotifications = val),
          ),
          const SizedBox(height: 16),
          _buildSwitchTile(
            title: localizations?.mobileUsageAlerts ?? 'Mobile Usage Alerts',
            subtitle: localizations?.mobileUsageAlertsSubtitle ?? 'Receive alerts when unusual mobile usage is detected',
            value: mobileUsageAlerts,
            onChanged: (val) => setState(() => mobileUsageAlerts = val),
          ),
        ],
      ),
    );
  }
}

class _ReportSettingsSection extends StatefulWidget {
  const _ReportSettingsSection();

  @override
  State<_ReportSettingsSection> createState() => _ReportSettingsSectionState();
}

class _ReportSettingsSectionState extends State<_ReportSettingsSection> {
  String reportFormat = 'PDF';

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return _buildSection(
      context,
      title: localizations?.reportSettings ?? 'Report Settings',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(localizations?.autoDownloadWeeklyReports ?? 'Auto-download weekly reports'),
            subtitle: Text(
              localizations?.autoDownloadWeeklyReportsSubtitle ?? 'Automatically download weekly reports in your preferred format.',
              style: const TextStyle(color: Color(0xFF6B7280)),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            localizations?.reportFormat ?? 'Report Format',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            textAlign: TextAlign.start,
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: reportFormat,
            icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
              ),
            ),
            onChanged: (String? newValue) {
              setState(() {
                reportFormat = newValue!;
              });
            },
            items: <String>[
              localizations?.pdf ?? 'PDF',
              localizations?.excel ?? 'Excel'
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(value: value, child: Text(value));
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _ManageSection extends StatelessWidget {
  const _ManageSection();

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return Column(
      children: [
        _buildManageTile(
          context,
          iconPath: 'assets/branch.svg',
          title: localizations?.manageBranches ?? 'Manage Branches',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ManageBranchScreen(),
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        _buildManageTile(
          context,
          iconPath: 'assets/manage.svg',
          title: localizations?.manageUsers ?? 'Manage Users',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ManageUsersScreen(),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _AiAlertSensitivitySection extends StatefulWidget {
  const _AiAlertSensitivitySection();

  @override
  State<_AiAlertSensitivitySection> createState() =>
      _AiAlertSensitivitySectionState();
}

class _AiAlertSensitivitySectionState
    extends State<_AiAlertSensitivitySection> {
  final AiApiService _aiApiService = AiApiService();
  double sensitivity = 1.0; // 0=low, 1=medium, 2=high
  bool _isLoading = false;
  static const String _prefsKey = 'ai_sensitivity_level';

  @override
  void initState() {
    super.initState();
    _initializeSensitivity();
  }

  Future<void> _initializeSensitivity() async {
    // Load locally saved level first for instant UI, then refresh from server
    final prefs = await SharedPreferences.getInstance();
    final savedLevel = prefs.getString(_prefsKey);
    if (savedLevel != null && mounted) {
      setState(() => sensitivity = _levelToIndex(savedLevel));
    }
    await _fetchCurrentSensitivity();
  }

  Future<void> _fetchCurrentSensitivity() async {
    setState(() => _isLoading = true);
    try {
      final token = UserSession.instance.currentToken;
      final response = await _aiApiService.getAiSensitivity(token: token);

      final String? level = _extractLevelFromResponse(response);

      if (level != null) {
        setState(() {
          sensitivity = _levelToIndex(level);
        });
        // Persist locally
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_prefsKey, level);
      }
    } catch (e) {
      // Keep default on failure
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String? _extractLevelFromResponse(Map<String, dynamic> response) {
    // Preferred structure: { ai_sensitivity_settings: { sensitivity_level: "low" } }
    final settings = response['ai_sensitivity_settings'];
    if (settings is Map && settings['sensitivity_level'] is String) {
      return (settings['sensitivity_level'] as String).toLowerCase();
    }
    // Alternate structures fallbacks
    if (response['level'] is String) return (response['level'] as String).toLowerCase();
    if (response['sensitivity'] is String) return (response['sensitivity'] as String).toLowerCase();
    final data = response['data'];
    if (data is Map && data['level'] is String) return (data['level'] as String).toLowerCase();
    if (data is String) return data.toLowerCase();
    return null;
  }

  double _levelToIndex(String level) {
    switch (level) {
      case 'low':
        return 0.0;
      case 'high':
        return 2.0;
      case 'medium':
      default:
        return 1.0;
    }
  }

  String _indexToLevel(double index) {
    final int i = index.round().clamp(0, 2);
    if (i == 0) return 'low';
    if (i == 2) return 'high';
    return 'medium';
  }

  Future<void> _updateSensitivity(double newIndex) async {
    final String level = _indexToLevel(newIndex);
    try {
      final token = UserSession.instance.currentToken;
      await _aiApiService.setAiSensitivityLevel(level, token: token);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefsKey, level);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('AI sensitivity set to ${level[0].toUpperCase()}${level.substring(1)}')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update sensitivity')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return _buildSection(
      context,
      title: localizations?.aiAlertSensitivity ?? 'AI Alert Sensitivity',
      child: Column(
        children: [
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 4.0,
              thumbColor: const Color(0xFF209A9F),
              overlayColor: const Color(0xFF209A9F).withAlpha(50),
              activeTrackColor: const Color(0xFFD1D5DB),
              inactiveTrackColor: const Color(0xFFD1D5DB),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 18),
              activeTickMarkColor: Colors.transparent,
              inactiveTickMarkColor: Colors.transparent,
            ),
            child: Slider(
              value: sensitivity,
              min: 0,
              max: 2,
              divisions: 2,
              onChanged: (val) => setState(() => sensitivity = val.roundToDouble()),
              onChangeEnd: (val) {
                final snapped = val.roundToDouble().clamp(0.0, 2.0);
                setState(() => sensitivity = snapped);
                _updateSensitivity(snapped);
              },
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(localizations?.low ?? 'Low', style: const TextStyle(color: Color(0xFF6B7280))),
              Text(localizations?.medium ?? 'Medium', style: const TextStyle(color: Color(0xFF6B7280))),
              Text(localizations?.high ?? 'High', style: const TextStyle(color: Color(0xFF6B7280))),
            ],
          ),
          if (_isLoading) const SizedBox(height: 12),
          if (_isLoading) const LinearProgressIndicator(minHeight: 2),
        ],
      ),
    );
  }
}

class _PrivacyAndSecuritySection extends StatelessWidget {
  const _PrivacyAndSecuritySection();

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return _buildSection(
      context,
      title: localizations?.privacyAndSecurity ?? 'Privacy and Security',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPrivacyItem(
            context,
            iconPath: 'assets/privacy.svg',
            title: localizations?.privacySettings ?? 'Privacy Settings',
            onTap: () {},
          ),
          const SizedBox(height: 8),
          _buildPrivacyItem(
            context,
            iconPath: 'assets/security.svg',
            title: localizations?.securitySettings ?? 'Security Settings',
            onTap: () {},
          ),
          const SizedBox(height: 8),
          _buildPrivacyItem(
            context,
            iconPath: 'assets/lock.svg',
            title: localizations?.twoFactorAuthentication ?? 'Two-Factor Authentication',
            onTap: () {},
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              const _LogoutButton(),
              const SizedBox(width: 12),
              const LanguageSwitcherButton(),
            ],
          ),
        ],
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  const _LogoutButton();

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return OutlinedButton.icon(
      onPressed: () async {
        // Clear user session
        await UserSession.instance.clearSession();

        // Navigate to login screen
        if (context.mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (Route<dynamic> route) => false,
          );
        }
      },
      icon: SvgPicture.asset('assets/logout.svg'),
      label: Text(
        localizations?.logOut ?? 'Log Out',
        style: const TextStyle(color: Color(0xFF209A9F), fontWeight: FontWeight.bold),
      ),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        minimumSize: const Size(0, 40), // allow button to shrink
        side: const BorderSide(color: Color(0xFF209A9F), width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
    );
  }
}

Widget _buildSection(
  BuildContext context, {
  required String title,
  required Widget child,
}) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          textAlign: TextAlign.start,
        ),
        const SizedBox(height: 8),
        child,
      ],
    ),
  );
}

Widget _buildSwitchTile({
  required String title,
  required String subtitle,
  required bool value,
  required ValueChanged<bool> onChanged,
}) {
  return ListTile(
    contentPadding: EdgeInsets.zero,
    title: Text(title),
    subtitle: Text(subtitle, style: const TextStyle(color: Color(0xFF6B7280))),
    trailing: Switch(
      value: value,
      onChanged: onChanged,
      activeTrackColor: const Color(0xFF209A9F),
      activeColor: const Color(0xFFD4D4D4),
      inactiveTrackColor: const Color(0xFFE5E7EB),
      inactiveThumbColor: const Color(0xFFD4D4D4),
      trackOutlineColor: MaterialStateProperty.resolveWith<Color?>((
        Set<MaterialState> states,
      ) {
        if (states.contains(MaterialState.selected)) {
          return null;
        }
        return Colors.transparent;
      }),
    ),
    onTap: () {
      onChanged(!value);
    },
  );
}

Widget _buildManageTile(
  BuildContext context, {
  required String iconPath,
  required String title,
  VoidCallback? onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB), // light grey
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(
            children: [
              SvgPicture.asset(
                iconPath,
                width: 20,
                height: 20,
                colorFilter: const ColorFilter.mode(
                  Color(0xFF4B5563),
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 16),
              Text(title, style: const TextStyle(fontSize: 16)),
              const Spacer(),
              const Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: Color(0xFF9CA3AF),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget _buildPrivacyItem(
  BuildContext context, {
  required String iconPath,
  required String title,
  VoidCallback? onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB), // light grey
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          SvgPicture.asset(iconPath, width: 16, height: 16),
          const SizedBox(width: 16),
          Text(title, style: const TextStyle(fontSize: 16)),
          const Spacer(),
          const Icon(
            Icons.arrow_forward_ios,
            size: 14,
            color: Color(0xFF9CA3AF),
          ),
        ],
      ),
    ),
  );
}
