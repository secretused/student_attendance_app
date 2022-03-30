import 'package:flutter/services.dart';

import 'register_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(
      MaterialApp(home: RegisterHome()),
    );

class RegisterHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RegisterPage();
  }
}

class RegisterPage extends State<RegisterHome> {
  bool isHost = false;
  void _changeSwitch(bool e) => setState(() => isHost = e);
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RegisterModel>(
      create: (_) => RegisterModel(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            '新規登録',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Color.fromARGB(255, 67, 176, 190),
        ),
        body: Container(
          child: Center(
            child: Consumer<RegisterModel>(builder: (context, model, child) {
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
                          decoration: InputDecoration(
                            hintText: '所属団体名',
                            suffix: Text('必須',
                                style:
                                    TextStyle(color: Colors.red, fontSize: 13)),
                          ),
                          onChanged: (text) {
                            model.setCommunity(text);
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
