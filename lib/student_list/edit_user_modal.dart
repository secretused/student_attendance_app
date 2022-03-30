import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../edit_profile/edit_proflie_page.dart';
import '../setting.dart';
import 'detail_user.dart';

class UserEditModal extends StatefulWidget {
  String? uid;
  bool? nowHost;
  bool? fromUserList;
  UserEditModal(String? uid, bool? nowHost, bool fromUserList) {
    this.uid = uid;
    // UserListからかMyPageからか見極め
    this.nowHost = nowHost;
    // UserListからかSelectDateからか見極め
    this.fromUserList = fromUserList;
  }

  @override
  State<StatefulWidget> createState() {
    return UserEditModalHome();
  }
}

// 絞り込みモーダル
class UserEditModalHome extends State<UserEditModal> {
  SettingClass setting_data = SettingClass();
  late bool isCurrentUser = false;
  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height;
    return ChangeNotifierProvider<DetailUser>(
      create: (_) => DetailUser()..getUser(widget.uid),
      child: Dialog(
        insetPadding: const EdgeInsets.all(0),
        elevation: 0,
        child: ConstrainedBox(
          constraints: BoxConstraints.expand(
              width: deviceWidth * 3 / 4, height: deviceHeight / 4),
          child: Stack(alignment: Alignment.center, children: [
            Consumer<DetailUser>(
              builder: (context, model, child) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      (model.isHost == true)
                          ? Text(
                              "管理者",
                              style: TextStyle(
                                fontSize: 11,
                                backgroundColor:
                                    Color.fromARGB(255, 255, 255, 0),
                              ),
                            )
                          : SizedBox(
                              height: 10,
                            ),
                      Text(
                        model.name ?? "名前",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 23),
                      ),
                      SizedBox(
                        height: 1,
                      ),
                      Text(
                        widget.uid ?? "ユーザーID",
                        style: TextStyle(fontSize: 10),
                      ),
                      Text(
                        model.email ?? "メールアドレス",
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          (model.department != "")
                              ? Column(
                                  children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text("${model.department}"),
                                  ],
                                )
                              : const SizedBox.shrink(),
                          (model.grade != "")
                              ? Column(
                                  children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(" ${model.grade}期生"),
                                  ],
                                )
                              : const SizedBox.shrink(),
                        ],
                      ),
                      (model.classroom != "")
                          ? Text("${model.classroom}")
                          : const SizedBox.shrink(),
                      (model.phoneNumber != "")
                          ? Text("${model.phoneNumber}")
                          : const SizedBox.shrink(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          (widget.fromUserList == true)
                              ? SizedBox(
                                  width: 70, //横幅
                                  height: 40, //高さ
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.transparent,
                                      elevation: 0,
                                      onPrimary:
                                          Color.fromARGB(255, 51, 166, 243),
                                    ),
                                    onPressed: () {
                                      // edit_profileに遷移
                                      Navigator.push(
                                        context,
                                        setting_data.NavigationFade(
                                            EditProfilePage(
                                                model.uid!,
                                                model.name!,
                                                model.department!,
                                                model.grade!,
                                                model.classroom!,
                                                model.phoneNumber!,
                                                model.community!,
                                                model.isHost ?? false,
                                                isCurrentUser,
                                                widget.nowHost)),
                                      );
                                    },
                                    child: Text(
                                      '編集',
                                      style: TextStyle(fontSize: 17),
                                    ),
                                  ),
                                )
                              : SizedBox.shrink()
                        ],
                      )
                    ],
                  ),
                );
              },
            )
          ]),
        ),
      ),
    );
  }
}
