import 'package:attendanc_management_app/create_QR/create_QR.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:attendanc_management_app/mypage/my_model.dart';
import 'add_institute/add_community.dart';
import 'change_QR/change_QR.dart';
import 'select_date/select_date.dart';
import 'setting.dart';
import 'student_list/student_list.dart';

class ManagementHome extends StatelessWidget {
  SettingClass setting_data = SettingClass();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MyModel>(
      create: (_) => MyModel()..fechUser(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "管理画面",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: const Color.fromARGB(255, 67, 176, 190),
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          child: Consumer<MyModel>(builder: (context, model, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 40.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ButtonDesign(
                        onPressed: () async {
                          if (model.isHost == true) {
                            await Navigator.push(
                              context,
                              setting_data.NavigationFade(
                                  SelectDateHome(model.community)),
                            );
                          }
                        },
                        backgroundColor:
                            const Color.fromARGB(255, 51, 166, 243),
                        text: "入館管理",
                        icon: const Icon(
                          Icons.home,
                          size: 70,
                        ),
                      ),
                      ButtonDesign(
                        onPressed: () async {
                          if (model.isHost == true) {
                            await Navigator.push(
                              context,
                              setting_data.NavigationFade(StudentListHome(
                                  model.community, model.isHost)),
                            );
                          }
                        },
                        backgroundColor:
                            const Color.fromARGB(255, 240, 130, 41),
                        text: "ユーザー管理",
                        icon: const Icon(
                          Icons.account_circle,
                          size: 70,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ButtonDesign(
                      onPressed: () async {
                        if (model.isHost == true) {
                          await Navigator.push(
                            context,
                            setting_data.NavigationFade(
                                CreateQRCode(model.community)),
                          );
                        }
                      },
                      backgroundColor: const Color.fromARGB(255, 61, 214, 125),
                      text: "QRコード表示",
                      icon: const Icon(
                        Icons.qr_code_2_outlined,
                        size: 70,
                      ),
                    ),
                    ButtonDesign(
                      onPressed: () async {
                        if (model.isHost == true) {
                          await Navigator.push(
                            context,
                            setting_data.NavigationFade(
                                ChangeQRCode(model.community)),
                          );
                        }
                      },
                      backgroundColor: const Color.fromARGB(255, 241, 121, 195),
                      text: "団体情報変更",
                      icon: const Icon(
                        Icons.security,
                        size: 70,
                      ),
                    ),
                  ],
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

class ButtonDesign extends StatelessWidget {
  const ButtonDesign({
    Key? key,
    required this.onPressed,
    required this.backgroundColor,
    required this.text,
    required this.icon,
  }) : super(key: key);

  final GestureTapCallback onPressed; //変数を宣言
  final Color backgroundColor;
  final String text;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 100,
          height: 100,
          child: ElevatedButton(
            child: icon,
            style: ElevatedButton.styleFrom(
              alignment: Alignment.center,
              primary: backgroundColor,
              onPrimary: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: onPressed,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 15,
            ),
          ),
        ),
      ],
    );
  }
}
