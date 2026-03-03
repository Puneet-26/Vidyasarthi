import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final AuthService _auth = AuthService();
  final FirestoreService _firestore = FirestoreService();
  final TextEditingController _courseNameController = TextEditingController();

  Future<void> _addCourse() async {
    if (_courseNameController.text.isEmpty) return;
    
    await _firestore.addCourse(
      _courseNameController.text,
      'Unassigned', // Teacher assignment logic omitted for brewity
    );
    
    _courseNameController.clear();
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Course Added')));
  }

  void _showAddCourseDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Course'),
        content: TextField(controller: _courseNameController, decoration: const InputDecoration(labelText: 'Course Name')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(onPressed: _addCourse, child: const Text('Add')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
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
      body: Column(
        children: [
           const Padding(
             padding: EdgeInsets.all(16.0),
             child: Text('Active Courses', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
           ),
           Expanded(
             child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.getCourses(),
              builder: (context, snapshot) {
                if (snapshot.hasError) return const Center(child: Text('Error'));
                if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
                
                final courses = snapshot.data!.docs;
                if (courses.isEmpty) return const Center(child: Text('No courses added yet'));

                return ListView.builder(
                  itemCount: courses.length,
                  itemBuilder: (context, index) {
                    var data = courses[index].data() as Map<String, dynamic>;
                    return Card(
                      child: ListTile(
                        leading: const Icon(Icons.book, color: Colors.blue),
                        title: Text(data['courseName'] ?? ''),
                        subtitle: Text('Teacher: ${data['teacherId']}'),
                      ),
                    );
                  },
                );
              },
                     ),
           ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddCourseDialog,
        child: const Icon(Icons.add),
        tooltip: 'Add Course',
      ),
    );
  }
}
