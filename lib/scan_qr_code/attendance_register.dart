import 'package:attendanc_management_app/scan_qr_code/qr_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../add_institute/add_community.dart';
import '../mypage/my_model.dart';
import '../setting.dart';

class AttendaveRegister extends StatelessWidget {
  SettingClass setting_data = SettingClass();

  String? uid;
  String? email;
  String? name;
  String? attendance;
  String? community;
  String? createdAt = DateFormat('MM-dd HH:mm').format(DateTime.now());
  final currentUser = FirebaseAuth.instance.currentUser;

  String? sameCommunity;
  bool? isHost;

  AttendaveRegister(String? community, bool? isHost) {
    this.community = community;
    this.isHost = isHost;
  }

  @override
  Widget build(BuildContext context) {
    this.uid = currentUser!.uid;
    this.email = currentUser!.email;
    this.name = currentUser!.displayName;
    this.attendance = "出席";

    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height;
    return ChangeNotifierProvider<QRModel>(
      create: (_) => QRModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "出席登録",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Color.fromARGB(255, 67, 176, 190),
        ),
        body: Center(
          child: Container(
            height: deviceHeight * 0.5,
            width: double.infinity,
            child: Consumer<QRModel>(builder: (context, model, child) {
              return Stack(children: [
                Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: deviceHeight * 0.275,
                            width: deviceWidth * 0.75,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                            ),
                            child: Column(children: [
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "ユーザー情報",
                                style: TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "$name",
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                              Text(
                                "$email",
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              Text(
                                "$community",
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                "$createdAt",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "$attendance",
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ]),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 35,
                      ),
                      Text("上記内容で出席しますか？"),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Color.fromARGB(255, 66, 140, 224),
                          onPrimary: Colors.black,
                        ),
                        onPressed: () async {
                          model.startLoading();
                          model.setName(name!);
                          model.setUid(uid!);
                          model.setCommunity(community!);

                          FirebaseFirestore.instance
                              .collection('community')
                              .doc(community)
                              .snapshots()
                              .listen((DocumentSnapshot snapshot) {
                            this.sameCommunity = snapshot.get('community');
                          });
                          // 追加の処理
                          if (sameCommunity != null) {
                            try {
                              await model.atendding();
                              Navigator.popUntil(
                                  context, (route) => route.isFirst);
                            } catch (e) {
                              final snackBar = SnackBar(
                                backgroundColor: Colors.red,
                                content: Text(e.toString()),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            } finally {
                              model.endLoading();
                            }
                          } else {
                            if (isHost == true) {
                              await Navigator.push(
                                context,
                                setting_data.NavigationFade(
                                    AddInstitute(community)),
                              );
                            }
                          }
                        },
                        child: Text('出席する'),
                      ),
                    ],
                  ),
                ),
              ]);
            }),
          ),
        ),
      ),
    );
  }
}
