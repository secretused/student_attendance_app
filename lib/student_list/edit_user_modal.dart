import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../edit_profile/edit_proflie_page.dart';
import '../setting.dart';
import 'detail_user.dart';

class UserEditModal extends StatefulWidget {
  String? uid;
  UserEditModal(String? uid) {
    this.uid = uid;
  }

  @override
  State<StatefulWidget> createState() {
    return UserEditModalHome();
  }
}

// 絞り込みモーダル
class UserEditModalHome extends State<UserEditModal> {
  SettingClass setting_data = SettingClass();
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
                      SizedBox(
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
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          (model.department != "")
                              ? Text("${model.department}")
                              : const SizedBox.shrink(),
                          (model.grade != "")
                              ? Text("${model.grade}期生")
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
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.transparent,
                              elevation: 0,
                              onPrimary: Color.fromARGB(255, 51, 166, 243),
                            ),
                            onPressed: () {
                              // edit_profileに遷移
                              Navigator.push(
                                context,
                                setting_data.NavigationFade(EditProfilePage(
                                    model.uid!,
                                    model.name!,
                                    model.department!,
                                    model.grade!,
                                    model.classroom!,
                                    model.phoneNumber!,
                                    model.community!)),
                              );
                            },
                            child: Text(
                              '編集',
                              style: TextStyle(fontSize: 17),
                            ),
                          ),
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
