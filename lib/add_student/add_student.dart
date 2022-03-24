import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import '../authentication/register_model.dart';
import '../authentication/register_user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddMember extends StatefulWidget {
  String? gotCommunityName;
  AddMember(String? communityName) {
    this.gotCommunityName = communityName;
  }

  @override
  State<StatefulWidget> createState() {
    return RegisterPage();
  }
}

class RegisterPage extends State<AddMember> {
  bool isHost = false;
  void _changeSwitch(bool e) => setState(() => isHost = e);
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AddUserModel>(
      create: (_) => AddUserModel(widget.gotCommunityName),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
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
                            hintText: '名前',
                            suffix: Text(
                              '必須',
                              style: TextStyle(color: Colors.red, fontSize: 13),
                            ),
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
                            hintText: 'クラス',
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
                              hintText: 'Email',
                              suffix: Text('必須',
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 13))),
                          onChanged: (text) {
                            model.setEmail(text);
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
                        TextField(
                          controller: model.authorController,
                          decoration: InputDecoration(
                              hintText: 'パスワード',
                              suffix: Text('必須',
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 13))),
                          onChanged: (text) {
                            model.setPassword(text);
                          },
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
                              await model.signUp();
                              Navigator.of(context).pop();
                            } catch (e) {
                              final snackBar = SnackBar(
                                backgroundColor: Colors.red,
                                content: Text(e.toString()),
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
}
