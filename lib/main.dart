import 'package:attendanc_management_app/add_institute/add_community.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:attendanc_management_app/authentication/login_user.dart';
import 'package:provider/provider.dart';

import 'management_home.dart';
import 'package:attendanc_management_app/mypage/my_page.dart';
import 'package:attendanc_management_app/scan_qr_code/qr_code.dart';

import 'mypage/my_model.dart';
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

  SettingClass setting_data = SettingClass();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MyModel>(
      create: (_) => MyModel()..fechUser(),
      child: Consumer<MyModel>(builder: (context, model, child) {
        return Scaffold(
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
}
