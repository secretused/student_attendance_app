import 'package:attendanc_management_app/scan_qr_code/qr_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../add_community/add_community.dart';
import '../setting.dart';

class ScreenArguments {
  final bool isFirst;
  final bool value;
  ScreenArguments(this.isFirst, this.value);
}

class AttendanceRegister extends ConsumerWidget {
  final navigation = const NavigationSettings();

  String? uid;
  String? email;
  String? name;
  String? attendance;
  String? community;
  String? createdAt = DateFormat('MM-dd HH:mm').format(DateTime.now());
  final currentUser = FirebaseAuth.instance.currentUser;

  String? sameCommunity;
  bool? isHost;
  // 絞り込み用
  String? department;
  String? grade;
  String? classroom;

  AttendanceRegister(String? community, bool? isHost, String? department,
      String? grade, String? classroom, String? sameCommunity) {
    this.community = community;
    this.isHost = isHost;
    this.sameCommunity = sameCommunity;
    this.department = department;
    this.grade = grade;
    this.classroom = classroom;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    uid = currentUser!.uid;
    email = currentUser!.email;
    name = currentUser!.displayName;
    attendance = "入館";

    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height;

    final qrModel = ref.watch(qrModelProvider);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "入館登録",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 67, 176, 190),
      ),
      body: Center(
        child: SizedBox(
          height: deviceHeight * 0.5,
          width: double.infinity,
          child: Stack(
            children: [
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
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              "ユーザー情報",
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              "$name",
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              "$email",
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              "$community",
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              "$createdAt",
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "$attendance",
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ]),
                        ),
                      ],
                    ),
                    const SizedBox(height: 35),
                    const Text("上記内容で入館しますか？"),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 66, 140, 224),
                        foregroundColor: Colors.black,
                      ),
                      onPressed: () async {
                        qrModel.startLoading();
                        qrModel.setName(name!);
                        qrModel.setUid(uid!);
                        qrModel.setDepartment(department!);
                        qrModel.setGrade(grade!);
                        qrModel.setClassRoom(classroom!);
                        qrModel.setCommunity(community!);
                        qrModel.setIsHost(isHost ?? false);
                        // 追加の処理
                        if (sameCommunity != null) {
                          try {
                            await qrModel.attend();
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
                            qrModel.endLoading();
                          }
                        } else {
                          if (isHost == true) {
                            await Navigator.push(
                              context,
                              navigation.navigationFade(AddCommunity(community)),
                            );
                          }
                        }
                      },
                      child: const Text('入館する'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
