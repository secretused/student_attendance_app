import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditInstituteModel extends ChangeNotifier {
  String? communityName;
  String? department;
  String? email;
  String? phoneNumber;
  String? link;
  String? QRLink;

  final communityController = TextEditingController();
  final departmentController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final linkController = TextEditingController();
  final QRLinkController = TextEditingController();

  EditInstituteModel(
    this.communityName,
    this.department,
    this.email,
    this.phoneNumber,
    this.link,
    this.QRLink,
  ) {
    communityController.text = communityName!;
    departmentController.text = department!;
    emailController.text = email!;
    phoneNumberController.text = phoneNumber!;
    linkController.text = link!;
    QRLinkController.text = QRLink!;
  }

  void setCommunity(String community) {
    this.communityName = community;
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

  // bool isUpdated() {
  //   return name != null;
  // }

  // Future update() async {
  //   this.name = nameController.text;

  //   // firestoreに追加
  //   final uid = FirebaseAuth.instance.currentUser!.uid;
  //   await FirebaseFirestore.instance.collection('users').doc(uid).update({
  //     'name': name,
  //   });
  // }
}
