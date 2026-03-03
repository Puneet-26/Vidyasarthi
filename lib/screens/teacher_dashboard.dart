import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';

class TeacherDashboard extends StatefulWidget {
  const TeacherDashboard({super.key});

  @override
  State<TeacherDashboard> createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<TeacherDashboard> {
  final AuthService _auth = AuthService();
  final FirestoreService _firestore = FirestoreService();
  final TextEditingController _noticeTitleController = TextEditingController();
  final TextEditingController _noticeDescController = TextEditingController();

  Future<void> _addNotice() async {
    if (_noticeTitleController.text.isEmpty) return;
    
    await _firestore.addNotice(
      _noticeTitleController.text,
      _noticeDescController.text,
      _auth.currentUser?.email ?? 'Teacher',
    );
    
    _noticeTitleController.clear();
    _noticeDescController.clear();
    if(mounted) Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Notice Posted')));
  }

  void _showAddNoticeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Post Notice'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: _noticeTitleController, decoration: const InputDecoration(labelText: 'Title')),
            const SizedBox(height: 10),
            TextField(controller: _noticeDescController, decoration: const InputDecoration(labelText: 'Description')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(onPressed: _addNotice, child: const Text('Post')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teacher Dashboard'),
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
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.getStudents(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return const Center(child: Text('Error'));
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          
          final students = snapshot.data!.docs;
          if (students.isEmpty) return const Center(child: Text('No students found'));

          return ListView.builder(
            itemCount: students.length,
            itemBuilder: (context, index) {
              var data = students[index].data() as Map<String, dynamic>;
              String studentId = students[index].id;
              
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(data['name'] ?? 'Unknown'),
                  subtitle: Text(data['email'] ?? ''),
                  trailing: IconButton(
                    icon: const Icon(Icons.check_circle_outline, color: Colors.green),
                    onPressed: () {
                      _firestore.markAttendance(
                        studentId, 
                        'Present', 
                        DateTime.now().toIso8601String().split('T')[0]
                      );
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Marked Present: ${data['name']}')));
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddNoticeDialog,
        child: const Icon(Icons.add_alert),
      ),
    );
  }
}
