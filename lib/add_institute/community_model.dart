import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CommunityModel extends ChangeNotifier {
  final communityController = TextEditingController();
  final departmentController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final linkController = TextEditingController();
  final QRLinkController = TextEditingController();

  String? communityName;
  String? department;
  String? email;
  String? phoneNumber;
  String? link;
  String? QRLink;

  bool isLoading = false;

  CommunityModel(String? community) {
    this.communityName = community;
  }

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  void setDepartment(String department) {
    this.department = department;
    notifyListeners();
  }

  void setEmail(String email) {
    this.email = email;
    notifyListeners();
  }

  void setPhoneNumber(String phoneNumber) {
    this.phoneNumber = phoneNumber;
    notifyListeners();
  }

  void setLink(String link) {
    this.link = link;
    notifyListeners();
  }

  void setQRLink(String QRlink) {
    this.QRLink = QRlink;
    notifyListeners();
  }

  Future addCommunity() async {
    this.department = departmentController.text;
    this.email = emailController.text;
    this.phoneNumber = phoneNumberController.text;
    this.link = linkController.text;
    this.QRLink = QRLinkController.text;

    // IDとかがuserに入る
    var user = FirebaseAuth.instance.currentUser!;

    if (user != null && communityName != null && QRLink != null) {
      final uid = user.uid;
      user = FirebaseAuth.instance.currentUser!;

      // firestoreに追加
      final doc =
          FirebaseFirestore.instance.collection("community").doc(communityName);
      await doc.set({
        'uid': uid,
        'community': communityName,
        'department': department,
        'email': email,
        'phoneNumber': int.parse(phoneNumber!),
        'link': link,
        'QRLink': QRLink,
      });
    }
  }
}
