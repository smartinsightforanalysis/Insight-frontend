import 'package:google_sign_in/google_sign_in.dart';

class SimpleGoogleAuth {
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  static Future<GoogleSignInAccount?> signIn() async {
    try {
      print('Starting simple Google Sign-In...');
      
      // Sign out first to ensure clean state
      await _googleSignIn.signOut();
      
      // Sign in
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      
      if (account != null) {
        print('Google Sign-In successful: ${account.email}');
        return account;
      } else {
        print('Google Sign-In was cancelled');
        return null;
      }
    } catch (error) {
      print('Google Sign-In error: $error');
      rethrow;
    }
  }

  static Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      print('Google Sign-Out successful');
    } catch (error) {
      print('Google Sign-Out error: $error');
    }
  }
}