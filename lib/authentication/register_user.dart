import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../setting.dart';
import 'register_model.dart';
import 'package:flutter/material.dart';

void main() => runApp(
      MaterialApp(home: RegisterPage()),
    );

class RegisterPage extends ConsumerStatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  bool isHost = false;
  @override
  Widget build(BuildContext context) {
    final registerModel = ref.watch(registerModelProvider);
      return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            '新規登録',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: const Color.fromARGB(255, 67, 176, 190),
        ),
        body: GestureDetector(
          behavior: HitTestBehavior.opaque, //画面外タップを検知するために必要
          onTap: () => FocusScope.of(context).unfocus(),
          child: Center(
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: registerModel.nameController,
                          decoration: const InputDecoration(
                            hintText: '名前 *',
                          ),
                          onChanged: (text) {
                            registerModel.setName(text);
                          },
                        ),
                        TextField(
                          controller: registerModel.communityController,
                          decoration: const InputDecoration(
                            hintText: '所属団体名 *',
                          ),
                          onChanged: (text) {
                            registerModel.setCommunity(text);
                          },
                        ),
                        TextField(
                          controller: registerModel.departmentController,
                          decoration: const InputDecoration(
                            hintText: '部署・学科',
                          ),
                          onChanged: (text) {
                            registerModel.setDepartment(text);
                          },
                        ),
                        TextField(
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          controller: registerModel.gradeController,
                          decoration: const InputDecoration(
                            hintText: '期生・学年',
                          ),
                          onChanged: (text) {
                            registerModel.setGrade(text);
                          },
                        ),
                        TextField(
                          controller: registerModel.classController,
                          decoration: const InputDecoration(
                            hintText: 'チーム・クラス',
                          ),
                          onChanged: (text) {
                            registerModel.setClass(text);
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextField(
                          controller: registerModel.emailController,
                          decoration: const InputDecoration(
                            hintText: 'Email *',
                          ),
                          onChanged: (text) {
                            registerModel.setEmail(text);
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'[a-zA-Z0-9.@_-]'),
                            ),
                          ],
                        ),
                        TextField(
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(11),
                          ],
                          controller: registerModel.phoneNumController,
                          decoration: const InputDecoration(
                            hintText: '電話番号',
                          ),
                          onChanged: (text) {
                            registerModel.setPhoneNumber(text);
                          },
                        ),
                        TextField(
                          controller: registerModel.authorController,
                          decoration: const InputDecoration(
                            hintText: 'パスワード *',
                          ),
                          onChanged: (text) {
                            registerModel.setPassword(text);
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[a-zA-Z0-9]')),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text("団体責任者・管理者"),
                        Switch(
                          value: isHost,
                          onChanged: (value) {
                            setState(
                              () {
                                isHost = value;
                              },
                            );
                            registerModel.setHost(isHost);
                          },
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 66, 140, 224),
                            foregroundColor: Colors.black,
                          ),
                          onPressed: () async {
                            registerModel.startLoading();
                            // 追加の処理
                            try {
                              if (registerModel.name == null) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return const ErrorModal(
                                        errorMessage: "名前を入力してください");
                                  },
                                );
                              } else if (registerModel.communityName == null) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return const ErrorModal(
                                        errorMessage: "団体名を入力してください");
                                  },
                                );
                              }
                              await registerModel.signUp();
                              Navigator.of(context)
                                  .popUntil((route) => route.isFirst);
                            } on FirebaseAuthException catch (e) {
                              String? authException = authError(e.code);
                              final snackBar = SnackBar(
                                backgroundColor: Colors.red,
                                content: Text(authException!),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            } finally {
                              registerModel.endLoading();
                            }
                          },
                          child: const Text('登録する'),
                        ),
                      ],
                    ),
                  ),
                  if (registerModel.isLoading)
                    Container(
                      color: Colors.black54,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                ],
              ),
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
