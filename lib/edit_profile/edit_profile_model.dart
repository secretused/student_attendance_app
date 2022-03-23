import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditProfileModel extends ChangeNotifier {
  EditProfileModel(
    this.name,
    this.department,
    this.grade,
    this.classroom,
    this.phoneNumber,
  ) {
    nameController.text = name!;
    departmentController.text = department!;
    gradeController.text = grade!;
    classController.text = classroom!;
    phoneNumController.text = phoneNumber!;
  }

  final nameController = TextEditingController();
  final departmentController = TextEditingController();
  final gradeController = TextEditingController();
  final classController = TextEditingController();
  final phoneNumController = TextEditingController();

  String? name;
  String? department;
  String? grade;
  String? classroom;
  String? phoneNumber;

  void setName(String name) {
    this.name = name;
    notifyListeners();
  }

  void setDepartment(String department) {
    this.department = department;
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

  void setPhoneNumber(String phoneNum) {
    this.phoneNumber = phoneNum;
    notifyListeners();
  }

  Future isUpdate() async {
    this.name = nameController.text;
    this.department = departmentController.text;
    this.grade = gradeController.text;
    this.classroom = classController.text;
    this.phoneNumber = phoneNumController.text;

    // 空欄が存在する場合はpageの方にvool値を返しエラーモーダル

    // firestoreに追加
    final uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'name': name,
      'department': department,
      'grade': grade,
      'classroom': classroom,
      'phoneNumber': phoneNumber,
    });
  }
}
