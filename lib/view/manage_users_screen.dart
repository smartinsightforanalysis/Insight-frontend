import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:insight/view/add_new_user_screen.dart';
import 'package:insight/l10n/app_localizations.dart';
import '../services/api_service.dart';
import '../services/user_session.dart';

class ManageUsersScreen extends StatefulWidget {
  const ManageUsersScreen({super.key});

  @override
  State<ManageUsersScreen> createState() => _ManageUsersScreenState();
}

class _ManageUsersScreenState extends State<ManageUsersScreen>
    with WidgetsBindingObserver {
  List<Map<String, dynamic>> users = [];
  bool _isLoading = true;
  String? _error;
  final ApiService _apiService = ApiService();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadUsers();

    // Add focus listener to refresh when screen gains focus
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _loadUsers();
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Refresh data when app comes back to foreground
      _loadUsers();
    }
  }

  Future<void> _loadUsers() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      // Clear image cache to ensure fresh profile pictures
      PaintingBinding.instance.imageCache.clear();
      PaintingBinding.instance.imageCache.clearLiveImages();

      final token = UserSession.instance.currentToken;
      if (token == null) {
        throw Exception('Authentication token not found. Please login again.');
      }

      print('Loading users with token: ${token.substring(0, 20)}...'); // Debug log
      print('User role: ${UserSession.instance.userRole}'); // Debug log

      final response = await _apiService.getAllUsers(token);
      print('Users response: $response'); // Debug log

      final usersList = response['users'] as List<dynamic>;

      // Filter out admin users
      final filteredUsers = usersList
          .where((user) => user['role'] != 'admin')
          .map((user) => Map<String, dynamic>.from(user))
          .toList();

      setState(() {
        users = filteredUsers;
        _isLoading = false;
      });

      print('Loaded ${users.length} users'); // Debug log
    } catch (e) {
      print('Error loading users: $e'); // Debug log

      // Handle specific 403 error
      if (e.toString().contains('403') || e.toString().contains('Forbidden')) {
        setState(() {
          _error = 'Access denied. You may not have permission to view users or your session may have expired. Please try logging out and logging back in.';
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = e.toString().replaceFirst('Exception: ', '');
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          localizations?.manageUsers ?? 'Manage Users',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black),
            onPressed: _loadUsers,
          ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ElevatedButton.icon(
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddNewUserScreen()),
            );

            // Reload users if a new user was added
            if (result == true) {
              _loadUsers();
            }
          },
          icon: const Icon(Icons.add, color: Colors.white, size: 24.0),
          label: Text(
            localizations?.addNewUser ?? 'Add New User',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF209A9F),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            minimumSize: const Size(double.infinity, 50),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF209A9F)),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Error: $_error',
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadUsers,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF209A9F),
              ),
              child: Text(
                AppLocalizations.of(context)?.retry ?? 'Retry',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      );
    }

    if (users.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_outline, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)?.noUsersFound ?? 'No users found',
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadUsers,
      child: ListView.separated(
        padding: const EdgeInsets.all(16.0),
        itemCount: users.length,
        itemBuilder: (context, index) {
          return _UserListItem(
            key: ValueKey(
              '${users[index]['id']}_${users[index]['updatedAt'] ?? DateTime.now().millisecondsSinceEpoch}',
            ),
            user: users[index],
          );
        },
        separatorBuilder: (context, index) => const SizedBox(height: 8),
      ),
    );
  }
}

class _UserListItem extends StatelessWidget {
  final Map<String, dynamic> user;

  const _UserListItem({super.key, required this.user});

  Color _getRoleColor(String role) {
    switch (role.toLowerCase()) {
      case 'supervisor':
        return const Color(0xFFDBEAFE);
      case 'auditor':
        return const Color(0xFFD1FAE5);
      default:
        return Colors.grey[200]!;
    }
  }

  Color _getRoleTextColor(String role) {
    switch (role.toLowerCase()) {
      case 'supervisor':
        return const Color(0xFF0E7490);
      case 'auditor':
        return const Color(0xFF065F46);
      default:
        return Colors.grey[800]!;
    }
  }

  String _formatLastOnline(BuildContext context, String? lastLogin) {
    final localizations = AppLocalizations.of(context);
    if (lastLogin == null)
      return localizations?.neverLoggedIn ?? 'Never logged in';

    try {
      final DateTime loginTime = DateTime.parse(lastLogin);
      final DateTime now = DateTime.now();
      final Duration difference = now.difference(loginTime);

      if (difference.inDays > 0) {
        return '${difference.inDays}d ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours}h ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes}m ago';
      } else {
        return localizations?.justNow ?? 'Just now';
      }
    } catch (e) {
      return localizations?.unknown ?? 'Unknown';
    }
  }

  String _capitalizeRole(String role) {
    return role[0].toUpperCase() + role.substring(1);
  }

  Widget _buildProfileImage(String profilePicture, String name) {
    // Handle base64 images (data URLs)
    if (profilePicture.startsWith('data:image')) {
      try {
        // Extract base64 data from data URL
        final base64Data = profilePicture.split(',')[1];
        final bytes = base64Decode(base64Data);

        return Image.memory(
          bytes,
          width: 48,
          height: 48,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Text(
              name.isNotEmpty ? name[0].toUpperCase() : 'U',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        );
      } catch (e) {
        // If base64 decoding fails, show initials
        return Text(
          name.isNotEmpty ? name[0].toUpperCase() : 'U',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        );
      }
    } else {
      // Handle regular URL images with cache busting
      final cacheKey =
          '${profilePicture}?t=${DateTime.now().millisecondsSinceEpoch}';
      return Image.network(
        cacheKey,
        width: 48,
        height: 48,
        fit: BoxFit.cover,
        // Add cache headers to prevent caching issues
        headers: {'Cache-Control': 'no-cache', 'Pragma': 'no-cache'},
        errorBuilder: (context, error, stackTrace) {
          return Text(
            name.isNotEmpty ? name[0].toUpperCase() : 'U',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final String name =
        user['name'] ??
        user['displayName'] ??
        (localizations?.unknownUser ?? 'Unknown User');
    final String role =
        user['role'] ?? (localizations?.unknownRole ?? 'unknown');
    final String lastOnline = _formatLastOnline(context, user['lastLogin']);

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: const Color(0xFF209A9F),
            child:
                user['profilePicture'] != null &&
                    user['profilePicture'].isNotEmpty
                ? ClipOval(
                    child: _buildProfileImage(user['profilePicture'], name),
                  )
                : Text(
                    name.isNotEmpty ? name[0].toUpperCase() : 'U',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 8.0,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getRoleColor(role),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _capitalizeRole(role),
                        style: TextStyle(
                          color: _getRoleTextColor(role),
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Text(
                      'Last Active: $lastOnline',
                      style: const TextStyle(
                        color: Color(0xFF6B7280),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              // TODO: show options
            },
            icon: SvgPicture.asset('assets/3dots.svg', width: 4, height: 16),
          ),
        ],
      ),
    );
  }
}
