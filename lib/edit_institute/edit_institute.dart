import 'package:attendanc_management_app/edit_profile/edit_profile_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../setting.dart';
import 'edit_institute_model.dart';

class EditInstitutePageHome extends StatefulWidget {
  @override
  String? communityName;
  String? department;
  String? email;
  String? phoneNumber;
  String? link;
  String? QRLink;
  EditInstitutePageHome(
    String? communityName,
    String? department,
    String? email,
    String? phoneNumber,
    String? link,
    String? QRLink,
  ) {
    this.communityName = communityName;
    this.department = department;
    this.email = email;
    this.phoneNumber = phoneNumber;
    this.link = link;
    this.QRLink = QRLink;
  }

  State<StatefulWidget> createState() {
    return EditInstitutePage();
  }
}

class EditInstitutePage extends State<EditInstitutePageHome> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EditInstituteModel>(
      create: (_) => EditInstituteModel(widget.communityName, widget.department,
          widget.email, widget.phoneNumber, widget.link, widget.QRLink),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            '団体情報変更',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Color.fromARGB(255, 67, 176, 190),
        ),
        body: Center(
          child: Consumer<EditInstituteModel>(builder: (context, model, child) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextField(
                    controller: model.communityController,
                    decoration: InputDecoration(
                      hintText: '団体名',
                      suffix: Text('必須',
                          style: TextStyle(color: Colors.red, fontSize: 13)),
                    ),
                    onChanged: (text) {
                      model.setCommunity(text);
                    },
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
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
                          style: TextStyle(color: Colors.red, fontSize: 13)),
                    ),
                    onChanged: (text) {
                      model.setQRLink(text);
                    },
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(255, 66, 140, 224),
                      onPrimary: Colors.black,
                    ),
                    onPressed: model.isUpdated()
                        ? () async {
                            // ローディング開始
                            setState(() {
                              isLoading = true;
                            });
                            try {
                              // ローディング処理
                              await model.update();
                              if (model.sameName == true) {
                                // 1-1
                                print("1-1");
                                setState(() {
                                  isLoading = false;
                                });

                                showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return ErrorModal(
                                        error_message:
                                            "既にこの団体は存在しています\n他の団体名を設定してください");
                                  },
                                );
                              } else {
                                //  1-2-E(あるかも)
                                print("1-2-E(あるかも)");
                                if (model.QRLink!.isEmpty) {
                                  // 2-1
                                  setState(() {
                                    isLoading = false;
                                  });
                                  showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (BuildContext context) {
                                      return ErrorModal(
                                          error_message: "QRリンクが入力されていません");
                                    },
                                  );
                                } else if (model.change_institute_name ==
                                    true) {
                                  //  1-2
                                  print("1-2");
                                  setState(() {
                                    isLoading = false;
                                  });
                                  var isCancel = await showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (BuildContext context) {
                                      return ValidaterModal(
                                        title: "団体名称変更",
                                        validate_message:
                                            "全てのユーザー情報が変更されます\n本当に団体情報を変更しますか？",
                                        validate_button: "変更",
                                        validate_cancel: "キャンセル",
                                      );
                                    },
                                  );
                                  if (isCancel != true) {
                                    print("名前アップデート");
                                    model.changeInstitute();
                                    Navigator.popUntil(
                                        context, (route) => route.isFirst);
                                  }
                                } else {
                                  setState(() {
                                    isLoading = false;
                                  });
                                  // 2-2
                                  print("2-2");
                                  var isCancel = await showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (BuildContext context) {
                                      return ValidaterModal(
                                        title: "確認画面",
                                        validate_message: "団体情報を変更しますか？",
                                        validate_button: "変更",
                                        validate_cancel: "キャンセル",
                                      );
                                    },
                                  );
                                  if (isCancel != true) {
                                    print("名前以外アップデート");
                                    model.updateInstitute();
                                    Navigator.popUntil(
                                        context, (route) => route.isFirst);
                                  }
                                }
                              }
                            } catch (e) {
                              if (model.communityName!.isEmpty) {
                                //  1-2-E
                                print("1-2-E");
                                setState(() {
                                  isLoading = false;
                                });
                                showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return ErrorModal(
                                        error_message: "団体名が入力されていません");
                                  },
                                );
                              } else {
                                final snackBar = SnackBar(
                                  backgroundColor: Colors.red,
                                  content: Text(e.toString()),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              }
                            }
                          }
                        : null,
                    child: Text('更新する'),
                  ),
                  CirculeLoadingAction(visible: isLoading)
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
