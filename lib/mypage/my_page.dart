import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../edit_profile/edit_proflie_page.dart';
import '../setting.dart';
import 'my_model.dart';

class MyPage extends ConsumerWidget {
  SettingClass settingData = SettingClass();
  late bool isCurrentUser = true;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myModel = ref.watch(myModelProvider);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'マイページ',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 67, 176, 190),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              await Navigator.push(
                context,
                settingData.NavigationFade(EditProfilePage(
                    myModel.uid!,
                    myModel.name!,
                    myModel.department!,
                    myModel.grade!,
                    myModel.classroom!,
                    myModel.phoneNumber!,
                    myModel.community!,
                    myModel.isHost ?? false,
                    isCurrentUser,
                    myModel.isHost ?? false)),
              );
              myModel.fetchUser();
            },
          ),
        ],
      ),
      body: Center(
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  (myModel.isHost == true)
                      ? const Text(
                          "管理者",
                          style: TextStyle(
                            fontSize: 15,
                            backgroundColor: Color.fromARGB(255, 255, 255, 0),
                          ),
                        )
                      : const SizedBox.shrink(),
                  (myModel.name != "")
                      ? Text(
                          "${myModel.name}",
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 30,
                          ),
                        )
                      : const SizedBox.shrink(),
                  (myModel.uid != "")
                      ? Text(
                          "ID:${myModel.uid}",
                          style: const TextStyle(
                            fontSize: 13,
                          ),
                        )
                      : const SizedBox.shrink(),
                  const SizedBox(
                    height: 12,
                  ),
                  (myModel.community != "")
                      ? Column(
                          children: [
                            const Text(
                              "団体名",
                              style: TextStyle(
                                fontSize: 15,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            Text(
                              "${myModel.community}",
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                          ],
                        )
                      : const SizedBox.shrink(),
                  (myModel.department != "")
                      ? Column(
                          children: [
                            const Text(
                              "部署・学部",
                              style: TextStyle(
                                fontSize: 15,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            Text(
                              "${myModel.department}",
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                          ],
                        )
                      : const SizedBox.shrink(),
                  (myModel.grade != "")
                      ? Column(
                          children: [
                            const Text(
                              "期生・学年",
                              style: TextStyle(
                                fontSize: 15,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            Text(
                              " ${myModel.grade}期生",
                              style: const TextStyle(
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                          ],
                        )
                      : const SizedBox.shrink(),
                  (myModel.classroom != "")
                      ? Column(
                          children: [
                            const Text(
                              "チーム・クラス",
                              style: TextStyle(
                                fontSize: 15,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            Text(
                              "${myModel.classroom}",
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                          ],
                        )
                      : const SizedBox.shrink(),
                  (myModel.email != "")
                      ? Column(
                          children: [
                            const Text(
                              "メールアドレス",
                              style: TextStyle(
                                fontSize: 15,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            Text(
                              "${myModel.email}",
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(
                              height: 14,
                            ),
                          ],
                        )
                      : const SizedBox.shrink(),
                  (myModel.phoneNumber != "")
                      ? Column(
                          children: [
                            const Text(
                              "電話番号",
                              style: TextStyle(
                                fontSize: 15,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            Text(
                              "${myModel.phoneNumber}",
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            )
                          ],
                        )
                      : const SizedBox.shrink(),
                  const SizedBox(
                    height: 4,
                  ),
                  TextButton(
                      onPressed: () async {
                        await myModel.logOut();
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        "ログアウト",
                        style: TextStyle(
                          color: Color.fromARGB(255, 66, 140, 224),
                        ),
                      ))
                ],
              ),
            ),
            if (myModel.isLoading)
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
