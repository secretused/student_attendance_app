import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StudentModel extends ChangeNotifier {
  String name, email, department, classroom, grade;
  StudentModel(
    this.name,
    this.email,
    this.grade,
    this.department,
    this.classroom,
  );
}

class StudentListModel extends ChangeNotifier {
  List<StudentModel> students = [];
  // FireStoreデータ取得
  Future getStudents() async {
    final collection =
        await FirebaseFirestore.instance.collection('users').get();
    final students = collection.docs
        .map((doc) => StudentModel(
              doc["name"],
              doc['email'],
              doc['grade'],
              doc['department'],
              doc['classroom'],
            ))
        .toList();
    this.students = students;
    notifyListeners();
  }
}
