import 'dart:developer';
import 'dart:io';

import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter/material.dart';
import 'package:attendanc_management_app/main.dart';

import 'attendance_register.dart';

class MyQRCode extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State {
  String qrCode = '';
  final main_data = MyHomePageState();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'QR Code Scanner',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color.fromARGB(255, 67, 176, 190),
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
                onPressed: () => scanQrCode(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future scanQrCode() async {
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
    if (qrCode == "https://techford.jp/") {
      Navigator.push(
        context,
        main_data.NavigationFade(AttendaveRegister()),
      );
    } else {
      print("QRコードが違います");
    }
  }
}