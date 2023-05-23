import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final editInstituteModelProvider =
Provider((ref) => EditInstituteModel());

class EditInstituteModel {
  String? communityName;
  String? nowCommunityName;
  String? department;
  String? email;
  String? phoneNumber;
  String? link;
  String? qrLink;

  bool isLoading = false;

  late bool? sameName = false;
  late bool? changeInstituteName = false;

  final communityController = TextEditingController();
  final departmentController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final linkController = TextEditingController();
  final qrLinkController = TextEditingController();

  editInstituteModel(
    communityName,
    department,
    email,
    phoneNumber,
    link,
    qrLink,
  ) {
    this.nowCommunityName = communityName;
    communityController.text = communityName!;
    departmentController.text = department!;
    emailController.text = email!;
    phoneNumberController.text = phoneNumber!;
    linkController.text = link!;
    qrLinkController.text = qrLink!;
  }

  void setCommunity(String community) {
    communityName = community;
  }

  void setDepartment(String department) {
    this.department = department;
  }

  void setEmail(String email) {
    this.email = email;
  }

  void setPhoneNumber(String phoneNumber) {
    this.phoneNumber = phoneNumber;
  }

  void setLink(String link) {
    this.link = link;
  }

  void setqrLink(String qrLink) {
    this.qrLink = qrLink;
  }

  bool isUpdated() {
    return (communityName != null &&
        department != null &&
        email != null &&
        phoneNumber != null &&
        link != null &&
        qrLink != null);
  }

  Future update() async {
    communityName = communityController.text;
    department = departmentController.text;
    email = emailController.text;
    phoneNumber = phoneNumberController.text;
    link = linkController.text;
    qrLink = qrLinkController.text;

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
        // 同じ団体あり 1-1
        sameName = true;
      } else {
        // 同じ団体なし 1-2
        // sameName = false;
        changeInstituteName = true;
      }
    } else {
      // 団体名以外変更
      //   // 2-1
      //   // 2-2
    }
  }

  // usersコレクション変更
  Future changeInstitute() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final uid = currentUser?.uid;
    //  1-2-E(あるかも)
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
      'qrLink': qrLink,
    });
  }

  @override
  void updateInstitute() async {
    FirebaseFirestore.instance
        .collection('community')
        .doc(nowCommunityName)
        .update({
      'community': communityName,
      'department': department,
      'email': email,
      'phoneNumber': int.parse(phoneNumber!),
      'link': link,
      'qrLink': qrLink,
    });
  }

  // 団体削除
  void deleteInstitute(String? communityName) async {
    await FirebaseAuth.instance.signOut();
    // communityのドキュメントを削除
    FirebaseFirestore.instance
        .collection('community')
        .doc(communityName)
        .delete();
    // attendancesのドキュメントを削除
    return FirebaseFirestore.instance
        .collection('attendances')
        .where("community", isEqualTo: communityName)
        .get()
        .then(
          // 取得したdocIDを使ってドキュメント削除
          (QuerySnapshot snapshot) => {
            snapshot.docs.forEach((f) {
              FirebaseFirestore.instance
                  .collection('attendances')
                  .doc(f.reference.id)
                  .delete();
            }),
          },
        );
  }
}
