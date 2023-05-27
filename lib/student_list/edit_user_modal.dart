import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../edit_profile/edit_proflie_page.dart';
import '../setting.dart';
import 'edit_user_model.dart';

class UserEditModal extends ConsumerStatefulWidget {
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
  _UserEditModalState createState() => _UserEditModalState();
}

// 絞り込みモーダル
class _UserEditModalState extends ConsumerState<UserEditModal> {
  SettingClass settingData = SettingClass();
  late bool isCurrentUser = false;

  bool _isInitial = true;

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height;
    final editUserModel = ref.watch(editUserModelProvider);

    if(_isInitial) {
      editUserModel.getUser(widget.uid);
      _isInitial = false;
    }

    return Dialog(
      insetPadding: const EdgeInsets.all(0),
      elevation: 0,
      child: ConstrainedBox(
        constraints: BoxConstraints.expand(
            width: deviceWidth * 3 / 4, height: deviceHeight / 4),
        child: Stack(alignment: Alignment.center, children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                (editUserModel.isHost == true)
                    ? const Text(
                        "管理者",
                        style: TextStyle(
                          fontSize: 11,
                          backgroundColor: Color.fromARGB(255, 255, 255, 0),
                        ),
                      )
                    : const SizedBox(
                        height: 10,
                      ),
                Text(
                  editUserModel.name ?? "名前",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
                ),
                const SizedBox(
                  height: 1,
                ),
                Text(
                  widget.uid ?? "ユーザーID",
                  style: const TextStyle(fontSize: 10),
                ),
                Text(
                  editUserModel.email ?? "メールアドレス",
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    (editUserModel.department != "")
                        ? Column(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Text("${editUserModel.department}"),
                            ],
                          )
                        : const SizedBox.shrink(),
                    (editUserModel.grade != "")
                        ? Column(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Text(" ${editUserModel.grade}期生"),
                            ],
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
                (editUserModel.classroom != "")
                    ? Text("${editUserModel.classroom}")
                    : const SizedBox.shrink(),
                (editUserModel.phoneNumber != "")
                    ? Text("${editUserModel.phoneNumber}")
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
                                backgroundColor: Colors.transparent,
                                elevation: 0,
                                foregroundColor:
                                    const Color.fromARGB(255, 51, 166, 243),
                              ),
                              onPressed: () {
                                // edit_profileに遷移
                                Navigator.push(
                                  context,
                                  settingData.NavigationFade(EditProfilePage(
                                      editUserModel.uid!,
                                      editUserModel.name!,
                                      editUserModel.department!,
                                      editUserModel.grade!,
                                      editUserModel.classroom!,
                                      editUserModel.phoneNumber!,
                                      editUserModel.community!,
                                      editUserModel.isHost ?? false,
                                      isCurrentUser,
                                      widget.nowHost)),
                                );
                              },
                              child: const Text(
                                '編集',
                                style: TextStyle(fontSize: 17),
                              ),
                            ),
                          )
                        : const SizedBox.shrink()
                  ],
                )
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
