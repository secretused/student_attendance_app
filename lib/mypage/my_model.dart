import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyModel extends ChangeNotifier {
  bool isLoading = false;
  bool isCommunity = false;

  String? uid;
  String? email;
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

  Future fechUser() async {
    final user = FirebaseAuth.instance.currentUser;
    this.uid = user?.uid;
    this.email = user?.email;

    // ユーザ情報取得
    final snapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final data = snapshot.data();

    this.name = data?["name"];
    this.community = data?["community"];
    this.grade = data?["grade"];
    this.department = data?["department"];
    this.classroom = data?["classroom"];
    this.isHost = data?["isHost"];

    notifyListeners();
    final getInstitue = await FirebaseFirestore.instance
        .collection('community')
        .doc(community)
        .get();
    final community_data = getInstitue.data();
    if (community_data?["community"].runtimeType != null) {
      this.isCommunity = true;
    } else {
      this.isCommunity = false;
    }
  }

  // 再度描写
  Future checkCommunity() async {
    //団体の有無確認
    final getInstitue = await FirebaseFirestore.instance
        .collection('community')
        .doc(community)
        .get();
    final community_data = getInstitue.data();
    if (community_data?["community"].runtimeType != null) {
      this.isCommunity = true;
    } else {
      this.isCommunity = false;
    }
  }

  Future logOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
