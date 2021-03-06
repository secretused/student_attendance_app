import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import 'package:vibration/vibration.dart';

import 'management_home.dart';
import 'authentication/login_user.dart';
import 'mypage/my_model.dart';
import 'mypage/my_page.dart';
import 'add_institute/add_community.dart';
import 'scan_qr_code/qr_code.dart';
import 'option/usage.dart';
import 'setting.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
    (_) {
      runApp(const MyApp());
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      // localeに英語と日本語を登録する
      supportedLocales: [
        const Locale("en"),
        const Locale("ja"),
      ],
      // アプリのlocaleを日本語に変更する
      locale: Locale('ja', 'JP'),
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

  final privacy_policy_url =
      'https://qiita.com/utasan_com/private/ffebc0e73b8bae704306';
  final url = 'https://twitter.com/uta_app_vta';
  final secondUrl = 'https://qiita.com/utasan_com';

  SettingClass setting_data = SettingClass();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MyModel>(
      create: (_) => MyModel()..fechUser(),
      child: Consumer<MyModel>(builder: (context, model, child) {
        model.fechUser();
        late bool? isHost = model.isHost;
        late bool? isCommunity = model.isCommunity;
        return Scaffold(
          // メニュードロワー
          drawer: Drawer(
            child: ListView(
              children: [
                const DrawerHeader(
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
                ListTile(
                    title: const Text("プライバシーポリシー"),
                    onTap: () => _privacyURL(privacy_policy_url)),
                ListTile(
                    title: const Text("お問い合わせ・ご意見"),
                    onTap: () => _launchURL(url, secondUrl)),
                ListTile(
                  title: const Text("ライセンス情報"),
                  onTap: () => showLicensePage(
                    context: context,
                    applicationName: 'シュッ席',
                    applicationVersion: '1.2.1',
                  ),
                ),
              ],
            ),
          ),
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              widget.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: const Color.fromARGB(255, 67, 176, 190),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.person),
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
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: ElevatedButton(
                          child: const Icon(
                            Icons.credit_card,
                            size: 60,
                          ),
                          style: ElevatedButton.styleFrom(
                            alignment: Alignment.center,
                            primary: const Color.fromARGB(255, 51, 166, 243),
                            onPrimary: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () async {
                            model.fechUser();
                            if (FirebaseAuth.instance.currentUser != null) {
                              // 団体の有無
                              if (isCommunity == true) {
                                var result = await Navigator.push(
                                  context,
                                  setting_data.NavigationFade(MyQRCode()),
                                );
                                if (result != false) {
                                  Vibration.vibrate();
                                  const attendanceMessage = "入館しました";
                                  const snackBar = SnackBar(
                                    backgroundColor:
                                        Color.fromARGB(255, 67, 176, 190),
                                    content: Text(
                                      attendanceMessage,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                } else {}
                              } else {
                                // 管理者であるか
                                if (isHost == true) {
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
                                      return const ErrorModal(
                                          error_message:
                                              "団体が存在していません\n管理者は団体を登録してください");
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
                      const Padding(
                        padding: EdgeInsets.only(top: 10),
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
                          child: const Icon(
                            Icons.dashboard,
                            size: 60,
                          ),
                          style: ElevatedButton.styleFrom(
                            alignment: Alignment.center,
                            primary: const Color.fromARGB(255, 240, 130, 41),
                            onPrimary: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            model.fechUser();
                            if (FirebaseAuth.instance.currentUser != null) {
                              if (isHost == true) {
                                if (isCommunity == true) {
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
                                    return const ErrorModal(
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
                      const Padding(
                        padding: EdgeInsets.only(top: 10),
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
              Padding(
                padding: const EdgeInsets.only(top: 25.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 100,
                      height: 100,
                      child: ElevatedButton(
                        child: const Icon(
                          Icons.add_business,
                          size: 60,
                        ),
                        style: ElevatedButton.styleFrom(
                          alignment: Alignment.center,
                          primary: const Color.fromARGB(255, 61, 214, 125),
                          onPrimary: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () async {
                          model.fechUser();
                          if (FirebaseAuth.instance.currentUser != null) {
                            // 管理者であるか
                            if (isHost == true) {
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
                                  return const ErrorModal(
                                      error_message:
                                          "団体が存在していません\n管理者は団体を登録してください");
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
                    const Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Text(
                        "団体登録",
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
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

  /// PrivacyPolicy
  Future _privacyURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const ErrorModal(error_message: "問い合わせ先で詳細を\nご確認ください");
        },
      );
    }
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
          return const ErrorModal(error_message: "AppStoreから\nお問合わせください");
        },
      );
    }
  }
}
