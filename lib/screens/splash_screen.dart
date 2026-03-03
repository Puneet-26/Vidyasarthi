import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    await Future.delayed(const Duration(seconds: 2)); // Artificial delay for logo
    User? user = _authService.currentUser;

    if (!mounted) return;

    if (user != null) {
      // User is logged in, check role
      String? role = await _authService.getUserRole(user.uid);
      if (!mounted) return;
      
      if (role != null) {
        _navigateBasedOnRole(role);
      } else {
        // Fallback if role is missing
        Navigator.pushReplacementNamed(context, '/login');
      }
    } else {
      // Not logged in
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  void _navigateBasedOnRole(String role) {
    switch (role) {
      case 'Student':
        Navigator.pushReplacementNamed(context, '/student_dashboard');
        break;
      case 'Parent':
        Navigator.pushReplacementNamed(context, '/parent_dashboard');
        break;
      case 'Teacher':
        Navigator.pushReplacementNamed(context, '/teacher_dashboard');
        break;
      case 'Admin':
        Navigator.pushReplacementNamed(context, '/admin_dashboard');
        break;
      default:
        Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.school,
              size: 100,
              color: Colors.white,
            ),
            const SizedBox(height: 20),
            const Text(
              'Vidyasarathi',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Coaching App',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 40),
            const CircularProgressIndicator(
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
