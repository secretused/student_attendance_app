import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class QRModel extends ChangeNotifier {
  final uidController = TextEditingController();
  final timeStampController = TextEditingController();
  final attendanceController = TextEditingController();

  String? uid;
  int? timeStamp;
  String? attendance;

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

  void setTimeStamp(int date) {
    this.timeStamp = timeStamp;
    notifyListeners();
  }

  void setAttendance(String attendance) {
    this.attendance = attendance;
    notifyListeners();
  }

  Future signUp() async {
    this.uid = uidController.text;
    this.timeStamp = int.parse(timeStampController.text);
    this.attendance = attendanceController.text;

    if (uid != null) {
      // firestoreに追加
      final doc =
          FirebaseFirestore.instance.collection('attendaceLists').doc(uid);
      await doc.set({
        'uid': uid,
        'timeStamp': timeStamp,
        'attendance': attendance,
      });
    }
  }
}
