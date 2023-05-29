import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final editProfileModelProvider =
Provider((ref) => EditProfileModel());

class EditProfileModel {

  String? uid;
  String? name;
  String? department;
  String? grade;
  String? classroom;
  String? phoneNumber;
  bool? isHost;
  bool nameNull = false;
  bool isLoading = false;


  void setName(String name) {
    this.name = name;
  }

  void setHost(bool isHost) {
    this.isHost = isHost;
  }

  void setUid(String uid) {
    this.uid = uid;
  }


  Future update(
      nameController,
      departmentController,
      gradeController,
      classController,
      phoneNumController) async {
    name = nameController.text;
    department = departmentController.text;
    grade = gradeController.text;
    classroom = classController.text;
    phoneNumber = phoneNumController.text;

    // Authの名前変更
    final instance = FirebaseAuth.instance;
    final User? user = instance.currentUser;
    await user!.updateDisplayName(name);

    if (name != "") {
      // firestoreに追加
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'name': name,
        'department': department,
        'grade': grade,
        'classroom': classroom,
        'phoneNumber': phoneNumber,
        'isHost': isHost,
      });
    } else {
      // 名前が空欄
      nameNull = true;
    }
  }

  // user削除処理
  void deleteUser(String? uid, String? community) async {
    // FireBaseのAuthを削除
    FirebaseAuth.instance.currentUser?.delete();
    // ログアウト
    await FirebaseAuth.instance.signOut();
    // usersのドキュメントを削除
    FirebaseFirestore.instance.collection('users').doc(uid).delete();
    // attendancesのドキュメントを削除
    return FirebaseFirestore.instance
        .collection('attendances')
        .where("uid", isEqualTo: uid)
        .where("community", isEqualTo: community)
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

  Future changeHost() async {
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'isHost': isHost,
    });
  }
}
