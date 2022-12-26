import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart';

import '../setting.dart';
import 'edit_profile_model.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  @override
  EditProfilePage(
      this.uid,
      this.name,
      this.department,
      this.grade,
      this.classroom,
      this.phoneNumber,
      this.community,
      this.isHost,
      this.isCurrentUser,
      this.nowHost);
  final String uid;
  final String name;
  final String department;
  final String grade;
  final String classroom;
  final String phoneNumber;
  final String community;
  late bool isHost;
  final bool isCurrentUser;
  final bool? nowHost;

  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  bool isLoading = false;
  bool setIsHost = false;


  @override
  Widget build(BuildContext context) {
    final editProfileModel = ref.watch(editProfileModelProvider);
    editProfileModel.editProfileModel(
        widget.uid,
        widget.name,
        widget.department,
        widget.grade,
        widget.classroom,
        widget.phoneNumber);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'プロフィール編集',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color.fromARGB(255, 67, 176, 190),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                controller: editProfileModel.nameController,
                decoration: InputDecoration(
                  hintText: '名前',
                  suffix: Text('必須',
                      style: TextStyle(color: Colors.red, fontSize: 13)),
                ),
                onChanged: (text) {
                  editProfileModel.setName(text);
                },
              ),
              TextField(
                controller: editProfileModel.departmentController,
                decoration: InputDecoration(
                  hintText: '部署・学科',
                ),
                onChanged: (text) {
                  editProfileModel.setDepartment(text);
                },
              ),
              TextField(
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                controller: editProfileModel.gradeController,
                decoration: InputDecoration(
                  hintText: '期生・学年',
                ),
                onChanged: (text) {
                  editProfileModel.setGrade(text);
                },
              ),
              TextField(
                controller: editProfileModel.classController,
                decoration: InputDecoration(
                  hintText: 'チーム・クラス',
                ),
                onChanged: (text) {
                  editProfileModel.setClass(text);
                },
              ),
              TextField(
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(11),
                ],
                controller: editProfileModel.phoneNumController,
                decoration: InputDecoration(
                  hintText: '電話番号',
                ),
                onChanged: (text) {
                  editProfileModel.setPhoneNumber(text);
                },
              ),
              (widget.nowHost == true)
                  ? SizedBox(
                      height: 10,
                    )
                  : SizedBox(
                      height: 30,
                    ),
              (widget.nowHost == true)
                  ? Column(
                      children: [
                        (widget.isHost)
                            ? TextButton(
                                onPressed: () async {
                                  var isCancel = await showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (BuildContext context) {
                                      return ValidaterModal(
                                        title: "確認画面",
                                        validate_message: "本当に管理者権限を\n無効にしますか？",
                                        validate_button: "OK",
                                        colors: Colors.lightBlue,
                                        validate_cancel: "キャンセル",
                                      );
                                    },
                                  );
                                  if (isCancel != true) {
                                    editProfileModel.setHost(false);
                                    editProfileModel.changeHost();
                                    Navigator.popUntil(
                                        context, (route) => route.isFirst);
                                  }
                                },
                                child: Text(
                                  '管理者権限を無効にする',
                                  style: TextStyle(
                                    fontSize: 15,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              )
                            : TextButton(
                                onPressed: () async {
                                  var isCancel = await showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (BuildContext context) {
                                      return ValidaterModal(
                                        title: "確認画面",
                                        validate_message: "本当に管理者権限を\n有効にしますか？",
                                        validate_button: "OK",
                                        colors: Colors.lightBlue,
                                        validate_cancel: "キャンセル",
                                      );
                                    },
                                  );
                                  if (isCancel != true) {
                                    editProfileModel.setHost(true);
                                    editProfileModel.changeHost();
                                    Navigator.popUntil(
                                        context, (route) => route.isFirst);
                                  }
                                },
                                child: Text(
                                  '管理者権限を有効にする',
                                  style: TextStyle(
                                    fontSize: 15,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 66, 140, 224),
                  foregroundColor: Colors.black,
                ),
                onPressed: editProfileModel.isUpdated()
                    ? () async {
                        // 追加の処理
                        editProfileModel.setHost(widget.isHost);
                        try {
                          setState(() {
                            isLoading = true;
                          });
                          await editProfileModel.update();
                          if (editProfileModel.nameNull) {
                            setState(() {
                              isLoading = false;
                            });
                            showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (BuildContext context) {
                                return ErrorModal(error_message: "名前を入力してください");
                              },
                            );
                          } else {
                            // user一覧からの遷移もあるので二つ前
                            Navigator.popUntil(
                                context, (route) => route.isFirst);
                          }
                        } catch (e) {
                          final snackBar = SnackBar(
                            backgroundColor: Color.fromARGB(255, 185, 70, 61),
                            content: Text(e.toString()),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      }
                    : null,
                child: Text('更新する'),
              ),
              (widget.isCurrentUser == true)
                  ? ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.transparent,
                        elevation: 0,
                        onPrimary: Colors.red,
                      ),
                      onPressed: () async {
                        var isCancel = await showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (BuildContext context) {
                            return ValidaterModal(
                              title: "確認画面",
                              validate_message: "アカウントを削除します\n削除しますか？",
                              validate_button: "削除",
                              colors: Colors.red,
                              validate_cancel: "キャンセル",
                            );
                          },
                        );
                        if (isCancel != true) {
                          var isCancel = await showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (BuildContext context) {
                              return ValidaterModal(
                                title: "削除画面",
                                validate_message:
                                    "全ての記録データが削除されます\n復元は不可能です\n本当に削除しますか？",
                                validate_button: "削除",
                                colors: Colors.red,
                                validate_cancel: "キャンセル",
                              );
                            },
                          );
                          if (isCancel != true) {
                            editProfileModel.deleteUser(
                                widget.uid, widget.community);
                            Navigator.popUntil(
                                context, (route) => route.isFirst);
                          }
                        }
                      },
                      child: Text(
                        'アカウント削除',
                        style: TextStyle(
                          fontSize: 15,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
              CirculeLoadingAction(visible: isLoading)
            ],
          ),
        ),
      ),
    );
  }
}
