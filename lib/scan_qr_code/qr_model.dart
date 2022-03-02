import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class QRModel extends ChangeNotifier {
  String? uid;
  String? name;

  String? createdAt = DateFormat('yyyy年MM月dd日').format(DateTime.now());
  String? time = DateFormat('hh:mm').format(DateTime.now());

  bool isLoading = false;

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

  Future signUp() async {
    var user = FirebaseAuth.instance.currentUser;
    String? collectionName = createdAt! + name!;

    if (user != null) {
      final doc = FirebaseFirestore.instance
          .collection("attendances")
          .doc(collectionName);
      await doc.set({
        'uid': uid,
        'createdAt': createdAt,
        'time': time,
        'name': name,
      });
    }
  }
}
