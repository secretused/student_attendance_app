import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DetailUser extends ChangeNotifier {
  bool isLoading = false;
  bool isCommunity = false;

  String? uid;
  String? email;
  String? phoneNumber;
  String? name;
  String? community;
  String? grade;
  String? department;
  String? classroom;
  bool? isHost;

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future getUser(String? uid) async {
    // ユーザ情報取得
    final snapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final data = snapshot.data();

    this.uid = data?["uid"];
    this.name = data?["name"];
    this.email = data?["email"];
    this.community = data?["community"];
    this.grade = data?["grade"];
    this.department = data?["department"];
    this.classroom = data?["classroom"];
    this.isHost = data?["isHost"];
    this.phoneNumber = data?["phoneNumber"];

    notifyListeners();
  }
}
