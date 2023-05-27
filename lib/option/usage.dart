import 'package:flutter/material.dart';

class AppUsage extends StatelessWidget {
  const AppUsage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "アプリの使い方",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 67, 176, 190),
      ),
      body: SizedBox(
        width: deviceWidth,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            titleText("シュッ席とは？", 25),
            merginBox(5),
            titleText("QRコードスキャンで簡単に入館登録ができ\n入館管理をすることができる。", 13),
            const Divider(
              height: 13,
              thickness: 0.5,
              indent: 3,
              endIndent: 3,
              color: Colors.black,
            ),
            titleText("アプリの始め方", 23),
            merginBox(5),
            titleText("管理者の方が新規登録をして、ログイン\n↓\n団体登録から団体情報を登録\n↓", 13),
            titleText(
                "その後ユーザーを同じ団体名で登録\n(団体名が正しくない場合エラー又は\nユーザー情報が正しく表示されません)\n↓",
                13),
            titleText("管理者が入館時に使用するリンクを設定し\n管理する>QRコードを表示からQRコードを表示・共有\n↓", 13),
            titleText("QRコードを入館場所に設置", 13),
            const Divider(
              height: 13,
              thickness: 0.5,
              indent: 3,
              endIndent: 3,
              color: Colors.black,
            ),
            titleText("上手く動作しない場合", 20),
            merginBox(5),
            titleText("一度アプリを閉じて再起動をしてください。\nエラーが出る場合はもう一度試してください。", 14),
            merginBox(10),
            titleText(
                "登録情報が異なるとデータが正しく表示されない\n場合や重複したようなデータが表示される可能性があります。\n空白や半角など間違いがないか確認してください。",
                12),
            merginBox(12),
            titleText("上記で解決しない場合はお問合せ・ご要望から\nご連絡お願いします。", 13.5),
          ]),
        ),
      ),
    );
  }

  SizedBox merginBox(double height) {
    return SizedBox(
      height: height,
    );
  }

  FittedBox titleText(String text, double size) => FittedBox(
        // fit: BoxFit.fitWidth,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: size,
          ),
        ),
      );
}
