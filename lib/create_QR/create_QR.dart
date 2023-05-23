import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_extend/share_extend.dart';
import 'package:path_provider/path_provider.dart';

import '../change_QR/change_QR_model.dart';
import '../setting.dart';

class CreateQRCode extends ConsumerWidget {
  final GlobalKey _shareKey = GlobalKey();

  String? gotCommunity;
  CreateQRCode(String? community, {Key? key}) : super(key: key) {
    gotCommunity = community;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final qrChangeModel = ref.watch(qrChangeModelProvider);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'QRコード表示',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 67, 176, 190),
      ),
      body: Center(
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                qrCode(qrChangeModel.qrLink, _shareKey),
                const SizedBox(height: 10.0),
                const Text(
                  "QR Code",
                  style: TextStyle(
                    fontSize: 18,
                    decoration: TextDecoration.underline,
                  ),
                ),
                Text(
                  qrChangeModel.qrLink ?? "No QRCode Link",
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
                        backgroundColor: Colors.grey,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        if (qrChangeModel.qrLink != null) {
                          shareImageAndText('sample_widget', _shareKey);
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
                      }),
                ),
              ],
            ),
            if (qrChangeModel.isLoading)
              Container(
                color: Colors.black54,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<ByteData?> exportToImage(
      GlobalKey<State<StatefulWidget>> shareKey) async {
    RenderRepaintBoundary? boundary =
        shareKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    ui.Image? image = await boundary?.toImage(pixelRatio: 3.0);
    ByteData? byteData =
        await image?.toByteData(format: ui.ImageByteFormat.png);
    return byteData;
  }

  Future<File> getApplicationDocumentsFile(
      String text, List<int> imageData) async {
    final directory = await getApplicationDocumentsDirectory();

    final exportFile = File('${directory.path}/$text.png');
    if (!await exportFile.exists()) {
      await exportFile.create(recursive: true);
    }
    final file = await exportFile.writeAsBytes(imageData);
    return file;
  }

  void shareImageAndText(String text, GlobalKey globalKey) async {
    //shareする際のテキスト
    try {
      final bytes = await exportToImage(globalKey);
      //byte data→Uint8List
      final widgetImageBytes =
          bytes!.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
      //App directoryファイルに保存
      final applicationDocumentsFile =
          await getApplicationDocumentsFile(text, widgetImageBytes);

      final path = applicationDocumentsFile.path;
      await ShareExtend.share(path, "image");
      applicationDocumentsFile.delete();
    } catch (error) {
      print(error);
    }
  }
}

Widget qrCode(String? qrLink, GlobalKey<State<StatefulWidget>> _shareKey) {
  return RepaintBoundary(
    key: _shareKey,
    child: Center(
      child: QrImage(
        data: "$qrLink",
        size: 250,
      ),
    ),
  );
}
