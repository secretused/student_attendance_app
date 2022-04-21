import 'package:flutter/material.dart';

class PrivacyPolicy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "プライバシーポリシー",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color.fromARGB(255, 67, 176, 190),
      ),
      body: Container(
        child: ListView(
          children: [
            PrivacyPolicyCard(
                "個人情報の取得", "本アプリは個人情報を法令を遵守して適法に\n取得しております。", 110),
            PrivacyPolicyCard("個人情報の利用", "本アプリの機能面またはログイン情報として使用", 90),
            PrivacyPolicyCard(
                "個人情報の提供", "本アプリがユーザの同意なしに個人情報を第三者へ\n提供することはありません。", 110),
            PrivacyPolicyCard(
                "個人情報の開示、訂正等の手続き", "本人又は管理者からの要望で情報の開示、訂正のための手続きに応じます。", 110),
            PrivacyPolicyCard("個人情報の利用停止等について",
                "本人又は管理者からの要望で個人データの利用停止\nまたは削除のための手続きに応じます。", 110),
            PrivacyPolicyCard("ユーザが入力したデータやその記録",
                "ユーザが入力した情報はデータベースに保存され、ユーザの同意なしに外部に送信されることはありません。", 110),
            PrivacyPolicyCard(
                "個人情報取扱事業者",
                "Vantanテックフォードアカデミー 鳥羽悠太\n〒453-0801 愛知県名古屋市中村区太閤3-2-14 2F",
                110),
          ],
        ),
      ),
    );
  }

  SizedBox PrivacyPolicyCard(String title, String desc, double height) {
    return SizedBox(
      width: 250, //横幅
      height: height, //高さ
      child: Card(
        child: ListTile(
          title: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(
              title,
              style: TextStyle(fontSize: 18),
            ),
          ),
          subtitle: Text(desc),
        ),
      ),
    );
  }
}
