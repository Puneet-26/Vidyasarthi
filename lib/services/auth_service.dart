// lib/services/auth_service.dart
// MOCK IMPLEMENTATION
// To switch back to Firebase, uncomment the original code and remove this mock class.

import 'dart:async';

class User {
  final String uid;
  final String email;
  
  User({required this.uid, required this.email});
}

class AuthService {
  // Mock current user
  static User? _currentUser;
  
  User? get currentUser => _currentUser;

  // Stream of auth changes
  Stream<User?> get authStateChanges => Stream.periodic(const Duration(seconds: 1), (_) => _currentUser);

  // Sign in with email and password
  Future<void> signIn(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network
    
    // Accept any login for demo, just assign a fake UID based on email
    /* 
       Demo Credentials:
       - student@test.com
       - parent@test.com
       - teacher@test.com
       - admin@test.com
    */
    _currentUser = User(uid: email.hashCode.toString(), email: email);
  }

  // Sign out
  Future<void> signOut() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _currentUser = null;
  }

  // Get user role (Mock Logic based on email prefix)
  Future<String?> getUserRole(String uid) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (_currentUser == null) return null;
    final email = _currentUser!.email.toLowerCase();

    if (email.contains('admin')) return 'Admin';
    if (email.contains('parent')) return 'Parent';
    if (email.contains('teacher')) return 'Teacher';
    
    // Default to Student for any other email
    return 'Student';
  }

  // Register user (Mock)
  Future<void> registerUser(String email, String password, String name, String role) async {
    await Future.delayed(const Duration(seconds: 1));
    _currentUser = User(uid: email.hashCode.toString(), email: email);
    // In a real mock, we'd save this to a list, but for now we just log them in
  }
}
