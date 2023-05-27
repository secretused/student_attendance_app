import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../setting.dart';
import 'edit_profile_model.dart';

class EditProfilePage extends ConsumerWidget {
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
  String uid;
  final String name;
  final String department;
  final String grade;
  final String classroom;
  final String phoneNumber;
  final String community;
  late bool isHost;
  final bool isCurrentUser;
  final bool? nowHost;
  // bool isLoading = false;
  // bool setIsHost = false;

  final nameController = TextEditingController();
  final departmentController = TextEditingController();
  final gradeController = TextEditingController();
  final classController = TextEditingController();
  final phoneNumController = TextEditingController();

  //最初か監視して、init stateしたい
  bool _isInitial = true;

  void editProfileInitialize(
      String _uid,
      name,
      department,
      grade,
      classroom,
      phoneNumber,
      ) {
    uid = _uid;
    nameController.text = name!;
    departmentController.text = department!;
    gradeController.text = grade!;
    classController.text = classroom!;
    phoneNumController.text = phoneNumber!;
    _isInitial = false;
  }


  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final editProfileModel = ref.watch(editProfileModelProvider);
    bool isLoading = ref.watch(editProfileModelProvider).isLoading;

    if(_isInitial) {
      editProfileInitialize(uid, name, department, grade, classroom, phoneNumber);
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'プロフィール編集',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 67, 176, 190),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  hintText: '名前',
                  suffix: Text('必須',
                      style: TextStyle(color: Colors.red, fontSize: 13)),
                ),
              ),
              TextField(
                controller: departmentController,
                decoration: const InputDecoration(
                  hintText: '部署・学科',
                ),
              ),
              TextField(
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                controller: gradeController,
                decoration: const InputDecoration(
                  hintText: '期生・学年',
                ),
              ),
              TextField(
                controller: classController,
                decoration: const InputDecoration(
                  hintText: 'チーム・クラス',
                ),
              ),
              TextField(
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(11),
                ],
                controller: phoneNumController,
                decoration: const InputDecoration(
                  hintText: '電話番号',
                ),
              ),
              (nowHost == true)
                  ? const SizedBox(
                      height: 10,
                    )
                  : const SizedBox(
                      height: 30,
                    ),
              (nowHost == true)
                  ? Column(
                      children: [
                        (isHost)
                            ? TextButton(
                                onPressed: () async {
                                  var isCancel = await showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (BuildContext context) {
                                      return const ValidaterModal(
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
                                child: const Text(
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
                                      return const ValidaterModal(
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
                                child: const Text(
                                  '管理者権限を有効にする',
                                  style: TextStyle(
                                    fontSize: 15,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 66, 140, 224),
                  foregroundColor: Colors.black,
                ),
                onPressed: () async {
                        // 追加の処理
                        editProfileModel.setHost(isHost);
                        try {
                          editProfileModel.setUid(uid);
                            isLoading = true;
                          await editProfileModel.update(
                              nameController,
                              departmentController,
                              gradeController,
                              classController,
                              phoneNumController);
                          if (editProfileModel.nameNull) {
                              isLoading = false;
                            // ref.watch(editProfileModelProvider).isLoading = false;
                            showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (BuildContext context) {
                                return const ErrorModal(error_message: "名前を入力してください");
                              },
                            );
                          } else {
                            // user一覧からの遷移もあるので二つ前
                            Navigator.popUntil(
                                context, (route) => route.isFirst);
                          }
                        } catch (e) {
                          final snackBar = SnackBar(
                            backgroundColor: const Color.fromARGB(255, 185, 70, 61),
                            content: Text(e.toString()),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          print(e.toString());
                        }
                      },child: const Text('更新する'),

              ),
              (isCurrentUser == true)
                  ? ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        foregroundColor: Colors.red,
                      ),
                      onPressed: () async {
                        var isCancel = await showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (BuildContext context) {
                            return const ValidaterModal(
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
                              return const ValidaterModal(
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
                                uid, community);
                            Navigator.popUntil(
                                context, (route) => route.isFirst);
                          }
                        }
                      },
                      child: const Text(
                        'アカウント削除',
                        style: TextStyle(
                          fontSize: 15,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
              CircleLoadingAction(visible: isLoading)
            ],
          ),
        ),
      ),
    );
  }
}
