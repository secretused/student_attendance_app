import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:attendanc_management_app/authentication/login_user.dart';
import 'package:attendanc_management_app/authentication/register_user.dart';

import 'management_home.dart';
import 'package:attendanc_management_app/mypage/my_page.dart';
import 'package:attendanc_management_app/scan_qr_code/qr_code.dart';

import 'setting.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
    return Scaffold(
      appBar: AppBar(
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
                );
              }
            },
          ),
        ],
      ),
      body: Container(
        // color: Color.fromARGB(255, 223, 198, 135),
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
                          Navigator.push(
                            context,
                            setting_data.NavigationFade(MyQRCode()),
                          );
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
                          Navigator.push(
                            context,
                            setting_data.NavigationFade(ManagementHome()),
                          );
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
  }

  // // ページ遷移(フェードイン)
  // PageRouteBuilder<dynamic> NavigationFade(page_name) {
  //   return PageRouteBuilder(
  //     pageBuilder: (context, animation, secondaryAnimation) {
  //       return page_name;
  //     },
  //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
  //       final double begin = 0.0;
  //       final double end = 5.0;
  //       final Animatable<double> tween = Tween(begin: begin, end: end)
  //           .chain(CurveTween(curve: Curves.easeInOut));
  //       final Animation<double> doubleAnimation = animation.drive(tween);
  //       return FadeTransition(
  //         opacity: doubleAnimation,
  //         child: child,
  //       );
  //     },
  //   );
  // }

  // // ページ遷移(下から上)
  // PageRouteBuilder<dynamic> NavigationButtomSlide(page_name) {
  //   return PageRouteBuilder(
  //     pageBuilder: (context, animation, secondaryAnimation) {
  //       return page_name;
  //     },
  //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
  //       final Offset begin = Offset(0.0, 1.5); // 下から上
  //       // final Offset begin = Offset(0.0, -1.0); // 上から下
  //       final Offset end = Offset.zero;
  //       final Animatable<Offset> tween = Tween(begin: begin, end: end)
  //           .chain(CurveTween(curve: Curves.easeInOut));
  //       final Animation<Offset> offsetAnimation = animation.drive(tween);
  //       return SlideTransition(
  //         position: offsetAnimation,
  //         child: child,
  //       );
  //     },
  //   );
  // }

  // // ページ遷移(右から左)
  // PageRouteBuilder<dynamic> NavigationButtonCutIn(page_name) {
  //   return PageRouteBuilder(
  //     pageBuilder: (context, animation, secondaryAnimation) {
  //       return page_name;
  //     },
  //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
  //       final Offset begin = Offset(1.0, 0.0); // 右から左
  //       // final Offset begin = Offset(-1.0, 0.0); // 左から右
  //       final Offset end = Offset.zero;
  //       final Animatable<Offset> tween = Tween(begin: begin, end: end)
  //           .chain(CurveTween(curve: Curves.easeInOut));
  //       final Animation<Offset> offsetAnimation = animation.drive(tween);
  //       return SlideTransition(
  //         position: offsetAnimation,
  //         child: child,
  //       );
  //     },
  //   );
  // }
}
