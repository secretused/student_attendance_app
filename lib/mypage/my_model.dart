import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyModel extends ChangeNotifier {
  bool isLoading = false;
  String? email;
  String? name;
  String? grade;
  String? department;
  String? classroom;

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
    this.email = user?.email;

    final uid = FirebaseAuth.instance.currentUser!.uid;
    final snapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final data = snapshot.data();
    this.name = data?["name"];
    this.grade = data?["grade"];
    this.department = data?["department"];
    this.classroom = data?["class"];

    notifyListeners();
  }

  Future logOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
