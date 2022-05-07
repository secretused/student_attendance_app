import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../edit_institute/edit_institute.dart';
import '../setting.dart';
import 'change_QR_model.dart';

class ChangeQRCode extends StatelessWidget {
  SettingClass setting_data = SettingClass();

  String? gotCommunity;
  ChangeQRCode(String? community) {
    this.gotCommunity = community;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<QRChangeModel>(
      create: (_) => QRChangeModel(gotCommunity)..fechInstitute(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            '団体情報',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Color.fromARGB(255, 67, 176, 190),
          actions: <Widget>[
            Consumer<QRChangeModel>(builder: (context, model, child) {
              return IconButton(
                icon: Icon(Icons.edit),
                onPressed: () async {
                  Navigator.push(
                    context,
                    setting_data.NavigationFade(EditInstitutePageHome(
                        model.communityName!,
                        model.department!,
                        model.email!,
                        model.phoneNumber!,
                        model.link!,
                        model.QRLink!)),
                  );
                },
              );
            }),
          ],
        ),
        body: Container(
          child: Center(
            child: Consumer<QRChangeModel>(builder: (context, model, child) {
              return Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                          child: Text(
                            model.communityName ?? "名前なし",
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 25,
                            ),
                          ),
                        ),
                        (model.department != null)
                            ? Text("${model.department}",
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 18.5,
                                ))
                            : const SizedBox.shrink(),
                        SizedBox(
                          height: 10,
                        ),
                        (model.email != "")
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
                                    "${model.email}",
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
                        (model.phoneNumber != "0")
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
                                    "${model.phoneNumber}",
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
                        (model.link != "")
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
                                    "${model.link}",
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
                        (model.QRLink != "")
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
                                    "${model.QRLink}",
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
                  if (model.isLoading)
                    Container(
                      color: Colors.black54,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
