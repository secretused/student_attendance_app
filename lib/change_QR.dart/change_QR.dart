import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../edit_institute/edit_institute.dart';
import '../setting.dart';
import 'change_QR_model.dart';
import 'package:attendanc_management_app/edit_profile/edit_proflie_page.dart';

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
                    setting_data.NavigationFade(EditInstitutePage(
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
                              fontSize: 20,
                            ),
                          ),
                        ),
                        Text(
                          model.department ?? "支店・部署名なし",
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 17.5,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "メールアドレス",
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        Text(model.email ?? "メールアドレスなし"),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "電話番号",
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        Text(model.phoneNumber ?? "電話番号なし"),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "関連リンク",
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        Text(model.link ?? "リンクなし"),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "QRコードリンク",
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        Text(model.QRLink ?? "QRコードなし"),
                        SizedBox(
                          height: 20,
                        ),
                        TextButton(
                            onPressed: () async {
                              await model.logOut();
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              "ログアウト",
                              style: TextStyle(
                                color: Color.fromARGB(255, 66, 140, 224),
                              ),
                            ))
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
