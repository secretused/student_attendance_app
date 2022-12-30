import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final registerModelProvider =
    Provider((ref) => RegisterModel());

final addUserModelProvider =
    Provider((ref) => AddUserModel());

class RegisterModel {
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
  }

  void endLoading() {
    isLoading = false;
  }

  void setEmail(String email) {
    this.email = email;
  }

  void setPassword(String password) {
    this.password = password;
  }

  void setPhoneNumber(String phoneNum) {
    phoneNumber = phoneNum;
  }

  void setName(String name) {
    this.name = name;
  }

  void setCommunity(String community) {
    communityName = community;
  }

  void setGrade(String grade) {
    this.grade = grade;
  }

  void setClass(String classroom) {
    this.classroom = classroom;
  }

  void setDepartment(String department) {
    this.department = department;
  }

  void setHost(bool isHost) {
    this.isHost = isHost;
  }

  Future signUp() async {
    email = emailController.text;
    password = authorController.text;
    phoneNumber = phoneNumController.text;
    name = nameController.text;
    grade = gradeController.text;
    classroom = classController.text;
    department = departmentController.text;

    if (email != null && password != null) {
      // firebaseauthでユーザー作成
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

      late String? current_uid = user?.uid;
      if (email != null && current_uid != null) {
        // ログイン
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email!, password: password!);
      }
    }
  }
}

// UserListの追加ボタンからの処理
class AddUserModel {
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

  setCommunityName(String? gotCommunityName) {
    communityName = gotCommunityName;
  }

  void startLoading() {
    isLoading = true;
  }

  void endLoading() {
    isLoading = false;
  }

  void setEmail(String email) {
    this.email = email;
  }

  void setPassword(String password) {
    this.password = password;
  }

  void setPhoneNumber(String phoneNum) {
    phoneNumber = phoneNum;
  }

  void setName(String name) {
    this.name = name;
  }

  void setCommunity(String community) {
    communityName = community;
  }

  void setGrade(String grade) {
    this.grade = grade;
  }

  void setClass(String classroom) {
    this.classroom = classroom;
  }

  void setDepartment(String department) {
    this.department = department;
  }

  void setHost(bool isHost) {
    this.isHost = isHost;
  }

  // add_Student
  Future addUser() async {
    email = emailController.text;
    password = authorController.text;
    phoneNumber = phoneNumController.text;
    name = nameController.text;
    grade = gradeController.text;
    classroom = classController.text;
    department = departmentController.text;

    if (email != null && password != null) {
      FirebaseApp app = await Firebase.initializeApp(
          name: 'secondary', options: Firebase.app().options);
      UserCredential userCredential = await FirebaseAuth.instanceFor(app: app)
          .createUserWithEmailAndPassword(email: email!, password: password!);

      app.delete();

      // IDとかがuserに入る
      if (userCredential != null && name != null && communityName != null) {
        // firestoreに追加
        final id = userCredential.user?.uid;
        final doc = FirebaseFirestore.instance.collection("users").doc(id);
        await doc.set({
          'uid': id,
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
