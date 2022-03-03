import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyModel extends ChangeNotifier {
  bool isLoading = false;
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

  void fechUser() async {
    final user = FirebaseAuth.instance.currentUser;
    this.uid = user?.uid;
    this.email = user?.email;

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
  }

  Future logOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
