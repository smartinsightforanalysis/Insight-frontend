import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import '../services/api_service.dart';
import '../services/user_session.dart';
import '../utils/image_utils.dart';
import 'change_password_screen.dart';
import 'login.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _displayNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _bioController;
  File? _imageFile;
  
  final ApiService _apiService = ApiService();
  bool _isLoading = false;
  bool _isLoadingProfile = true;
  String? _currentProfilePicture;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _displayNameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _bioController = TextEditingController();
    _loadUserProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _displayNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _loadUserProfile() async {
    setState(() {
      _isLoadingProfile = true;
    });

    try {
      final userSession = UserSession.instance;
      
      // Debug: Print session data
      print('Debug - User Session Data:');
      print('  User ID: ${userSession.userId}');
      print('  Token: ${userSession.currentToken != null ? "Available" : "Not available"}');
      print('  Current User: ${userSession.currentUser}');
      
      // Always load from session data first (immediate UI update)
      setState(() {
        _nameController.text = userSession.userName ?? '';
        _displayNameController.text = userSession.userDisplayName ?? userSession.userName ?? '';
        _emailController.text = userSession.userEmail ?? '';
        _phoneController.text = userSession.userPhoneNumber ?? '';
        _bioController.text = userSession.userBio ?? '';
        _currentProfilePicture = userSession.userProfilePicture;
        _isLoadingProfile = false;
      });
      
      // If no session data, show error
      if (userSession.currentUser == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No user session found. Please log in again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }
      
      // Then try to fetch fresh data from server (optional)
      if (userSession.userId != null && userSession.currentToken != null) {
        try {
          final response = await _apiService.getProfile(
            userSession.userId!,
            userSession.currentToken!,
          );
          
          final user = response['user'];
          // Update session with fresh data
          userSession.updateUserData(user);
          
          // Update UI with fresh data
          if (mounted) {
            setState(() {
              _nameController.text = user['name'] ?? '';
              _displayNameController.text = user['displayName'] ?? user['name'] ?? '';
              _emailController.text = user['email'] ?? '';
              _phoneController.text = user['phoneNumber'] ?? '';
              _bioController.text = user['bio'] ?? '';
              _currentProfilePicture = user['profilePicture'];
            });
          }
        } catch (apiError) {
          // If API fails, just use cached data (no error shown)
          print('API call failed, using cached data: $apiError');
        }
      }
    } catch (e) {
      print('Error loading profile: $e');
      setState(() {
        _isLoadingProfile = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load profile: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final userSession = UserSession.instance;
      
      // Debug: Print session data during update
      print('Update Profile - Debug Session Data:');
      print('  User ID: ${userSession.userId}');
      print('  Token: ${userSession.currentToken != null ? "Available (${userSession.currentToken!.substring(0, 20)}...)" : "Not available"}');
      print('  Current User: ${userSession.currentUser}');
      
      if (userSession.userId == null || userSession.currentToken == null) {
        print('Update Profile - Missing session data! Trying to reload session...');
        
        // Try to reload session from SharedPreferences
        final sessionLoaded = await userSession.loadUserSession();
        print('Session reload result: $sessionLoaded');
        print('After reload - User ID: ${userSession.userId}');
        print('After reload - Token: ${userSession.currentToken != null ? "Available" : "Not available"}');
        
        if (userSession.userId == null || userSession.currentToken == null) {
          throw Exception('User not logged in - please log in again');
        }
      }
      
      // Validate userId format (MongoDB ObjectId should be 24 characters)
      final userId = userSession.userId!;
      if (userId.length != 24) {
        print('Invalid userId format: $userId (length: ${userId.length})');
        throw Exception('Invalid user session format - please log in again');
      }

      String? profilePictureBase64;
      if (_imageFile != null) {
        // Show processing message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Processing image...'),
              duration: Duration(seconds: 2),
            ),
          );
        }
        
        profilePictureBase64 = await ImageUtils.imageToBase64(_imageFile!);
        if (profilePictureBase64 == null) {
          throw Exception('Failed to process image');
        }
        
        // Check final base64 size (should be under 16MB for MongoDB)
        final base64Size = profilePictureBase64.length * 0.75; // Approximate decoded size
        if (base64Size > 16 * 1024 * 1024) { // 16MB MongoDB limit
          throw Exception('Processed image is still too large. Please use a smaller image.');
        }
      }

      print('Making API call with userId: ${userSession.userId}');
      
      final response = await _apiService.updateProfile(
        userId: userSession.userId!,
        token: userSession.currentToken!,
        name: _nameController.text.trim(),
        displayName: _displayNameController.text.trim(),
        email: _emailController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        bio: _bioController.text.trim(),
        profilePicture: profilePictureBase64,
      );
      
      print('API call successful: ${response['message']}');

      // Update user session with new data
      userSession.updateUserData(response['user']);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      print('Update profile error: $e');
      
      if (mounted) {
        String errorMessage = 'Failed to update profile';
        
        if (e.toString().contains('User not logged in')) {
          errorMessage = 'Session expired. Please log in again.';
          // Clear session and navigate to login screen
          await UserSession.instance.clearSession();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false,
          );
          return;
        } else if (e.toString().contains('PayloadTooLargeError') || 
            e.toString().contains('request entity too large')) {
          errorMessage = 'Image is too large. Please select a smaller image.';
        } else if (e.toString().contains('Email already exists')) {
          errorMessage = 'This email is already in use by another account.';
        } else if (e.toString().contains('Phone number already exists')) {
          errorMessage = 'This phone number is already in use by another account.';
        } else if (e.toString().contains('Failed to process image')) {
          errorMessage = 'Failed to process the selected image. Please try another image.';
        } else if (e.toString().contains('too large')) {
          errorMessage = 'Image is too large. Please select a smaller image.';
        } else if (e.toString().contains('Invalid user ID')) {
          errorMessage = 'Invalid session. Please log in again.';
        } else {
          errorMessage = 'Failed to update profile: ${e.toString()}';
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        final file = File(pickedFile.path);
        
        // Check file size (limit to 10MB before compression)
        final fileSize = await file.length();
        if (fileSize > 10 * 1024 * 1024) { // 10MB
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Image is too large. Please select a smaller image.'),
                backgroundColor: Colors.red,
              ),
            );
          }
          return;
        }
        
        setState(() {
          _imageFile = file;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to pick image: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showImageSourceActionSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Photo Library'),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Camera'),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    if (_imageFile != null) {
      return CircleAvatar(
        radius: 50,
        backgroundImage: FileImage(_imageFile!),
      );
    } else if (_currentProfilePicture != null && _currentProfilePicture!.isNotEmpty) {
      // Handle base64 image
      if (_currentProfilePicture!.startsWith('data:image')) {
        try {
          final base64String = ImageUtils.extractBase64FromDataUrl(_currentProfilePicture!);
          if (base64String != null) {
            final bytes = base64Decode(base64String);
            return CircleAvatar(
              radius: 50,
              backgroundImage: MemoryImage(bytes),
            );
          }
        } catch (e) {
          print('Error decoding base64 image: $e');
        }
      }
      // Handle network image URL
      return CircleAvatar(
        radius: 50,
        backgroundImage: NetworkImage(_currentProfilePicture!),
        onBackgroundImageError: (exception, stackTrace) {
          print('Error loading network image: $exception');
        },
      );
    }
    
    // Default avatar
    return const CircleAvatar(
      radius: 50,
      backgroundColor: Color(0xFFE5E7EB),
      child: Icon(
        Icons.person,
        size: 50,
        color: Color(0xFF9CA3AF),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: const Color(0xFFE5E7EB),
            height: 1.0,
          ),
        ),
      ),
      body: _isLoadingProfile
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF209A9F),
              ),
            )
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                Center(
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      _buildProfileImage(),
                      Positioned(
                        bottom: 5,
                        right: -5,
                        child: GestureDetector(
                          onTap: _showImageSourceActionSheet,
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE5E7EB),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 2,
                              ),
                            ),
                            child: const Icon(Icons.camera_alt,
                                size: 16, color: Color(0xFF4B5563)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Center(
                  child: TextButton(
                    onPressed: _showImageSourceActionSheet,
                    child: const Text(
                      'Change Photo',
                      style: TextStyle(
                        color: Color(0xFF209A9F),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                _buildTextField(
                    label: 'Name', 
                    controller: _nameController, 
                    hint: 'Enter your name',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Name is required';
                      }
                      return null;
                    }),
                const SizedBox(height: 16),
                _buildTextField(
                    label: 'Display Name',
                    controller: _displayNameController,
                    hint: 'Enter your display name'),
                const SizedBox(height: 16),
                _buildTextField(
                    label: 'Email Address',
                    controller: _emailController,
                    hint: 'Enter your email address',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Email is required';
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value.trim())) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    }),
                const SizedBox(height: 16),
                _buildTextField(
                    label: 'Phone Number',
                    controller: _phoneController,
                    hint: 'Enter your phone number',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Phone number is required';
                      }
                      if (!RegExp(r'^\+?[\d\s\-\(\)]+$').hasMatch(value.trim())) {
                        return 'Please enter a valid phone number';
                      }
                      return null;
                    }),
                const SizedBox(height: 16),
                _buildTextField(
                    label: 'Bio',
                    controller: _bioController,
                    maxLines: 4,
                    hint: 'Tell us about yourself',
                    validator: (value) {
                      if (value != null && value.length > 500) {
                        return 'Bio cannot exceed 500 characters';
                      }
                      return null;
                    }),
                const SizedBox(height: 16),
                TextButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ChangePasswordScreen(),
                        ),
                      );
                    },
                    icon: SvgPicture.asset(
                      'assets/privacy.svg',
                      width: 16,
                      height: 16,
                      colorFilter: const ColorFilter.mode(
                          Color(0xFF209A9F), BlendMode.srcIn),
                    ),
                    label: const Text(
                      'Change Password',
                      style: TextStyle(
                        color: Color(0xFF209A9F),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.zero,
                    )),
                const SizedBox(height: 40),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE5E7EB),
                          foregroundColor: const Color(0xFF374151),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Text('Cancel',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _updateProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF209A9F),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Save Changes',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    String? hint,
    bool readOnly = false,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF374151),
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          readOnly: readOnly,
          maxLines: maxLines,
          validator: validator,
          style: const TextStyle(fontSize: 14, color: Colors.black),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFFADAEBC)),
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF209A9F)),
            ),
          ),
        ),
      ],
    );
  }
} 