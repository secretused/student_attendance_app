import 'package:attendanc_management_app/edit_profile/edit_profile_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'edit_institute_model.dart';

class EditInstitutePage extends StatelessWidget {
  String? communityName;
  String? department;
  String? email;
  String? phoneNumber;
  String? link;
  String? QRLink;

  EditInstitutePage(
    String? communityName,
    String? department,
    String? email,
    String? phoneNumber,
    String? link,
    String? QRLink,
  ) {
    this.communityName = communityName;
    this.department = department;
    this.email = email;
    this.phoneNumber = phoneNumber;
    this.link = link;
    this.QRLink = QRLink;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EditInstituteModel>(
      create: (_) => EditInstituteModel(
          communityName, department, email, phoneNumber, link, QRLink),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            '団体情報変更',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Color.fromARGB(255, 67, 176, 190),
        ),
        body: Center(
          child: Consumer<EditInstituteModel>(builder: (context, model, child) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextField(
                    controller: model.communityController,
                    decoration: InputDecoration(
                      hintText: '名前',
                    ),
                    onChanged: (text) {
                      model.setCommunity(text);
                    },
                  ),
                  TextField(
                    controller: model.departmentController,
                    decoration: InputDecoration(
                      hintText: '名前',
                    ),
                    onChanged: (text) {
                      model.setDepartment(text);
                    },
                  ),
                  TextField(
                    controller: model.emailController,
                    decoration: InputDecoration(
                      hintText: '名前',
                    ),
                    onChanged: (text) {
                      model.setEmail(text);
                    },
                  ),
                  TextField(
                    controller: model.phoneNumberController,
                    decoration: InputDecoration(
                      hintText: '名前',
                    ),
                    onChanged: (text) {
                      model.setPhoneNumber(text);
                    },
                  ),
                  TextField(
                    controller: model.linkController,
                    decoration: InputDecoration(
                      hintText: '関連リンク',
                    ),
                    onChanged: (text) {
                      model.setLink(text);
                    },
                  ),
                  TextField(
                    controller: model.QRLinkController,
                    decoration: InputDecoration(
                      hintText: '名前',
                    ),
                    onChanged: (text) {
                      model.setQRLink(text);
                    },
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(255, 66, 140, 224),
                      onPrimary: Colors.black,
                    ),
                    // 団体を削除する処理が必要
                    onPressed: () {},
                    // model.isUpdated()
                    //     ? () async {
                    //         // 追加の処理
                    //         try {
                    //           await model.update();
                    //           Navigator.of(context).pop(model.name);
                    //         } catch (e) {
                    //           final snackBar = SnackBar(
                    //             backgroundColor: Colors.red,
                    //             content: Text(e.toString()),
                    //           );
                    //           ScaffoldMessenger.of(context)
                    //               .showSnackBar(snackBar);
                    //         }
                    //       }
                    //     : null,
                    child: Text('更新する'),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
