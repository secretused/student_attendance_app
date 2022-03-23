import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class QRModel extends ChangeNotifier {
  String? uid;
  String? name;
  String? community;

  // 絞り込み用
  String? department;
  String? grade;
  String? classroom;
  bool? isHost;

  String? createdAt = DateFormat('yyyy年MM月dd日').format(DateTime.now());
  String? time = DateFormat('HH:mm').format(DateTime.now());

  bool isLoading = false;
  var user = FirebaseAuth.instance.currentUser;

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  void setUid(String uid) {
    this.uid = uid;
    notifyListeners();
  }

  void setName(String name) {
    this.name = name;
    notifyListeners();
  }

  // 絞り込み用
  void setDepartment(String department) {
    this.department = department;
    notifyListeners();
  }

  void setGrade(String grade) {
    this.grade = grade;
    notifyListeners();
  }

  void setClassRoom(String classroom) {
    this.classroom = classroom;
    notifyListeners();
  }

  void setCommunity(String community) {
    this.community = community;
    notifyListeners();
  }

  void setisHost(bool isHost) {
    this.isHost = isHost;
    notifyListeners();
  }

  Future atendding() async {
    String? collectionName = createdAt! + name!;

    if (user != null) {
      final doc = FirebaseFirestore.instance
          .collection("attendances")
          .doc(collectionName);
      await doc.set({
        'uid': uid,
        'createdAt': createdAt,
        'community': community,
        'time': time,
        'name': name,
        // 絞り込み用
        'department': department,
        'grade': grade,
        'classroom': classroom,
        'isHost': isHost,
      });
    }
  }
}
