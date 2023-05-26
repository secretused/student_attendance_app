import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../authentication/register_model.dart';
import 'package:flutter/material.dart';

class AddStudent extends ConsumerStatefulWidget {
  String? gotCommunityName;
  AddStudent(String? communityName) {
    gotCommunityName = communityName;
  }

  @override
  _AddStudentState createState() => _AddStudentState();
}

class _AddStudentState extends ConsumerState<AddStudent> {
  bool isHost = false;
  // void _changeSwitch(bool e) => setState(() => isHost = e);
  @override
  Widget build(BuildContext context) {
    final addUserModel = ref.watch(addUserModelProvider);
    addUserModel.setCommunityName(widget.gotCommunityName);
      return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'ユーザー追加',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Color.fromARGB(255, 67, 176, 190),
        ),
        body: Center(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: addUserModel.nameController,
                        decoration: InputDecoration(
                          hintText: '名前　*',
                        ),
                        onChanged: (text) {
                          addUserModel.setName(text);
                        },
                      ),
                      TextField(
                        controller: addUserModel.communityController,
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
                        controller: addUserModel.gradeController,
                        decoration: InputDecoration(
                          hintText: '期生・学年',
                        ),
                        onChanged: (text) {
                          addUserModel.setGrade(text);
                        },
                      ),
                      TextField(
                        controller: addUserModel.departmentController,
                        decoration: InputDecoration(
                          hintText: '部署・学科',
                        ),
                        onChanged: (text) {
                          addUserModel.setCommunity(
                              widget.gotCommunityName as String);
                          addUserModel.setDepartment(text);
                        },
                      ),
                      TextField(
                        controller: addUserModel.classController,
                        decoration: InputDecoration(
                          hintText: 'チーム・クラス',
                        ),
                        onChanged: (text) {
                          addUserModel.setClass(text);
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextField(
                        controller: addUserModel.emailController,
                        decoration: InputDecoration(
                          hintText: 'Email *',
                        ),
                        onChanged: (text) {
                          addUserModel.setEmail(text);
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
                        controller: addUserModel.phoneNumController,
                        decoration: InputDecoration(
                          hintText: '電話番号',
                        ),
                        onChanged: (text) {
                          addUserModel.setPhoneNumber(text);
                        },
                      ),
                      TextField(
                        controller: addUserModel.authorController,
                        decoration: InputDecoration(
                          hintText: 'パスワード *',
                        ),
                        onChanged: (text) {
                          addUserModel.setPassword(text);
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
                          addUserModel.setHost(isHost);
                        },
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 66, 140, 224),
                          foregroundColor: Colors.black,
                        ),
                        onPressed: () async {
                          addUserModel.startLoading();

                          // 追加の処理
                          try {
                            await addUserModel.addUser();
                            Navigator.of(context).pop();
                          } on FirebaseAuthException catch (e) {
                            String? authException = authError(e.code);
                            final snackBar = SnackBar(
                              backgroundColor: Colors.red,
                              content: Text(authException!),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          } finally {
                            addUserModel.endLoading();
                          }
                        },
                        child: Text('登録する'),
                      ),
                    ],
                  ),
                ),
                if (addUserModel.isLoading)
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

  String? authError(errorCode) {
    if (errorCode == 'user-disabled') {
      return 'そのメールアドレスは利用できません';
    } else if (errorCode == 'invalid-email') {
      return 'メールアドレスのフォーマットが正しくありません';
    } else if (errorCode == 'user-not-found') {
      return 'ユーザーが見つかりません';
    } else if (errorCode == 'wrong-password') {
      return 'パスワードが違います';
    } else if (errorCode == 'weak-password') {
      return 'パスワードが短い又は記述してください';
    }
    return 'エラーが発生しました';
  }
}
