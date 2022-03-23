import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterModel extends ChangeNotifier {
  final emailController = TextEditingController();
  final authorController = TextEditingController();
  final phoneNumController = TextEditingController();
  final nameController = TextEditingController();
  final communityController = TextEditingController();
  final gradeController = TextEditingController();
  final classController = TextEditingController();
  final departmentController = TextEditingController();

  String? email;
  String? password;
  String? phoneNumber;

  String? name;
  String? communityName;
  String? grade;
  String? classroom;
  String? department;

  bool? isHost;

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

  void setPhoneNumber(String phoneNum) {
    this.phoneNumber = phoneNum;
    notifyListeners();
  }

  void setName(String name) {
    this.name = name;
    notifyListeners();
  }

  void setCommunity(String community) {
    this.communityName = community;
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

  void setHost(bool isHost) {
    this.isHost = isHost;
    notifyListeners();
  }

  Future signUp() async {
    this.email = emailController.text;
    this.password = authorController.text;
    this.phoneNumber = phoneNumController.text;
    this.name = nameController.text;
    this.grade = gradeController.text;
    this.classroom = classController.text;
    this.department = departmentController.text;

    if (email != null && password != null) {
      // firebase authでユーザー作成
      final userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email!,
        password: password!,
      );

      // IDとかがuserに入る
      var user = userCredential.user;

      if (user != null && name != null && communityName != null) {
        final uid = user.uid;
        await user.updateDisplayName(name);
        await user.reload();
        user = FirebaseAuth.instance.currentUser!;

        // firestoreに追加
        final doc = FirebaseFirestore.instance.collection("users").doc(uid);
        await doc.set({
          'uid': uid,
          'name': name,
          'email': email,
          'phoneNumber': phoneNumber,
          'community': communityName,
          'grade': grade,
          'classroom': classroom,
          'department': department,
          'isHost': isHost,
        });
      }
    }
  }
}

class AddUserModel extends ChangeNotifier {
  final emailController = TextEditingController();
  final authorController = TextEditingController();
  final nameController = TextEditingController();
  final communityController = TextEditingController();
  final gradeController = TextEditingController();
  final classController = TextEditingController();
  final departmentController = TextEditingController();

  String? email;
  String? password;

  String? name;
  String? communityName;
  String? grade;
  String? classroom;
  String? department;

  bool? isHost;

  bool isLoading = false;

  AddUserModel(String? gotCommunityName) {
    this.communityName = gotCommunityName;
  }

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

  void setCommunity(String community) {
    this.communityName = community;
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

  void setHost(bool isHost) {
    this.isHost = isHost;
    notifyListeners();
  }

  Future signUp() async {
    this.email = emailController.text;
    this.password = authorController.text;
    this.name = nameController.text;
    this.grade = gradeController.text;
    this.classroom = classController.text;
    this.department = departmentController.text;

    if (email != null && password != null) {
      // firebase authでユーザー作成
      final userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email!,
        password: password!,
      );

      // IDとかがuserに入る
      var user = userCredential.user;

      if (user != null && name != null && communityName != null) {
        final uid = user.uid;
        await user.updateDisplayName(name);
        await user.reload();
        user = FirebaseAuth.instance.currentUser!;

        // firestoreに追加
        final doc = FirebaseFirestore.instance.collection("users").doc(uid);
        await doc.set({
          'uid': uid,
          'name': name,
          'email': email,
          'community': communityName,
          'grade': grade,
          'classroom': classroom,
          'department': department,
          'isHost': isHost,
        });
      }
    }
  }
}
