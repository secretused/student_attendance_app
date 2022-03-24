import 'package:attendanc_management_app/edit_profile/edit_profile_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../setting.dart';

class EditProfilePage extends StatefulWidget {
  @override
  EditProfilePage(this.uid, this.name, this.department, this.grade,
      this.classroom, this.phoneNumber, this.community);
  final String uid;
  final String name;
  final String department;
  final String grade;
  final String classroom;
  final String phoneNumber;
  final String community;

  State<StatefulWidget> createState() {
    return EditProfilePageHome();
  }
}

class EditProfilePageHome extends State<EditProfilePage> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EditProfileModel>(
      create: (_) => EditProfileModel(
          widget.uid,
          widget.name,
          widget.department,
          widget.grade,
          widget.classroom,
          widget.phoneNumber),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'プロフィール編集',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Color.fromARGB(255, 67, 176, 190),
        ),
        body: Center(
          child: Consumer<EditProfileModel>(builder: (context, model, child) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextField(
                    controller: model.nameController,
                    decoration: InputDecoration(
                      hintText: '名前',
                      suffix: Text('必須',
                          style: TextStyle(color: Colors.red, fontSize: 13)),
                    ),
                    onChanged: (text) {
                      model.setName(text);
                    },
                  ),
                  TextField(
                    controller: model.departmentController,
                    decoration: InputDecoration(
                      hintText: '部署・学科',
                    ),
                    onChanged: (text) {
                      model.setDepartment(text);
                    },
                  ),
                  TextField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    controller: model.gradeController,
                    decoration: InputDecoration(
                      hintText: '期生・学年',
                    ),
                    onChanged: (text) {
                      model.setGrade(text);
                    },
                  ),
                  TextField(
                    controller: model.classController,
                    decoration: InputDecoration(
                      hintText: 'クラス',
                    ),
                    onChanged: (text) {
                      model.setClass(text);
                    },
                  ),
                  TextField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(11),
                    ],
                    controller: model.phoneNumController,
                    decoration: InputDecoration(
                      hintText: '電話番号',
                    ),
                    onChanged: (text) {
                      model.setPhoneNumber(text);
                    },
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
                            // 追加の処理
                            try {
                              setState(() {
                                isLoading = true;
                              });
                              await model.update();
                              if (model.nameNull) {
                                setState(() {
                                  isLoading = false;
                                });
                                showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return ErrorModal(
                                        error_message: "名前をを入力してください");
                                  },
                                );
                              } else {
                                // user一覧からの遷移もあるので二つ前
                                Navigator.popUntil(
                                    context, (route) => route.isFirst);
                              }
                            } catch (e) {
                              final snackBar = SnackBar(
                                backgroundColor:
                                    Color.fromARGB(255, 185, 70, 61),
                                content: Text(e.toString()),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                          }
                        : null,
                    child: Text('更新する'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      elevation: 0,
                      onPrimary: Colors.red,
                    ),
                    onPressed: () async {
                      var isCancel = await showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (BuildContext context) {
                          return ValidaterModal(
                            title: "確認画面",
                            validate_message: "このユーザーの全てのデータが削除されます、本当に削除しますか？",
                            validate_button: "削除",
                            colors: Colors.red,
                            validate_cancel: "キャンセル",
                          );
                        },
                      );
                      if (isCancel != true) {
                        model.deleteUser(widget.uid, widget.community);
                        Navigator.popUntil(context, (route) => route.isFirst);
                      }
                    },
                    child: Text(
                      'アカウント削除',
                      style: TextStyle(
                        fontSize: 15,
                        decoration: TextDecoration.underline,
                      ),
                    ),
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
