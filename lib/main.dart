import 'package:attendanc_management_app/add_institute/add_community.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:attendanc_management_app/authentication/login_user.dart';

import 'management_home.dart';
import 'package:attendanc_management_app/mypage/my_page.dart';
import 'package:attendanc_management_app/scan_qr_code/qr_code.dart';

import 'mypage/my_model.dart';
import 'option/privacy_policy.dart';
import 'option/usage.dart';
import 'setting.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Attendance-Management',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      home: const MyHomePage(title: '入館管理'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  final myFocusNode = FocusNode();
  final myController = TextEditingController();
  late String name;

  final url = 'https://twitter.com/uta_app_vta';
  final secondUrl = 'https://qiita.com/utasan_com';

  SettingClass setting_data = SettingClass();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MyModel>(
      create: (_) => MyModel()..fechUser(),
      child: Consumer<MyModel>(builder: (context, model, child) {
        return Scaffold(
          // メニュードロワー
          drawer: Drawer(
            child: ListView(
              children: [
                DrawerHeader(
                  child: Text(
                    'アプリケーション情報',
                    style: TextStyle(
                        fontSize: 24,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 67, 176, 190),
                  ),
                ),
                menuListTile(context, "シュッ席の使い方", AppUsage()),
                menuListTile(context, "プライバシーポリシー", PrivacyPolicy()),
                ListTile(
                    title: Text("お問い合わせ・ご意見"),
                    onTap: () => _launchURL(url, secondUrl)),
                ListTile(
                  title: Text("ライセンス情報"),
                  onTap: () => showLicensePage(
                    context: context,
                    applicationName: 'シュッ席',
                    applicationVersion: '1.0.0',
                  ),
                ),
              ],
            ),
          ),
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              widget.title,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: Color.fromARGB(255, 67, 176, 190),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.person),
                onPressed: () async {
                  // ログイン判断
                  if (FirebaseAuth.instance.currentUser != null) {
                    Navigator.push(
                      context,
                      setting_data.NavigationButtonCutIn(MyPage()),
                    );
                  } else {
                    // ユーザ登録・ログイン
                    Navigator.push(
                      context,
                      setting_data.NavigationFade(LoginPage()),
                    ).then((value) {
                      model.fechUser();
                    });
                  }
                },
              ),
            ],
          ),
          body: Container(
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: ElevatedButton(
                          child: Icon(
                            Icons.credit_card,
                            size: 60,
                          ),
                          style: ElevatedButton.styleFrom(
                            alignment: Alignment.center,
                            primary: Color.fromARGB(255, 51, 166, 243),
                            onPrimary: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () async {
                            if (FirebaseAuth.instance.currentUser != null) {
                              // 団体の有無
                              if (model.isCommunity == true) {
                                Navigator.push(
                                  context,
                                  setting_data.NavigationFade(MyQRCode()),
                                );
                              } else {
                                // 管理者であるか
                                if (model.isHost == true) {
                                  // 団体追加
                                  Navigator.push(
                                    context,
                                    setting_data.NavigationFade(
                                        AddInstituteHome(model.community)),
                                  ).then((value) {
                                    model.fechUser();
                                  });
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return ErrorModal(
                                          error_message: "団体が存在していません");
                                    },
                                  );
                                }
                              }
                            } else {
                              // ユーザ登録・ログイン
                              Navigator.push(
                                context,
                                setting_data.NavigationFade(LoginPage()),
                              );
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          "入館する",
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: ElevatedButton(
                          child: Icon(
                            Icons.dashboard,
                            size: 60,
                          ),
                          style: ElevatedButton.styleFrom(
                            alignment: Alignment.center,
                            primary: Color.fromARGB(255, 240, 130, 41),
                            onPrimary: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            if (FirebaseAuth.instance.currentUser != null) {
                              if (model.isHost == true) {
                                if (model.isCommunity == true) {
                                  Navigator.push(
                                    context,
                                    setting_data.NavigationFade(
                                        ManagementHome()),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    setting_data.NavigationFade(
                                        AddInstituteHome(model.community)),
                                  ).then((value) {
                                    model.fechUser();
                                  });
                                }
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return ErrorModal(
                                        error_message: "管理者権限がありません");
                                  },
                                );
                              }
                            } else {
                              // ユーザ登録・ログイン
                              Navigator.push(
                                context,
                                setting_data.NavigationFade(LoginPage()),
                              );
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          "管理する",
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  // menuのListView
  ListTile menuListTile(BuildContext context, String text, dynamic page_name) {
    return ListTile(
      title: Text(text),
      onTap: () {
        Navigator.push(
          context,
          setting_data.NavigationFade(page_name),
        );
      },
    );
  }

  /// 問い合わせフォーム
  Future _launchURL(String url, String secondUrl) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else if (secondUrl != null && await canLaunch(secondUrl)) {
      await launch(secondUrl);
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return ErrorModal(error_message: "AppStoreからお問合わせください");
        },
      );
    }
  }
}
