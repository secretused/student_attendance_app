import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final myModelProvider =
Provider((ref) => MyModel()..fetchUser());

class MyModel {
  bool isLoading = false;
  bool isCommunity = false;

  String? uid;
  String? email;
  String? phoneNumber;
  String? name;
  String? community;
  String? grade;
  String? department;
  String? classroom;
  bool? isHost;

  void startLoading() {
    isLoading = true;
  }

  void endLoading() {
    isLoading = false;
  }

  Future fetchUser() async {
    print('fetch user');
    final user = FirebaseAuth.instance.currentUser;
    uid = user?.uid;
    email = user?.email;

    if (user != null) {
      // ユーザ情報取得
      final snapshot =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final data = snapshot.data();

      name = data?["name"];
      community = data?["community"];
      grade = data?["grade"];
      department = data?["department"];
      classroom = data?["classroom"];
      isHost = data?["isHost"];
      phoneNumber = data?["phoneNumber"];

      final getCommunity = await FirebaseFirestore.instance
          .collection('community')
          .doc(community)
          .get();
      final communityData = getCommunity.data();
      if (communityData?["community"] != null) {
        isCommunity = true;
      } else {
        isCommunity = false;
      }
    }
  }

  Future logOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
