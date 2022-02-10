import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpModel extends ChangeNotifier {
  String mail = "";
  String password = "";

  //FirebaseAuthのインスタンスを生成
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future signup() async {
    if (mail.isEmpty) {
      throw "メールアドレスを入力して下さい";
    }
    if (password.isEmpty) {
      throw "パスワードを入力して下さい";
    }
    //Fire Auth に新規登録ユーザーの情報を書き込む
    final UserCredential user = await auth.createUserWithEmailAndPassword(
      email: mail,
      password: password,
    );

    final email = user.user!.email;
    // FireStoreに新規登録ユーザーの情報を書き込む
    await FirebaseFirestore.instance.collection("users").add({
      "email": email,
      "password": password,
      "createAt": Timestamp.now(),
    });
  }
}

class LoginModel extends ChangeNotifier {
  String mail = "";
  String password = "";

  //FirebaseAuthのインスタンスを生成
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future login() async {
    if (mail.isEmpty) {
      throw "メールアドレスを入力して下さい";
    }
    if (password.isEmpty) {
      throw "パスワードを入力して下さい";
    }
    //ToDo
    final userInfo = await auth.signInWithEmailAndPassword(
      email: mail,
      password: password,
    );

    // final uid = userInfo.user!.uid;
  }
}
