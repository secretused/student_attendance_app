import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditProfileModel extends ChangeNotifier {
  EditProfileModel(
    String? uid,
    this.name,
    this.department,
    this.grade,
    this.classroom,
    this.phoneNumber,
  ) {
    // uidは不変
    this.uid = uid;
    nameController.text = name!;
    departmentController.text = department!;
    gradeController.text = grade!;
    classController.text = classroom!;
    phoneNumController.text = phoneNumber!;
  }

  String? uid;
  String? name;
  String? department;
  String? grade;
  String? classroom;
  String? phoneNumber;
  bool nameNull = false;

  final nameController = TextEditingController();
  final departmentController = TextEditingController();
  final gradeController = TextEditingController();
  final classController = TextEditingController();
  final phoneNumController = TextEditingController();

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

  bool isUpdated() {
    return (name != null &&
        department != null &&
        grade != null &&
        phoneNumber != null &&
        classroom != null);
  }

  Future update() async {
    this.name = nameController.text;
    this.department = departmentController.text;
    this.grade = gradeController.text;
    this.classroom = classController.text;
    this.phoneNumber = phoneNumController.text;

    if (name != "") {
      // firestoreに追加
      print(uid);
      // final uid = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'name': name,
        'department': department,
        'grade': grade,
        'classroom': classroom,
        'phoneNumber': phoneNumber,
      });
    } else {
      // 名前が空欄
      nameNull = true;
    }
  }

  void deleteUser(String? uid, String? community) async {
    // userのドキュメントを削除
    print(uid);
    print(community);
    // FirebaseFirestore.instance
    //     .collection('attendances')
    //     .where("community", isEqualTo: community)
    //     .where("uid", isEqualTo: uid);
    // 最後にFireBaseのAuthを削除
  }
}
