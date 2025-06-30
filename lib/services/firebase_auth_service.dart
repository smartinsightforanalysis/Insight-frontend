import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService {
  static final FirebaseAuthService _instance = FirebaseAuthService._internal();
  factory FirebaseAuthService() => _instance;
  FirebaseAuthService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Google Sign In
  Future<UserCredential?> signInWithGoogle() async {
    try {
      print('Starting Firebase Google Sign-In process...');
      
      // Use the simple Google Sign-In first
      print('Step 1: Simple Google Sign-In...');
      await _googleSignIn.signOut(); // Clean state
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        print('User canceled Google Sign-In');
        return null;
      }

      print('Step 2: Google Sign-In successful: ${googleUser.email}');
      print('Step 3: Getting authentication details...');
      
      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
      if (googleAuth.accessToken == null || googleAuth.idToken == null) {
        throw Exception('Failed to get Google authentication tokens');
      }

      print('Step 4: Creating Firebase credential...');
      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      print('Step 5: Signing in to Firebase...');
      // Sign in to Firebase with the Google credential
      final userCredential = await _auth.signInWithCredential(credential);
      print('Step 6: Firebase sign-in successful!');
      
      return userCredential;
    } catch (e) {
      print('Error in Firebase Google Sign-In: $e');
      print('Error type: ${e.runtimeType}');
      
      // Sign out from Google on any error
      try {
        await _googleSignIn.signOut();
      } catch (signOutError) {
        print('Error signing out from Google: $signOutError');
      }
      
      if (e.toString().contains('Connection reset') || e.toString().contains('network')) {
        throw Exception('Network connection error. Please check your internet connection and try again.');
      } else if (e.toString().contains('API key') || e.toString().contains('invalid')) {
        throw Exception('Firebase configuration error. Please check your Firebase setup.');
      }
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
    } catch (e) {
      print('Error signing out: $e');
      rethrow;
    }
  }

  // Delete current user (for rollback scenarios)
  Future<void> deleteCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await user.delete();
      }
      await _googleSignIn.signOut();
    } catch (e) {
      print('Error deleting user: $e');
      rethrow;
    }
  }

  // Check if user is signed in
  bool get isSignedIn => _auth.currentUser != null;

  // Get user data
  Map<String, dynamic>? getUserData() {
    final user = _auth.currentUser;
    if (user == null) return null;

    return {
      'uid': user.uid,
      'email': user.email,
      'displayName': user.displayName,
      'photoURL': user.photoURL,
    };
  }
}