import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final communityModelProvider =
    Provider(
  (ref) => CommunityModel());

class CommunityModel {

// CommunityModel(String? community){
//     communityName = community;
//   }

  final communityController = TextEditingController();
  final departmentController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final linkController = TextEditingController();
  final qrLinkController = TextEditingController();

  String? communityName;
  String? department;
  String? email;
  String? phoneNumber = "0000000000";
  String? link;
  String? qrLink;

  String? gotData;
  bool sameName = true;
  bool isLoading = false;
  bool error = false;

  

  void startLoading() {
    isLoading = true;
  }

  void endLoading() {
    isLoading = false;
  }

  void setDepartment(String department) {
    department = department;
  }

  void setEmail(String email) {
    email = email;
  }

  void setPhoneNumber(String phoneNumber) {
    phoneNumber = phoneNumber;
  }

  void setLink(String link) {
    link = link;
  }

  void setQRLink(String qrLink) {
    qrLink = qrLink;
  }

  Future addCommunity() async {
    department = departmentController.text;
    email = emailController.text;
    phoneNumber = phoneNumberController.text;
    link = linkController.text;
    qrLink = qrLinkController.text;

    // IDとかがuserに入る
    var user = FirebaseAuth.instance.currentUser!;

    final snapshot = await FirebaseFirestore.instance
        .collection('community')
        .doc(communityName)
        .get();
    final data = snapshot.data();
    this.gotData = data?["community"];
    if (gotData != communityName) {
      this.sameName = true;
    } else {
      this.sameName = false;
    }

    if (user != null && sameName == true) {
      // 確認モーダル
      if (phoneNumber!.isEmpty) {
        phoneNumber = "0000000000";
      }
    } else {
      error = true;
    }
  }

  // firestoreに団体追加
  @override
  void addInstitute() async {
    var user = FirebaseAuth.instance.currentUser!;
    final uid = user.uid;
    final doc =
        FirebaseFirestore.instance.collection("community").doc(communityName);
    await doc.set({
      'uid': uid,
      'community': communityName,
      'department': department,
      'email': email,
      'phoneNumber': int.parse(phoneNumber!),
      'link': link,
      'QRLink': qrLink,
    });
  }
}
