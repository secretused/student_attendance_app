import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

final qrModelProvider =
Provider((ref) => QRModel());

class QRModel {
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
  }

  void endLoading() {
    isLoading = false;
  }

  void setUid(String uid) {
    this.uid = uid;
  }

  void setName(String name) {
    this.name = name;
  }

  // 絞り込み用
  void setDepartment(String department) {
    this.department = department;
  }

  void setGrade(String grade) {
    this.grade = grade;
  }

  void setClassRoom(String classroom) {
    this.classroom = classroom;
  }

  void setCommunity(String community) {
    this.community = community;
  }

  void setIsHost(bool isHost) {
    this.isHost = isHost;
  }

  Future attend() async {
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
        'email': user?.email,
        // 絞り込み用
        'department': department,
        'grade': grade,
        'classroom': classroom,
        'isHost': isHost,
      });
    }
  }
}
