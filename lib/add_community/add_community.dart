import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'community_model.dart';
import '../setting.dart';

class AddCommunity extends ConsumerStatefulWidget {
  String? community;
  AddCommunity(String? community, {Key? key}) : super(key: key) {
    community = community;
  }

  @override
  _AddCommunityState createState() => _AddCommunityState();
}

class _AddCommunityState extends ConsumerState<AddCommunity> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    //モデルを参照できるようにする
    final communityModel = ref.watch(communityModelProvider);
    communityModel.communityModel(widget.community);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          '団体登録',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 67, 176, 190),
      ),
      body: Center(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextField(
                    controller: communityModel.communityController,
                    enabled: false,
                    decoration: InputDecoration(
                      hintText: widget.community,
                    ),
                  ),
                  TextField(
                    controller: communityModel.departmentController,
                    decoration: const InputDecoration(
                      hintText: '支店・部署名',
                    ),
                    onChanged: (text) {
                      communityModel.setDepartment(text);
                    },
                  ),
                  TextField(
                    controller: communityModel.emailController,
                    decoration: const InputDecoration(
                      hintText: 'メールアドレス',
                    ),
                    onChanged: (text) {
                      communityModel.setEmail(text);
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'[a-zA-Z0-9.@_-]')),
                    ],
                  ),
                  TextField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    controller: communityModel.phoneNumberController,
                    decoration: const InputDecoration(
                      hintText: '電話番号',
                    ),
                    onChanged: (text) {
                      communityModel.setPhoneNumber(text);
                    },
                  ),
                  TextField(
                    controller: communityModel.linkController,
                    decoration: const InputDecoration(
                      hintText: '関連リンク',
                    ),
                    onChanged: (text) {
                      communityModel.setLink(text);
                    },
                  ),
                  TextField(
                    controller: communityModel.qrLinkController,
                    decoration: const InputDecoration(
                      hintText: 'QRコード読み取り先リンク *',
                    ),
                    onChanged: (text) {
                      communityModel.setQRLink(text);
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 66, 140, 224),
                      foregroundColor: Colors.black,
                    ),
                    onPressed: () async {
                      // 追加の処理
                      try {
                        await communityModel.addCommunity();
                        if (communityModel.error != true) {
                          if (communityModel.qrLink!.isNotEmpty) {
                            var isCancel = await showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (BuildContext context) {
                                return const ValidaterModal(
                                  title: "確認画面",
                                  validate_message: "この内容で登録しますか？",
                                  validate_button: "登録",
                                  colors: Colors.lightBlue,
                                  validate_cancel: "キャンセル",
                                );
                              },
                            );
                            if (isCancel != true) {
                              setState(() {
                                isLoading = true;
                              });
                              communityModel.addInstitute();
                              Navigator.pop(context);
                            }
                          } else {
                            showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (BuildContext context) {
                                return const ErrorModal(
                                    error_message: "QRリンクを入力してください");
                              },
                            );
                          }
                        } else {
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (BuildContext context) {
                              return const ErrorModal(
                                  error_message:
                                      "既にこの団体は存在しています\n他の団体名でログインしてください");
                            },
                          );
                        }
                      } catch (e) {
                        final snackBar = SnackBar(
                          backgroundColor: Colors.red,
                          content: Text(e.toString()),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                    child: const Text('登録する'),
                  ),
                  CircleLoadingAction(visible: isLoading)
                ],
              ),
            ),
            if (communityModel.isLoading)
              Container(
                color: Colors.black54,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
