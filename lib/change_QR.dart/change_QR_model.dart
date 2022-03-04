import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class QRChangeModel extends ChangeNotifier {
  bool isLoading = false;
  String? communityName;

  String? department;
  String? email;
  String? phoneNumber;
  String? link;
  String? QRLink;

  QRChangeModel(String? gotCommunity) {
    this.communityName = gotCommunity;
  }

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  void fechInstitute() async {
    List<DocumentSnapshot> documentList = [];
    final user = FirebaseAuth.instance.currentUser;

    final snapshot = await FirebaseFirestore.instance
        .collection('community')
        .where("community", isEqualTo: communityName)
        .get();
    documentList = snapshot.docs;

    documentList.map((data) {
      this.department = data["department"];
      this.email = data["email"];
      this.phoneNumber = data["phoneNumber"].toString();
      this.link = data["link"];
      this.QRLink = data["QRLink"];
    }).toList();

    notifyListeners();
  }

  Future logOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
