import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../setting.dart';
import 'my_model.dart';
import 'package:attendanc_management_app/edit_profile/edit_proflie_page.dart';

class MyPage extends StatelessWidget {
  SettingClass setting_data = SettingClass();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MyModel>(
      create: (_) => MyModel()..fechUser(),
      child: Scaffold(
        appBar: AppBar(
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
                        model.community!)),
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
                        Text(
                          model.name ?? "名前なし",
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 35,
                          ),
                        ),
                        Text(
                          "ID:${model.uid}",
                          style: TextStyle(
                            fontSize: 13,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          model.email ?? "メールアドレスなし",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          model.community ?? "コミュニティなし",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              model.department ?? "学部なし",
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              model.grade ?? "学年なし",
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          model.classroom ?? "入力なし",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
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
