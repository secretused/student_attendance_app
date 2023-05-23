import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../edit_institute/edit_institute.dart';
import '../setting.dart';
import 'change_QR_model.dart';

class ChangeQRCode extends ConsumerWidget {
  SettingClass settingData = SettingClass();

  String? gotCommunity;
  ChangeQRCode(String? community) {
    this.gotCommunity = community;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final qrChangeModel = ref.watch(qrChangeModelProvider);
    qrChangeModel.qrChangeModel(gotCommunity);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          '団体情報',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color.fromARGB(255, 67, 176, 190),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () async {
              Navigator.push(
                context,
                settingData.NavigationFade(EditInstitutePage(
                    qrChangeModel.communityName!,
                    qrChangeModel.department!,
                    qrChangeModel.email!,
                    qrChangeModel.phoneNumber!,
                    qrChangeModel.link!,
                    qrChangeModel.qrLink!)),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                    child: Column(
                      children: [
                        Text(
                          qrChangeModel.communityName ?? "名前なし",
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 25,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                  (qrChangeModel.department != "")
                      ? Column(
                          children: [
                            Text("${qrChangeModel.department}",
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 18.5,
                                )),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        )
                      : const SizedBox.shrink(),
                  (qrChangeModel.email != "")
                      ? Column(
                          children: [
                            Text(
                              "メールアドレス",
                              style: TextStyle(
                                fontSize: 18,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            Text(
                              "${qrChangeModel.email}",
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        )
                      : const SizedBox.shrink(),
                  (qrChangeModel.phoneNumber != "0")
                      ? Column(
                          children: [
                            Text(
                              "電話番号",
                              style: TextStyle(
                                fontSize: 18,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            Text(
                              "${qrChangeModel.phoneNumber}",
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        )
                      : const SizedBox.shrink(),
                  (qrChangeModel.link != "")
                      ? Column(
                          children: [
                            Text(
                              "関連リンク",
                              style: TextStyle(
                                fontSize: 18,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            Text(
                              "${qrChangeModel.link}",
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        )
                      : const SizedBox.shrink(),
                  (qrChangeModel.qrLink != "")
                      ? Column(
                          children: [
                            Text(
                              "QRLink",
                              style: TextStyle(
                                fontSize: 18,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            Text(
                              "${qrChangeModel.qrLink}",
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(
                              height: 18,
                            ),
                          ],
                        )
                      : const SizedBox.shrink(),
                ],
              ),
            ),
            if (qrChangeModel.isLoading)
              Container(
                color: Colors.black54,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
