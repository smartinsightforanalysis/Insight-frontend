import 'package:flutter/material.dart';
import 'dart:async';
import 'onboarding_screen.dart';
import '../services/user_session.dart';
import 'admin_dashboard.dart';

class SplashScreen extends StatefulWidget {
  final Widget? nextScreen;

  const SplashScreen({super.key, this.nextScreen});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Wait for minimum splash duration
    await Future.delayed(const Duration(seconds: 2));
    
    try {
      // Try to load existing user session
      final userSession = UserSession.instance;
      final isLoggedIn = await userSession.loadUserSession();
      
      print('Splash - Session loaded: $isLoggedIn');
      print('Splash - User role: ${userSession.userRole}');
      print('Splash - User data: ${userSession.currentUser}');
      
      if (mounted) {
        if (isLoggedIn && userSession.userRole != null) {
          // User is logged in, navigate to dashboard
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => AdminDashboard(userRole: userSession.userRole!),
            ),
          );
        } else {
          // User not logged in, navigate to onboarding
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const OnboardingScreen()),
          );
        }
      }
    } catch (e) {
      print('Error initializing app: $e');
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const OnboardingScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // White background
      body: Container(
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white, // White background
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            // Main content area
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo
                    Image.asset(
                      'assets/splashscreen.png',
                      width: 250,
                      height: 250,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              ),
            ),
            // Bottom subtitle
            Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: Column(
                children: [
                  const Text(
                    'AI-powered performance',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF4B5563), // Gray color for subtitle
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const Text(
                    'management system',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF4B5563), // Gray color for subtitle
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
