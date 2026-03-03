// lib/services/firestore_service.dart
// MOCK IMPLEMENTATION
// Note: Kept the name 'FirestoreService' to avoid breaking imports in UI files.
// Ideally, rename to 'DataService' and use an abstraction.

import 'dart:async';

// Mock Classes to replace Firestore types
class Timestamp {
  final DateTime date;
  Timestamp(this.date);
  DateTime toDate() => date;
}

class DocumentSnapshot {
  final String id;
  final Map<String, dynamic> _data;
  DocumentSnapshot(this.id, this._data);
  Map<String, dynamic> data() => _data;
  dynamic operator [](String key) => _data[key];
  bool get exists => true;
}

class QuerySnapshot {
  final List<DocumentSnapshot> docs;
  QuerySnapshot(this.docs);
}

class FirestoreService {
  // In-memory data store
  static final List<Map<String, dynamic>> _courses = [
    {'courseName': 'Mathematics 101', 'teacherId': 'teacher@test.com', 'createdAt': Timestamp(DateTime.now())},
    {'courseName': 'Physics Advanced', 'teacherId': 'teacher@test.com', 'createdAt': Timestamp(DateTime.now())},
  ];

  static final List<Map<String, dynamic>> _notices = [
    {
      'title': 'Welcome to Vidyasarathi',
      'description': 'Classes start next week!',
      'createdBy': 'admin@test.com',
      'timestamp': Timestamp(DateTime.now())
    }
  ];

  static final List<Map<String, dynamic>> _students = [
    {'name': 'Rahul Kumar', 'email': 'student@test.com', 'role': 'Student'},
    {'name': 'Priya Singh', 'email': 'priya@test.com', 'role': 'Student'},
  ];

  static final List<Map<String, dynamic>> _attendance = [];

  // --- COURSES ---
  Stream<QuerySnapshot> getCourses() {
    // Return a stream that emits our list once
    return Stream.value(
       QuerySnapshot(_courses.map((e) => DocumentSnapshot(e['courseName'], e)).toList())
    );
  }

  Future<void> addCourse(String name, String teacherId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _courses.add({
      'courseName': name,
      'teacherId': teacherId,
      'createdAt': Timestamp(DateTime.now()),
    });
  }

  // --- NOTICES ---
  Stream<QuerySnapshot> getNotices() {
    return Stream.value(
       QuerySnapshot(_notices.map((e) => DocumentSnapshot(e['title'], e)).toList())
    );
  }

  Future<void> addNotice(String title, String description, String createdBy) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _notices.add({
      'title': title,
      'description': description,
      'createdBy': createdBy,
      'timestamp': Timestamp(DateTime.now()),
    });
  }

  // --- ATTENDANCE ---
  Future<void> markAttendance(String studentId, String status, String date) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _attendance.add({
      'studentId': studentId,
      'status': status,
      'date': date,
      'timestamp': Timestamp(DateTime.now()),
    });
  }

  Stream<QuerySnapshot> getStudentAttendance(String studentId) {
    print('Getting attendance for $studentId');
    final relevant = _attendance.where((e) => e['studentId'] == studentId).toList();
    return Stream.value(
      QuerySnapshot(relevant.map((e) => DocumentSnapshot('static_id', e)).toList())
    );
  }

  // --- USERS ---
  Stream<QuerySnapshot> getStudents() {
     // Return mock students
     return Stream.value(
       QuerySnapshot(_students.map((e) => DocumentSnapshot(e['email'], e)).toList())
     );
  }
}
