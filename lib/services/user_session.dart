import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UserSession {
  static const String _userKey = 'user_data';
  static const String _tokenKey = 'auth_token';

  static UserSession? _instance;
  static UserSession get instance => _instance ??= UserSession._();
  UserSession._();

  Map<String, dynamic>? _currentUser;
  String? _currentToken;

  // Getters
  Map<String, dynamic>? get currentUser => _currentUser;
  String? get currentToken => _currentToken;
  String? get userId => _currentUser?['id'] ?? _currentUser?['_id'];
  String? get userName => _currentUser?['name'];
  String? get userEmail => _currentUser?['email'];
  String? get userRole => _currentUser?['role'];
  String? get userDisplayName => _currentUser?['displayName'];
  String? get userPhoneNumber => _currentUser?['phoneNumber'];
  String? get userBio => _currentUser?['bio'];
  String? get userProfilePicture => _currentUser?['profilePicture'];

  // Save user session
  Future<void> saveUserSession({
    required Map<String, dynamic> user,
    required String token,
  }) async {
    _currentUser = user;
    _currentToken = token;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, json.encode(user));
    await prefs.setString(_tokenKey, token);
  }

  // Load user session
  Future<bool> loadUserSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString(_userKey);
      final token = prefs.getString(_tokenKey);

      if (userData != null && token != null) {
        _currentUser = json.decode(userData);
        _currentToken = token;
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // Update user data
  void updateUserData(Map<String, dynamic> updatedUser) {
    _currentUser = updatedUser;
    _saveUserDataToPrefs();
  }

  // Clear session
  Future<void> clearSession() async {
    _currentUser = null;
    _currentToken = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    await prefs.remove(_tokenKey);
  }

  // Check if user is logged in
  bool get isLoggedIn => _currentUser != null && _currentToken != null;

  // Private method to save user data to preferences
  Future<void> _saveUserDataToPrefs() async {
    if (_currentUser != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userKey, json.encode(_currentUser));
    }
  }
}