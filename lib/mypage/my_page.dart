import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../edit_profile/edit_proflie_page.dart';
import '../setting.dart';
import 'my_model.dart';

class MyPage extends StatelessWidget {
  SettingClass setting_data = SettingClass();
  late bool isCurrentUser = true;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MyModel>(
      create: (_) => MyModel()..fechUser(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'マイページ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Color.fromARGB(255, 67, 176, 190),
          actions: <Widget>[
            Consumer<MyModel>(builder: (context, model, child) {
              return IconButton(
                icon: Icon(Icons.edit),
                onPressed: () async {
                  Navigator.push(
                    context,
                    setting_data.NavigationFade(EditProfilePage(
                        model.uid!,
                        model.name!,
                        model.department!,
                        model.grade!,
                        model.classroom!,
                        model.phoneNumber!,
                        model.community!,
                        model.isHost ?? false,
                        isCurrentUser,
                        model.isHost ?? false)),
                  );
                },
              );
            }),
          ],
        ),
        body: Container(
          child: Center(
            child: Consumer<MyModel>(builder: (context, model, child) {
              return Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        (model.isHost == true)
                            ? Text(
                                "管理者",
                                style: TextStyle(
                                  fontSize: 15,
                                  backgroundColor:
                                      Color.fromARGB(255, 255, 255, 0),
                                ),
                              )
                            : const SizedBox.shrink(),
                        (model.name != "")
                            ? Text(
                                "${model.name}",
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 35,
                                ),
                              )
                            : const SizedBox.shrink(),
                        (model.uid != "")
                            ? Text(
                                "ID:${model.uid}",
                                style: TextStyle(
                                  fontSize: 13,
                                ),
                              )
                            : const SizedBox.shrink(),
                        SizedBox(
                          height: 12,
                        ),
                        (model.email != "")
                            ? Column(
                                children: [
                                  Text(
                                    "メールアドレス",
                                    style: TextStyle(
                                      fontSize: 15,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                  Text(
                                    "${model.email}",
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  )
                                ],
                              )
                            : const SizedBox.shrink(),
                        SizedBox(
                          height: 12,
                        ),
                        (model.community != "")
                            ? Column(
                                children: [
                                  Text(
                                    "団体名",
                                    style: TextStyle(
                                      fontSize: 15,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                  Text(
                                    "${model.community}",
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  )
                                ],
                              )
                            : const SizedBox.shrink(),
                        (model.department != "")
                            ? Column(
                                children: [
                                  SizedBox(
                                    height: 12,
                                  ),
                                  Text(
                                    "部署・学部",
                                    style: TextStyle(
                                      fontSize: 15,
                                      decoration: TextDecoration.underline,
                                    ),
                                  )
                                ],
                              )
                            : const SizedBox.shrink(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            (model.department != "")
                                ? Text(
                                    "${model.department}",
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  )
                                : const SizedBox.shrink(),
                            (model.grade != "")
                                ? Text(
                                    " ${model.grade}期生",
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ],
                        ),
                        (model.classroom != "")
                            ? Column(
                                children: [
                                  SizedBox(
                                    height: 12,
                                  ),
                                  Text(
                                    "クラス",
                                    style: TextStyle(
                                      fontSize: 15,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                  Text(
                                    "${model.classroom}",
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  )
                                ],
                              )
                            : const SizedBox.shrink(),
                        SizedBox(
                          height: 4,
                        ),
                        TextButton(
                            onPressed: () async {
                              await model.logOut();
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              "ログアウト",
                              style: TextStyle(
                                color: Color.fromARGB(255, 66, 140, 224),
                              ),
                            ))
                      ],
                    ),
                  ),
                  if (model.isLoading)
                    Container(
                      color: Colors.black54,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
