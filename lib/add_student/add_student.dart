import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

import '../authentication/register_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddStudent extends StatefulWidget {
  String? gotCommunityName;
  AddStudent(String? communityName) {
    this.gotCommunityName = communityName;
  }

  @override
  State<StatefulWidget> createState() {
    return RegisterPage();
  }
}

class RegisterPage extends State<AddStudent> {
  bool isHost = false;
  void _changeSwitch(bool e) => setState(() => isHost = e);
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AddUserModel>(
      create: (_) => AddUserModel(widget.gotCommunityName),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'ユーザー追加',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Color.fromARGB(255, 67, 176, 190),
        ),
        body: Container(
          child: Center(
            child: Consumer<AddUserModel>(builder: (context, model, child) {
              return Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        TextField(
                          controller: model.nameController,
                          decoration: InputDecoration(
                            hintText: '名前　*',
                          ),
                          onChanged: (text) {
                            model.setName(text);
                          },
                        ),
                        TextField(
                          controller: model.communityController,
                          enabled: false,
                          decoration: InputDecoration(
                            hintText: widget.gotCommunityName,
                          ),
                        ),
                        TextField(
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          controller: model.gradeController,
                          decoration: InputDecoration(
                            hintText: '期生・学年',
                          ),
                          onChanged: (text) {
                            model.setGrade(text);
                          },
                        ),
                        TextField(
                          controller: model.departmentController,
                          decoration: InputDecoration(
                            hintText: '部署・学科',
                          ),
                          onChanged: (text) {
                            model.setCommunity(
                                widget.gotCommunityName as String);
                            model.setDepartment(text);
                          },
                        ),
                        TextField(
                          controller: model.classController,
                          decoration: InputDecoration(
                            hintText: 'チーム・クラス',
                          ),
                          onChanged: (text) {
                            model.setClass(text);
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextField(
                          controller: model.emailController,
                          decoration: InputDecoration(
                            hintText: 'Email *',
                          ),
                          onChanged: (text) {
                            model.setEmail(text);
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[a-zA-Z0-9.@_-]')),
                          ],
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
                        TextField(
                          controller: model.authorController,
                          decoration: InputDecoration(
                            hintText: 'パスワード *',
                          ),
                          onChanged: (text) {
                            model.setPassword(text);
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[a-zA-Z0-9]')),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text("団体責任者・管理者"),
                        Switch(
                          value: isHost,
                          onChanged: (value) {
                            setState(
                              () {
                                isHost = value;
                              },
                            );
                            model.setHost(isHost);
                          },
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Color.fromARGB(255, 66, 140, 224),
                            onPrimary: Colors.black,
                          ),
                          onPressed: () async {
                            model.startLoading();

                            // 追加の処理
                            try {
                              await model.addUser();
                              Navigator.of(context).pop();
                            } on FirebaseAuthException catch (e) {
                              String? authException = auth_error(e.code);
                              final snackBar = SnackBar(
                                backgroundColor: Colors.red,
                                content: Text(authException!),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            } finally {
                              model.endLoading();
                            }
                          },
                          child: Text('登録する'),
                        ),
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

  String? auth_error(e_code) {
    if (e_code == 'user-disabled') {
      return 'そのメールアドレスは利用できません';
    } else if (e_code == 'invalid-email') {
      return 'メールアドレスのフォーマットが正しくありません';
    } else if (e_code == 'user-not-found') {
      return 'ユーザーが見つかりません';
    } else if (e_code == 'wrong-password') {
      return 'パスワードが違います';
    } else if (e_code == 'weak-password') {
      return 'パスワードが短い又は記述してください';
    }
  }
}
