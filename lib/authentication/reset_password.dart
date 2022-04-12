import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';
import 'login_model.dart';

class ResetPasswordForm extends StatefulWidget {
  @override
  _ResetPasswordFormState createState() => _ResetPasswordFormState();
}

class _ResetPasswordFormState extends State<ResetPasswordForm> {
  final AuthService _auth = AuthService();
  final _formGlobalKey = GlobalKey<FormState>();
  String _email = '';

  @override
  Widget build(BuildContext context) {
    final double deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'パスワード変更',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color.fromARGB(255, 67, 176, 190),
      ),
      body: Container(
        color: Color.fromARGB(255, 255, 255, 255),
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.only(right: 40.0, left: 40.0),
          child: Form(
            key: _formGlobalKey,
            child: Column(
              children: [
                SizedBox(
                  height: deviceHeight / 7,
                ),
                Image.asset(
                  'images/splash_logo.png',
                  width: 150,
                  height: 150,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "パスワード再設定メールを送信",
                  style: TextStyle(
                      color: Colors.black.withOpacity(0.7),
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 40,
                ),
                TextFormField(
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: '受信用メールアドレス',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "メールアドレスを入力してください";
                    }
                    _email = value;
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: 100, //横幅
                  height: 40, //高さ
                  child: ElevatedButton(
                    child: Text(
                      "送信",
                      style: TextStyle(fontSize: 15),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(255, 66, 140, 224),
                    ),
                    onPressed: () async {
                      if (_formGlobalKey.currentState!.validate()) {
                        String _result =
                            await _auth.sendPasswordResetEmail(_email);

                        // 成功時は戻る
                        if (_result == 'success') {
                          Navigator.pop(context);
                        } else if (_result == 'ERROR_INVALID_EMAIL') {
                          Flushbar(
                            message: "無効なメールアドレスです",
                            backgroundColor: Colors.red,
                            margin: EdgeInsets.all(8),
                            duration: Duration(seconds: 3),
                          )..show(context);
                        } else if (_result == 'ERROR_USER_NOT_FOUND') {
                          Flushbar(
                            message: "メールアドレスが登録されていません",
                            backgroundColor: Colors.red,
                            margin: EdgeInsets.all(8),
                            duration: Duration(seconds: 3),
                          )..show(context);
                        } else {
                          Flushbar(
                            message: "メール送信に失敗しました",
                            backgroundColor: Colors.red,
                            margin: EdgeInsets.all(8),
                            duration: Duration(seconds: 3),
                          )..show(context);
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
