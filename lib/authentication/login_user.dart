import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../setting.dart';
import 'login_model.dart';
import 'register_user.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'reset_password.dart';

class LoginPage extends ConsumerWidget {
  final navigation = const NavigationSettings();
  String? errorText;

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final loginModel = ref.watch(loginModelProvider);
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'ログイン',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: const Color.fromARGB(255, 67, 176, 190),
        ),
        body: Center(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: loginModel.titleController,
                        decoration: const InputDecoration(
                          hintText: 'Email',
                        ),
                        onChanged: (text) {
                          loginModel.setEmail(text);
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'[a-zA-Z0-9.@_-]')),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      TextField(
                        controller: loginModel.authorController,
                        decoration: const InputDecoration(
                          hintText: 'パスワード',
                        ),
                        onChanged: (text) {
                          loginModel.setPassword(text);
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'[a-zA-Z0-9]')),
                        ],
                        obscureText: true,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 66, 140, 224),
                          foregroundColor: Colors.black,
                        ),
                        onPressed: () async {
                          loginModel.startLoading();

                          // 追加の処理
                          try {
                            await loginModel.login();
                            Navigator.of(context).pop();
                          } on FirebaseAuthException catch (e) {
                            // Authntication例外処理
                            String? authException = authError(e.code);
                            final snackBar = SnackBar(
                              backgroundColor: Colors.red,
                              content: Text(authException!),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          } finally {
                            loginModel.endLoading();
                          }
                        },
                        child: const Text('ログイン'),
                      ),
                      TextButton(
                        onPressed: () async {
                          // 画面遷移
                          await Navigator.push(
                              context,
                              navigation.navigationFade(
                                  ResetPasswordForm()));
                        },
                        child: const Text(
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
                          minimumSize: const Size(150, 30), //最小のサイズ
                        ),
                        onPressed: () async {
                          // 画面遷移
                          await Navigator.push(
                              context,
                              navigation.navigationFade(
                                  RegisterPage()));
                        },
                        child: const Text(
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
                if (loginModel.isLoading)
                  Container(
                    color: Colors.black54,
                    child: const Center(
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
    }
    return 'エラーが発生しました';
  }
}
