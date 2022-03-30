import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'community_model.dart';
import '../setting.dart';

class AddInstituteHome extends StatefulWidget {
  @override
  String? community;
  AddInstituteHome(String? community) {
    this.community = community;
  }

  State<StatefulWidget> createState() {
    return AddInstitute();
  }
}

class AddInstitute extends State<AddInstituteHome> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CommunityModel>(
      create: (_) => CommunityModel(widget.community),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            '団体登録',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Color.fromARGB(255, 67, 176, 190),
        ),
        body: Container(
          child: Center(
            child: Consumer<CommunityModel>(builder: (context, model, child) {
              return Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        TextField(
                          controller: model.communityController,
                          enabled: false,
                          decoration: InputDecoration(
                            hintText: widget.community,
                          ),
                        ),
                        TextField(
                          controller: model.departmentController,
                          decoration: InputDecoration(
                            hintText: '支店・部署名',
                          ),
                          onChanged: (text) {
                            model.setDepartment(text);
                          },
                        ),
                        TextField(
                          controller: model.emailController,
                          decoration: InputDecoration(
                            hintText: 'メールアドレス',
                          ),
                          onChanged: (text) {
                            model.setEmail(text);
                          },
                        ),
                        TextField(
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          controller: model.phoneNumberController,
                          decoration: InputDecoration(
                            hintText: '電話番号',
                          ),
                          onChanged: (text) {
                            model.setPhoneNumber(text);
                          },
                        ),
                        TextField(
                          controller: model.linkController,
                          decoration: InputDecoration(
                            hintText: '関連リンク',
                          ),
                          onChanged: (text) {
                            model.setLink(text);
                          },
                        ),
                        TextField(
                          controller: model.QRLinkController,
                          decoration: InputDecoration(
                            hintText: 'QRコード読み取り先リンク',
                            suffix: Text('必須',
                                style:
                                    TextStyle(color: Colors.red, fontSize: 13)),
                          ),
                          onChanged: (text) {
                            model.setQRLink(text);
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Color.fromARGB(255, 66, 140, 224),
                            onPrimary: Colors.black,
                          ),
                          onPressed: () async {
                            // 追加の処理
                            try {
                              await model.addCommunity();
                              if (model.error != true) {
                                if (!model.QRLink!.isEmpty) {
                                  var isCancel = await showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (BuildContext context) {
                                      return ValidaterModal(
                                        title: "確認画面",
                                        validate_message: "この内容で登録しますか？",
                                        validate_button: "登録",
                                        colors: Colors.lightBlue,
                                        validate_cancel: "キャンセル",
                                      );
                                    },
                                  );
                                  if (isCancel != true) {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    model.addInstitute();
                                    Navigator.pop(context);
                                  }
                                } else {
                                  showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (BuildContext context) {
                                      return ErrorModal(
                                          error_message: "QRリンクを入力してください");
                                    },
                                  );
                                }
                              } else {
                                showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return ErrorModal(
                                        error_message:
                                            "既にこの団体は存在しています\n他の団体名でログインしてください");
                                  },
                                );
                              }
                            } catch (e) {
                              final snackBar = SnackBar(
                                backgroundColor: Colors.red,
                                content: Text(e.toString()),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                          },
                          child: Text('登録する'),
                        ),
                        CirculeLoadingAction(visible: isLoading)
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
