import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../setting.dart';
import 'edit_community_model.dart';

class EditCommunityPage extends ConsumerStatefulWidget {
  String? communityName;
  String? department;
  String? email;
  String? phoneNumber;
  String? link;
  String? qrLink;
  EditCommunityPage(
    String? communityName,
    String? department,
    String? email,
    String? phoneNumber,
    String? link,
    String? qrLink,
  ) {
    this.communityName = communityName;
    this.department = department;
    this.email = email;
    this.phoneNumber = phoneNumber;
    this.link = link;
    this.qrLink = qrLink;
  }

  @override
  _EditInstitutePageState createState() => _EditInstitutePageState();
}

class _EditInstitutePageState extends ConsumerState<EditCommunityPage> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final editInstituteModel = ref.watch(editInstituteModelProvider);
    editInstituteModel.editInstituteModel(
        widget.communityName,
        widget.department,
        widget.email,
        widget.phoneNumber,
        widget.link,
        widget.qrLink);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          '団体情報変更',
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
                controller: editInstituteModel.communityController,
                decoration: const InputDecoration(
                  hintText: '団体名',
                  suffix: Text('必須',
                      style: TextStyle(color: Colors.red, fontSize: 13)),
                ),
                onChanged: (text) {
                  editInstituteModel.setCommunity(text);
                },
              ),
              TextField(
                controller: editInstituteModel.departmentController,
                decoration: const InputDecoration(
                  hintText: '支店・部署名',
                ),
                onChanged: (text) {
                  editInstituteModel.setDepartment(text);
                },
              ),
              TextField(
                controller: editInstituteModel.emailController,
                decoration: const InputDecoration(
                  hintText: 'メールアドレス',
                ),
                onChanged: (text) {
                  editInstituteModel.setEmail(text);
                },
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9.@_-]')),
                ],
              ),
              TextField(
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                controller: editInstituteModel.phoneNumberController,
                decoration: const InputDecoration(
                  hintText: '電話番号',
                ),
                onChanged: (text) {
                  editInstituteModel.setPhoneNumber(text);
                },
              ),
              TextField(
                controller: editInstituteModel.linkController,
                decoration: const InputDecoration(
                  hintText: '関連リンク',
                ),
                onChanged: (text) {
                  editInstituteModel.setLink(text);
                },
              ),
              TextField(
                controller: editInstituteModel.qrLinkController,
                decoration: const InputDecoration(
                  hintText: 'QRコード読み取り先リンク',
                  suffix: Text('必須',
                      style: TextStyle(color: Colors.red, fontSize: 13)),
                ),
                onChanged: (text) {
                  editInstituteModel.setQrLink(text);
                },
              ),
              const SizedBox(
                height: 24,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 66, 140, 224),
                  foregroundColor: Colors.black,
                ),
                onPressed: editInstituteModel.isUpdated()
                    ? () async {
                        // ローディング開始
                        setState(() {
                          isLoading = true;
                        });
                        try {
                          // ローディング処理
                          await editInstituteModel.update();
                          if (editInstituteModel.sameName == true) {
                            // 1-1
                            setState(() {
                              isLoading = false;
                            });

                            showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (BuildContext context) {
                                return const ErrorModal(
                                    error_message:
                                        "既にこの団体は存在しています\n他の団体名を設定してください");
                              },
                            );
                          } else {
                            //  1-2-E(あるかも)
                            if (editInstituteModel.qrLink!.isEmpty) {
                              // 2-1
                              setState(() {
                                isLoading = false;
                              });
                              showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (BuildContext context) {
                                  return const ErrorModal(
                                      error_message: "QRリンクが入力されていません");
                                },
                              );
                            } else if (editInstituteModel.changeInstituteName ==
                                true) {
                              //  1-2
                              setState(() {
                                isLoading = false;
                              });
                              var isCancel = await showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (BuildContext context) {
                                  return const ValidaterModal(
                                    title: "団体名称変更",
                                    validate_message:
                                        "全てのユーザー情報が変更されます\n本当に団体情報を変更しますか？",
                                    validate_button: "変更",
                                    colors: Colors.lightBlue,
                                    validate_cancel: "キャンセル",
                                  );
                                },
                              );
                              if (isCancel != true) {
                                editInstituteModel.changeInstitute();
                                Navigator.popUntil(
                                    context, (route) => route.isFirst);
                              }
                            } else {
                              setState(() {
                                isLoading = false;
                              });
                              // 2-2
                              var isCancel = await showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (BuildContext context) {
                                  return const ValidaterModal(
                                    title: "確認画面",
                                    validate_message: "団体情報を変更しますか？",
                                    validate_button: "変更",
                                    colors: Colors.lightBlue,
                                    validate_cancel: "キャンセル",
                                  );
                                },
                              );
                              if (isCancel != true) {
                                editInstituteModel.updateInstitute();
                                Navigator.popUntil(
                                    context, (route) => route.isFirst);
                              }
                            }
                          }
                        } catch (e) {
                          if (editInstituteModel.communityName!.isEmpty) {
                            //  1-2-E
                            setState(() {
                              isLoading = false;
                            });
                            showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (BuildContext context) {
                                return const ErrorModal(
                                    error_message: "団体名が入力されていません");
                              },
                            );
                          } else {
                            final snackBar = SnackBar(
                              backgroundColor: Colors.red,
                              content: Text(e.toString()),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                        }
                      }
                    : null,
                child: const Text('更新する'),
              ),
              // 団体削除
              ElevatedButton(
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
                        validate_message: "この団体を削除します\n削除しますか？",
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
                              "団体と全てのデータが削除されます\n復元は不可能です\n本当に削除しますか？",
                          validate_button: "削除",
                          colors: Colors.red,
                          validate_cancel: "キャンセル",
                        );
                      },
                    );
                    if (isCancel != true) {
                      editInstituteModel.deleteInstitute(widget.communityName);
                      Navigator.popUntil(context, (route) => route.isFirst);
                    }
                  }
                },
                child: const Text(
                  '団体データ削除',
                  style: TextStyle(
                    fontSize: 15,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              CircleLoadingAction(visible: isLoading)
            ],
          ),
        ),
      ),
    );
  }
}
