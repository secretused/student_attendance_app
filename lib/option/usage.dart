import 'package:flutter/material.dart';

class AppUsage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "アプリの使い方",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color.fromARGB(255, 67, 176, 190),
      ),
      body: Container(
        width: deviceWidth,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            TitleText("シュッ席とは？", 30),
            MerginBox(5),
            TitleText("QRコードスキャンで簡単に入館登録ができ\n入館管理をすることができる。", 15),
            const Divider(
              height: 30,
              thickness: 0.5,
              indent: 3,
              endIndent: 3,
              color: Colors.black,
            ),
            TitleText("アプリの始め方", 25),
            MerginBox(5),
            TitleText("管理者の方が新規登録をして、ログイン\n↓\n管理する>団体登録から団体情報を登録\n↓", 15),
            TitleText(
                "その後ユーザーを同じ団体名で登録\n(団体名が正しくない場合エラー又は\nユーザー情報が正しく表示されません)\n↓",
                15),
            TitleText("管理者が入館時に使用するQRコードを\n生成しリンクを団体情報に設定\n↓", 15),
            TitleText("QRコードを印刷などして入館場所に設置", 15),
            const Divider(
              height: 30,
              thickness: 0.5,
              indent: 3,
              endIndent: 3,
              color: Colors.black,
            ),
            TitleText("上手く動作しない場合", 20),
            MerginBox(5),
            TitleText("一度アプリを閉じて再起動をしてください。", 14),
            MerginBox(10),
            TitleText(
                "登録情報が異なるとデータが正しく表示されない\n場合や重複したようなデータが表示される可能性があります。空白や半角など間違いがないか確認してください。",
                13.5),
            MerginBox(12),
            TitleText("上記で解決しない場合はお問合せ・ご要望から\nご連絡お願いします。", 13.5),
          ]),
        ),
      ),
    );
  }

  SizedBox MerginBox(double height) {
    return SizedBox(
      height: height,
    );
  }

  Text TitleText(String text, double size) => Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: size,
        ),
      );
}
