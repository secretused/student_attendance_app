import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

import '../change_QR/change_QR_model.dart';
import '../setting.dart';

class CreateQRCode extends StatelessWidget {
  SettingClass setting_data = SettingClass();

  String? gotCommunity;
  List<String> QRLinks = [];
  CreateQRCode(String? community, {Key? key}) : super(key: key) {
    gotCommunity = community;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<QRChangeModel>(
      create: (_) => QRChangeModel(gotCommunity)..fechInstitute(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'QRコード生成',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: const Color.fromARGB(255, 67, 176, 190),
        ),
        body: Center(
          child: Consumer<QRChangeModel>(builder: (context, model, child) {
            return Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    qrCode(model.QRLink),
                    const SizedBox(height: 10.0),
                    const Text(
                      "QR Code",
                      style: TextStyle(
                        fontSize: 18,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    Text(
                      model.QRLink ?? "No QRCode Link",
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 15.0),
                    SizedBox(
                      width: 150,
                      height: 50,
                      child: ElevatedButton(
                          child: const Text(
                            '共有する',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.grey,
                            onPrimary: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            try {
                              if (model.QRLink != null) {
                                var link = model.QRLink as String;
                                QRLinks.add(link);
                                _shareImages(QRLinks);
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return const ErrorModal(
                                        error_message:
                                            "QRコードを認識できませんでした\nもう一度読み込んでください");
                                  },
                                );
                              }
                            } catch (e) {
                              print(e.toString());
                            }
                          }),
                    ),
                  ],
                ),
                if (model.isLoading)
                  Container(
                    color: Colors.black54,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
              ],
            );
          }),
        ),
      ),
    );
  }

  void _shareImages(List<String> imagePaths) async {
    await Share.shareFiles(imagePaths);
  }
}

Widget qrCode(String? qrLink) {
  return Center(
    child: QrImage(
      data: "$qrLink",
      size: 250,
    ),
  );
}
