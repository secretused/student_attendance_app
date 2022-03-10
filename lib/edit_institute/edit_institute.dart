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
                            setState(() {
                              isLoading = true;
                            });
                            try {
                              // ローディング処理
                              await model.update();
                              if (model.sameName == true) {
                                // ローディング開始
                                setState(() {
                                  isLoading = false;
                                });

                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return ErrorModal(
                                        error_message:
                                            "既にこの団体は存在しています\n他の団体名を設定してください");
                                  },
                                );
                              } else {
                                if (model.QRLink!.isEmpty) {
                                  setState(() {
                                    isLoading = false;
                                  });
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return ErrorModal(
                                          error_message: "QRリンクが入力されていません");
                                    },
                                  );
                                } else {
                                  // ローディング終了
                                  isLoading = false;
                                  Navigator.of(context)
                                      .pop(model.communityName);
                                }
                              }
                            } catch (e) {
                              if (model.communityName!.isEmpty) {
                                setState(() {
                                  isLoading = false;
                                });
                                showDialog(
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
                            } finally {
                              model.endLoading();
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
