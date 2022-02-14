import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterModel extends ChangeNotifier {
  final titleController = TextEditingController();
  final authorController = TextEditingController();
  final nameController = TextEditingController();
  final gradeController = TextEditingController();
  final classController = TextEditingController();
  final departmentController = TextEditingController();

  String? email;
  String? password;

  String? name;
  String? grade;
  String? classroom;
  String? department;

  bool isLoading = false;

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  void setEmail(String email) {
    this.email = email;
    notifyListeners();
  }

  void setPassword(String password) {
    this.password = password;
    notifyListeners();
  }

  void setName(String name) {
    this.name = name;
    notifyListeners();
  }

  void setGrade(String grade) {
    this.grade = grade;
    notifyListeners();
  }

  void setClass(String classroom) {
    this.classroom = classroom;
    notifyListeners();
  }

  void setDepartment(String department) {
    this.department = department;
    notifyListeners();
  }

  Future signUp() async {
    this.email = titleController.text;
    this.password = authorController.text;
    this.name = nameController.text;
    this.grade = gradeController.text;
    this.classroom = classController.text;
    this.department = departmentController.text;

    if (email != null && password != null) {
      // firebase authでユーザー作成
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email!, password: password!);
      // IDとかがuserに入る
      final user = userCredential.user;

      if (user != null) {
        final uid = user.uid;

        // firestoreに追加
        final doc = FirebaseFirestore.instance.collection('users').doc(uid);
        await doc.set({
          'uid': uid,
          'name': name,
          'email': email,
          'grade': grade,
          'class': classroom,
          'department': department,
        });
      }
    }
  }
}
