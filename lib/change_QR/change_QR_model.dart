import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final qrChangeModelProvider =
Provider((ref) => QRChangeModel()..fetchInstitute());

class QRChangeModel {
  bool isLoading = false;
  String? communityName;

  String? department;
  String? email;
  String? phoneNumber;
  String? link;
  String? qrLink;

  qrChangeModel(String? gotCommunity) {
    communityName = gotCommunity;
  }

  void startLoading() {
    isLoading = true;
  }

  void endLoading() {
    isLoading = false;
  }

  void fetchInstitute() async {
    List<DocumentSnapshot> documentList = [];

    final snapshot = await FirebaseFirestore.instance
        .collection('community')
        .where("community", isEqualTo: communityName)
        .get();
    documentList = snapshot.docs;

    documentList.map((data) {
      department = data["department"];
      email = data["email"];
      phoneNumber = data["phoneNumber"].toString();
      link = data["link"];
      qrLink = data["QRLink"];
    }).toList();
  }
}
