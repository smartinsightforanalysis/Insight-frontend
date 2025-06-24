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
                  const _AiAlertSensitivitySection(),
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
      ),
    );
  }

  bool _isAdminUser() {
    return widget.userRole.toLowerCase() == 'admin';
  }
}

class _UserProfileSection extends StatelessWidget {
  final String userRole;

  const _UserProfileSection({required this.userRole});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const EditProfileScreen()),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('assets/jane.png'), // Placeholder
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getRoleDisplayName(userRole),
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    if (userRole.toLowerCase() != 'admin') ...[
                      const SizedBox(height: 4),
                      const Text(
                        'Kamraan.shaa@gmail.com',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
            const SizedBox(height: 22),
            Row(
              children: [
                Text(
                  'Edit Profile',
                  style: const TextStyle(fontSize: 14, color: Color(0xFF374151)),
                ),
                const Spacer(),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 16, 
                  color: Color(0xFF9CA3AF)
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getRoleDisplayName(String role) {
    switch (role.toLowerCase()) {
      case 'auditor':
        return 'Auditor';
      case 'supervisor':
        return 'Supervisor';
      case 'admin':
        return 'Admin';
      default:
        return 'User';
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
    return _buildSection(
      context,
      title: 'Notification Preferences',
      child: Column(
        children: [
          _buildSwitchTile(
            title: 'Harassment Alerts',
            subtitle: 'Receive alerts for potential harassment incidents',
            value: harassmentAlerts,
            onChanged: (val) => setState(() => harassmentAlerts = val),
          ),
          const SizedBox(height: 16),
          _buildSwitchTile(
            title: 'Inactivity Notifications',
            subtitle: 'Receive notifications when no activity is detected',
            value: inactivityNotifications,
            onChanged: (val) => setState(() => inactivityNotifications = val),
          ),
          const SizedBox(height: 16),
          _buildSwitchTile(
            title: 'Mobile Usage Alerts',
            subtitle: 'Receive alerts when unusual mobile usage is detected',
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
    return _buildSection(
      context,
      title: 'Report Settings',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text('Auto-download weekly reports'),
            subtitle: Text(
              'Automatically download weekly reports in your preferred format.',
              style: const TextStyle(color: Color(0xFF6B7280)),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Report Format',
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
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
            items: <String>['PDF', 'Excel']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
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
    return Column(
      children: [
        _buildManageTile(
          context,
          iconPath: 'assets/branch.svg',
          title: 'Manage Branches',
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
          title: 'Manage Users',
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
  double sensitivity = 0.2;

  @override
  Widget build(BuildContext context) {
    return _buildSection(
      context,
      title: 'AI Alert Sensitivity',
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
              onChanged: (val) => setState(() => sensitivity = val),
              divisions: 2,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Low', style: const TextStyle(color: Color(0xFF6B7280))),
              Text('Medium', style: const TextStyle(color: Color(0xFF6B7280))),
              Text('High', style: const TextStyle(color: Color(0xFF6B7280))),
            ],
          )
        ],
      ),
    );
  }
}

class _PrivacyAndSecuritySection extends StatelessWidget {
  const _PrivacyAndSecuritySection();

  @override
  Widget build(BuildContext context) {
    return _buildSection(
      context,
      title: 'Privacy and Security',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPrivacyItem(
            context,
            iconPath: 'assets/privacy.svg',
            title: 'Privacy Settings',
            onTap: () {},
          ),
          const SizedBox(height: 8),
          _buildPrivacyItem(
            context,
            iconPath: 'assets/security.svg',
            title: 'Security Settings',
            onTap: () {},
          ),
          const SizedBox(height: 8),
          _buildPrivacyItem(
            context,
            iconPath: 'assets/lock.svg',
            title: 'Two-Factor Authentication',
            onTap: () {},
          ),
          const SizedBox(height: 24),
          Align(
            alignment: Alignment.centerLeft,
            child: _LogoutButton(),
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
    return OutlinedButton.icon(
      onPressed: () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (Route<dynamic> route) => false,
        );
      },
      icon: SvgPicture.asset('assets/logout.svg'),
      label: const Text(
        'Log Out',
        style: TextStyle(color: Color(0xFF209A9F), fontWeight: FontWeight.bold),
      ),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        minimumSize: const Size(0, 40), // allow button to shrink
        side: const BorderSide(color: Color(0xFF209A9F), width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }
}

Widget _buildSection(BuildContext context,
    {required String title, required Widget child}) {
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
      trackOutlineColor: MaterialStateProperty.resolveWith<Color?>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.selected)) {
            return null;
          }
          return Colors.transparent;
        },
      ),
    ),
    onTap: () {
      onChanged(!value);
    },
  );
}

Widget _buildManageTile(BuildContext context,
    {required String iconPath, required String title, VoidCallback? onTap}) {
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
              SvgPicture.asset(iconPath,
                  width: 20,
                  height: 20,
                  colorFilter: const ColorFilter.mode(
                      Color(0xFF4B5563), BlendMode.srcIn)),
              const SizedBox(width: 16),
              Text(title, style: const TextStyle(fontSize: 16)),
              const Spacer(),
              const Icon(
                Icons.arrow_forward_ios,
                size: 14, 
                color: Color(0xFF9CA3AF)
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget _buildPrivacyItem(BuildContext context,
    {required String iconPath, required String title, VoidCallback? onTap}) {
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
            color: Color(0xFF9CA3AF)
          ),
        ],
      ),
    ),
  );
} 