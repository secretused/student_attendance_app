import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditProfileModel extends ChangeNotifier {
  EditProfileModel(this.name) {
    nameController.text = name!;
  }

  final nameController = TextEditingController();

  String? name;

  void setTitle(String name) {
    this.name = name;
    notifyListeners();
  }

  bool isUpdated() {
    return name != null;
  }

  Future update() async {
    this.name = nameController.text;

    // firestoreに追加
    final uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'name': name,
    });
  }
}
