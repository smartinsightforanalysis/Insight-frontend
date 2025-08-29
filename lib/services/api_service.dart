import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String _baseUrl = "http://147.93.152.203:3000/api";
  // 147.93.152.203:3000

  Future<Map<String, dynamic>> registerUser(
    String name,
    String email,
    String password,
    String role,
  ) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': name,
        'email': email,
        'password': password,
        'role': role,
      }),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> sendOtp(String email) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/send-otp'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email}),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> verifyOtp(String email, String otp) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/verify-otp'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'otp': otp}),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> verifyOTPAndRegister(
    String email,
    String otp,
    String name,
    String password,
    String role,
    String? phoneNumber,
  ) async {
    final Map<String, dynamic> requestBody = {
      'email': email,
      'otp': otp,
      'name': name,
      'password': password,
      'role': role,
    };

    // Only include phoneNumber if it's provided and not empty
    if (phoneNumber != null && phoneNumber.isNotEmpty) {
      requestBody['phoneNumber'] = phoneNumber;
    }

    final response = await http.post(
      Uri.parse('$_baseUrl/auth/verify-otp-and-register'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(requestBody),
    );

    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> resetPassword(
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/reset-password'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> changePassword(
    String currentPassword,
    String newPassword,
    String token,
  ) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/change-password'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      }),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> loginUser(
    String email,
    String password,
    String role,
  ) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password, 'role': role}),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> getProfile(String userId, String token) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/profile/get-profile/$userId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> updateProfile({
    required String userId,
    required String token,
    String? name,
    String? displayName,
    String? email,
    String? phoneNumber,
    String? bio,
    String? profilePicture,
  }) async {
    final Map<String, dynamic> body = {};
    if (name != null) body['name'] = name;
    if (displayName != null) body['displayName'] = displayName;
    if (email != null) body['email'] = email;
    if (phoneNumber != null) body['phoneNumber'] = phoneNumber;
    if (bio != null) body['bio'] = bio;
    if (profilePicture != null) body['profilePicture'] = profilePicture;

    final response = await http.put(
      Uri.parse('$_baseUrl/profile/update-profile/$userId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(body),
    );
    return _handleResponse(response);
  }

  // Admin - Add new user
  Future<Map<String, dynamic>> addUser({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String role,
    required String password,
    required String confirmPassword,
    required String token,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/admin/add-user'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'fullName': fullName,
        'email': email,
        'phoneNumber': phoneNumber,
        'role': role,
        'password': password,
        'confirmPassword': confirmPassword,
      }),
    );
    return _handleResponse(response);
  }

  // Admin - Get all users
  Future<Map<String, dynamic>> getAllUsers(String token) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/admin/get-all-users'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    return _handleResponse(response);
  }

  // Branch management methods
  Future<Map<String, dynamic>> addBranch({
    required String branchName,
    required String branchAddress,
    required String token,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/branch/add-branch'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'branchName': branchName,
        'branchAddress': branchAddress,
      }),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> getAllBranches() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/branch/get-all-branches'),
      headers: {'Content-Type': 'application/json'},
    );
    return _handleResponse(response);
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json.decode(response.body);
    } else {
      try {
        final errorBody = json.decode(response.body);
        final errorMessage = errorBody['message'] ?? 'Failed to load data';
        throw Exception(errorMessage);
      } catch (e) {
        final errorMessage =
            'HTTP ${response.statusCode}: ${response.reasonPhrase}';
        throw Exception(errorMessage);
      }
    }
  }

  // Google Sign-In methods
  Future<Map<String, dynamic>> googleSignIn(
    String firebaseUid,
    String email,
    String name,
    String role,
    String? photoURL,
  ) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/google-signin'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'firebaseUid': firebaseUid,
        'email': email,
        'name': name,
        'role': role,
        'photoURL': photoURL,
      }),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> googleSignUp(
    String firebaseUid,
    String email,
    String name,
    String role,
    String? photoURL,
  ) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/google-signup'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'firebaseUid': firebaseUid,
        'email': email,
        'name': name,
        'role': role,
        'photoURL': photoURL,
      }),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> syncFirebaseUser(
    String firebaseUid,
    String email,
    String name,
    String role,
    String? photoURL,
  ) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/sync-firebase-user'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'firebaseUid': firebaseUid,
        'email': email,
        'name': name,
        'role': role,
        'photoURL': photoURL,
      }),
    );
    return _handleResponse(response);
  }
}
