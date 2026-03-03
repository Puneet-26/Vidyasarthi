import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  
  bool _isLoading = false;
  bool _isLogin = true; 
  String _selectedRole = 'Student';
  final List<String> _roles = ['Student', 'Parent', 'Teacher', 'Admin'];

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      if (_isLogin) {
        // Login
        await _authService.signIn(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );
        // Navigation is handled by Auth State or we can manually check role here
        if (!mounted) return;
        
        // Fetch role to navigate
        final user = _authService.currentUser;
        if (user != null) {
            String? role = await _authService.getUserRole(user.uid);
            if (!mounted) return;
            if (role != null) {
                _navigateBasedOnRole(role);
            } else {
                 ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Error: User role not found.')),
                 );
            }
        }

      } else {
        // Register (For testing purposes so user can create accounts)
        await _authService.registerUser(
          _emailController.text.trim(),
          _passwordController.text.trim(),
          'New User',
          _selectedRole,
        );
         if (!mounted) return;
         _navigateBasedOnRole(_selectedRole);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.lock_person, size: 80, color: Colors.deepPurple),
                const SizedBox(height: 20),
                Text(
                  _isLogin ? 'Welcome Back' : 'Create Account',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 40),
                
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email)),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => value!.isEmpty ? 'Please enter email' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Password', prefixIcon: Icon(Icons.lock)),
                  obscureText: true,
                  validator: (value) => value!.length < 6 ? 'Password too short' : null,
                ),
                const SizedBox(height: 16),
                
                if (!_isLogin) 
                   DropdownButtonFormField<String>(
                    value: _selectedRole,
                    decoration: const InputDecoration(labelText: 'Role', prefixIcon: Icon(Icons.person)),
                    items: _roles.map((role) => DropdownMenuItem(value: role, child: Text(role))).toList(),
                    onChanged: (val) => setState(() => _selectedRole = val!),
                   ),
                   
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  child: _isLoading 
                    ? const CircularProgressIndicator() 
                    : Text(_isLogin ? 'LOGIN' : 'REGISTER'),
                ),
                TextButton(
                  onPressed: () => setState(() => _isLogin = !_isLogin),
                  child: Text(_isLogin ? 'Create new account' : 'I already have an account'),
                ),
                const SizedBox(height: 24),
                const Text('Demo Credentials:', style: TextStyle(fontWeight: FontWeight.bold)),
                const Text('Student: student@test.com'),
                const Text('Parent: parent@test.com'),
                const Text('Teacher: teacher@test.com'),
                const Text('Admin: admin@test.com'),
                const Text('Password: any'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
