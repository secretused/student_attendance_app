import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../mypage/my_model.dart';
import '../setting.dart';
import 'attendance_register.dart';

class MyQRCode extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State {
  SettingClass setting_data = SettingClass();
  String qrCode = '';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MyModel>(
      create: (_) => MyModel()..fechUser(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'QR Code Scanner',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Color.fromARGB(255, 67, 176, 190),
        ),
        body: Center(
          child: Consumer<MyModel>(builder: (context, model, child) {
            return Column(
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
                      primary: Colors.white,
                      onPrimary: Colors.black,
                      shape: const CircleBorder(
                        side: BorderSide(
                          color: Colors.black,
                          width: 1,
                          style: BorderStyle.solid,
                        ),
                      ),
                    ),
                    onPressed: () => scanQrCode(model.community, model.isHost),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Future scanQrCode(String? community, bool? isHost) async {
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
        setting_data.NavigationFade(
            AttendanceRegister(community, isHost, sameCommunity)),
      );
    } else {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return ErrorModal(error_message: "QRコードが違います\n正しいQRコードを試してください");
        },
      );
    }
  }
}
