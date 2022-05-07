import '../setting.dart';
import 'login_model.dart';
import 'register_user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'reset_password.dart';

class LoginPage extends StatelessWidget {
  SettingClass setting_data = SettingClass();
  String? error_text;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginModel>(
      create: (_) => LoginModel(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'ログイン',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Color.fromARGB(255, 67, 176, 190),
        ),
        body: Container(
          child: Center(
            child: Consumer<LoginModel>(builder: (context, model, child) {
              return Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        TextField(
                          controller: model.titleController,
                          decoration: InputDecoration(
                            hintText: 'Email',
                          ),
                          onChanged: (text) {
                            model.setEmail(text);
                          },
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        TextField(
                          controller: model.authorController,
                          decoration: InputDecoration(
                            hintText: 'パスワード',
                          ),
                          onChanged: (text) {
                            model.setPassword(text);
                          },
                          obscureText: true,
                        ),
                        SizedBox(
                          height: 16,
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
                              await model.login();
                              Navigator.of(context).pop();
                            } on FirebaseAuthException catch (e) {
                              // Authntication例外処理
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
                          child: Text('ログイン'),
                        ),
                        TextButton(
                          onPressed: () async {
                            // 画面遷移
                            await Navigator.push(
                                context,
                                setting_data.NavigationFade(
                                    ResetPasswordForm()));
                          },
                          child: Text(
                            'パスワードを忘れた場合',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.red,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            minimumSize: Size(150, 30), //最小のサイズ
                          ),
                          onPressed: () async {
                            // 画面遷移
                            await Navigator.push(
                                context,
                                await setting_data.NavigationFade(
                                    RegisterHome()));
                          },
                          child: Text(
                            '新規登録の方はこちら',
                            style: TextStyle(
                              color: Colors.black,
                              decoration: TextDecoration.underline,
                            ),
                          ),
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
    }
  }
}
