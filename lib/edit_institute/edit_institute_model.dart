import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../setting.dart';

class EditInstituteModel extends ChangeNotifier {
  String? communityName;
  String? nowCommunityName;
  String? department;
  String? email;
  String? phoneNumber;
  String? link;
  String? QRLink;

  bool isLoading = false;

  late bool? sameName = false;

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
    this.nowCommunityName = communityName;
    communityController.text = communityName!;
    departmentController.text = department!;
    emailController.text = email!;
    phoneNumberController.text = phoneNumber!;
    linkController.text = link!;
    QRLinkController.text = QRLink!;
  }

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
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

  bool isUpdated() {
    return (communityName != null &&
        department != null &&
        email != null &&
        phoneNumber != null &&
        link != null &&
        QRLink != null);
  }

  Future update() async {
    this.communityName = communityController.text;
    this.department = departmentController.text;
    this.email = emailController.text;
    this.phoneNumber = phoneNumberController.text;
    this.link = linkController.text;
    this.QRLink = QRLinkController.text;

    late String? sameCommunity = null;
    // 団体名を変更しようとしているとき
    FirebaseFirestore.instance
        .collection('community')
        .doc(communityName)
        .snapshots()
        .listen((DocumentSnapshot snapshot) {
      sameCommunity = snapshot.get('community');
    });
    // ↑この処理を終わらせている
    await Future.delayed(Duration(seconds: 1));
    if (communityName != nowCommunityName) {
      if (sameCommunity.runtimeType == String) {
        // 同じ団体あり
        sameName = true;
      } else {
        // 同じ団体なし
        changeInstitute();
        sameName = false;
      }
    } else {
      // 団体名以外変更
      if (QRLink!.isEmpty) {
        sameName = false;
      } else {
        await FirebaseFirestore.instance
            .collection('community')
            .doc(nowCommunityName)
            .update({
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

  // nowCommunityNameを持つ他の既存コレクションを変更する
  // usersコレクション変更
  Future changeInstitute() async {
    final current_user = FirebaseAuth.instance.currentUser;
    final uid = current_user?.uid;
    await FirebaseFirestore.instance
        .collection('users')
        .where("community", isEqualTo: nowCommunityName)
        .get()
        .then((val) => val.docs.forEach((doc) => {
              doc.reference.update({
                'community': communityName,
              })
            }));
    // attendancesコレクション変更
    await FirebaseFirestore.instance
        .collection('attendances')
        .where("community", isEqualTo: nowCommunityName)
        .get()
        .then((val) => val.docs.forEach((doc) => {
              doc.reference.update({
                'community': communityName,
              })
            }));
    // communityドキュメントを削除
    FirebaseFirestore.instance
        .collection('community')
        .doc(nowCommunityName)
        .delete();
    // 新たにドキュメントを作り直す
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
