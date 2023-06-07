import 'package:attendanc_management_app/scan_qr_code/qr_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../setting.dart';
import 'attendance_register.dart';

class MyQRCode extends ConsumerStatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyQRCode> {
  final navigation = const NavigationSettings();
  String qrCode = '';

  @override
  Widget build(BuildContext context) {
    final qrModel = ref.watch(qrModelProvider);
    return WillPopScope(
      onWillPop: () => _backButtonPress(context),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'QRコード読み取り',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: const Color.fromARGB(255, 67, 176, 190),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 130, //横幅
                height: 130, //高さ
                child: ElevatedButton(
                  child: const Icon(
                    Icons.qr_code_2,
                    size: 100,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    shape: const CircleBorder(
                      side: BorderSide(
                        color: Colors.black,
                        width: 1,
                        style: BorderStyle.solid,
                      ),
                    ),
                  ),
                  onPressed: () => scanQrCode(qrModel.community, qrModel.isHost,
                      qrModel.department, qrModel.grade, qrModel.classroom),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future scanQrCode(String? community, bool? isHost, String? department,
      String? grade, String? classroom) async {
    late String? sameCommunity;
    late String? QRCodeLink;
    FirebaseFirestore.instance
        .collection('community')
        .doc(community)
        .snapshots()
        .listen((DocumentSnapshot snapshot) {
      sameCommunity = snapshot.get('community');
      QRCodeLink = snapshot.get('QRLink');
    });
    final qrCode = await FlutterBarcodeScanner.scanBarcode(
      '#EB394B',
      'Cancel',
      true,
      ScanMode.QR,
    );
    if (!mounted) return;

    setState(() {
      this.qrCode = qrCode;
    });
    if (qrCode == QRCodeLink) {
      await Navigator.push(
        context,
        navigation.navigationFade(AttendanceRegister(
            community, isHost, department, grade, classroom, sameCommunity)),
      );
    } else {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return const ErrorModal(error_message: "QRコードが違います\n違うQRコードを試してください");
        },
      );
    }
  }

  Future<bool> _backButtonPress(context) async {
    Navigator.of(context).pop(false);
    return false;
  }
}
