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
  bool? isHost;
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

  void setHost(bool isHost) {
    this.isHost = isHost;
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

    // Authの名前変更
    final instance = FirebaseAuth.instance;
    final User? user = instance.currentUser;
    await user!.updateDisplayName(name);

    if (name != "") {
      // firestoreに追加
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'name': name,
        'department': department,
        'grade': grade,
        'classroom': classroom,
        'phoneNumber': phoneNumber,
        'isHost': isHost,
      });
    } else {
      // 名前が空欄
      nameNull = true;
    }
  }

  // user削除処理
  void deleteUser(String? uid, String? community) async {
    // usersのドキュメントを削除
    FirebaseFirestore.instance.collection('users').doc(uid).delete();
    // FireBaseのAuthを削除
    FirebaseAuth.instance.currentUser?.delete();
    // attendancesのドキュメントを削除
    return FirebaseFirestore.instance
        .collection('attendances')
        .where("uid", isEqualTo: uid)
        .where("community", isEqualTo: community)
        .get()
        .then(
          // 取得したdocIDを使ってドキュメント削除
          (QuerySnapshot snapshot) => {
            snapshot.docs.forEach((f) {
              FirebaseFirestore.instance
                  .collection('attendances')
                  .doc(f.reference.id)
                  .delete();
            }),
          },
        );
  }

  Future changeHost() async {
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'isHost': isHost,
    });
  }
}
