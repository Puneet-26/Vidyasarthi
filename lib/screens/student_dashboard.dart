import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  final AuthService _auth = AuthService();
  final FirestoreService _firestore = FirestoreService();
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _auth.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          )
        ],
      ),
      body: _selectedIndex == 0 ? _buildCourses() : _buildNotices(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Courses'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notices'),
        ],
      ),
    );
  }

  Widget _buildCourses() {
    // In a real app, filter courses by enrollment. 
    // Here we show all courses for demo.
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.getCourses(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return const Center(child: Text('Error loading courses'));
        if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());

        final courses = snapshot.data!.docs;
        if (courses.isEmpty) return const Center(child: Text('No courses found'));

        return ListView.builder(
          itemCount: courses.length,
          itemBuilder: (context, index) {
            var data = courses[index].data() as Map<String, dynamic>;
            return Card(
              margin: const EdgeInsets.all(8),
              child: ListTile(
                leading: const Icon(Icons.class_, color: Colors.deepPurple),
                title: Text(data['courseName'] ?? 'Unnamed Course'),
                subtitle: Text('Teacher ID: ${data['teacherId']}'),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildNotices() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.getNotices(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return const Center(child: Text('Error loading notices'));
        if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());

        final notices = snapshot.data!.docs;
        if (notices.isEmpty) return const Center(child: Text('No notices'));

        return ListView.builder(
          itemCount: notices.length,
          itemBuilder: (context, index) {
            var data = notices[index].data() as Map<String, dynamic>;
            return Card(
              margin: const EdgeInsets.all(8),
              child: ListTile(
                title: Text(data['title'] ?? 'Notice'),
                subtitle: Text(data['description'] ?? ''),
                trailing: Text(
                  data['timestamp'] != null 
                    ? (data['timestamp'] as Timestamp).toDate().toString().split(' ')[0]
                    : '',
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
