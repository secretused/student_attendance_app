import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final editUserModelProvider =
Provider((ref) => EditUserModel());

class EditUserModel {
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
  bool? nowIsHost;

  void startLoading() {
    isLoading = true;
  }

  void endLoading() {
    isLoading = false;
  }

  Future getUser(String? uid) async {
    // ユーザ情報取得
    final snapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final data = snapshot.data();

    this.uid = data?["uid"];
    name = data?["name"];
    email = data?["email"];
    community = data?["community"];
    grade = data?["grade"];
    department = data?["department"];
    classroom = data?["classroom"];
    isHost = data?["isHost"];
    phoneNumber = data?["phoneNumber"];
  }
}
