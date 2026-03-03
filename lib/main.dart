import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart'; // Commented out
// import 'firebase_options.dart'; // Commented out
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/student_dashboard.dart';
import 'screens/parent_dashboard.dart';
import 'screens/teacher_dashboard.dart';
import 'screens/admin_dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // MOCK MODE: Firebase initialization skipped.
  // Uncomment below when ready to integrate Firebase.
  /*
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print("Firebase initialization failed: $e");
  }
  */

  runApp(const VidyasarathiApp());
}

class VidyasarathiApp extends StatelessWidget {
  const VidyasarathiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vidyasarathi Coaching',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.grey.shade100,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
      home: const SplashScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/student_dashboard': (context) => const StudentDashboard(),
        '/parent_dashboard': (context) => const ParentDashboard(),
        '/teacher_dashboard': (context) => const TeacherDashboard(),
        '/admin_dashboard': (context) => const AdminDashboard(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
