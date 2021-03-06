import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../add_student/add_student.dart';
import '../select_date/picker_list.dart';
import '../select_date/picker_modal.dart';
import 'edit_user_modal.dart';
import '../setting.dart';

class StudentListHome extends StatefulWidget {
  String? communityName;
  bool? nowHost;
  StudentListHome(String? community, bool? isHost) {
    this.communityName = community;
    this.nowHost = isHost;
  }

  @override
  StudentList createState() => StudentList();
}

class StudentList extends State<StudentListHome> {
  SettingClass setting_data = SettingClass();
  final setting_date = SettingClass();
  late bool showButton = false;

  String? _selectedValue; //渡されてきた2つ目の値
  late int _selectedIndex; //渡されてきた1つ目のindex
  String? _selectedField; //Firebaseの表記
  bool _isValue = false; //値が戻ってきたのか初期画面なのか判断
  bool _isHost = false; //管理者が選ばれた場合

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PickerModel>(
      create: (_) => PickerModel(widget.communityName),
      child: Consumer<PickerModel>(builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: (() {
              if (_selectedValue != null) {
                // 絞り込み(grade以外)
                if (_selectedField != "grade") {
                  return FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(
                      "$_selectedValue",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  );
                } else {
                  // grade
                  return Text(
                    "$_selectedValue",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  );
                }
              } else {
                // 通常
                return Text(
                  "全てのユーザー",
                  style: TextStyle(fontWeight: FontWeight.bold),
                );
              }
            })(),
            backgroundColor: Color.fromARGB(255, 67, 176, 190),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.filter_alt_outlined),
                onPressed: () async {
                  // 絞り込みモーダル表示(情報がない場合はアラート)
                  bool listEmpty = await model.getChildData();
                  if (listEmpty == true) {
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) {
                        return ErrorModal(error_message: "絞り込めるデータがありません");
                      },
                    );
                  } else {
                    // 2個目のPickerで返ってきた値を格納
                    List? pickerSelectedValue = await showDialog<List?>(
                      context: context,
                      builder: (_) {
                        return SelectInfo(widget.communityName);
                      },
                    );

                    if (pickerSelectedValue != null) {
                      if (pickerSelectedValue[0] != "host") {
                        // 絞り込み画面
                        _selectedIndex = pickerSelectedValue[0];
                        setState(() {
                          _isValue = true;
                          _selectedField = model.dataBaseList?[_selectedIndex];
                          _selectedValue = pickerSelectedValue[1];
                        });
                      } else {
                        // 管理者画面
                        setState(() {
                          _isValue = false;
                          _isHost = true;
                          _selectedValue = "管理者";
                        });
                      }
                    } else {
                      // 通常画面
                      setState(() {
                        _isValue = false;
                        _isHost = false;
                        _selectedValue = "全てのユーザー";
                      });
                    }
                  }

                  // 戻るボタンではなく選択されて返ってきた場合
                },
              ),
            ],
          ),
          body: Container(
            // 絞られたのか初期画面なのか判断
            child: checkStreamBuilder(_isValue),
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                setting_data.NavigationButtomSlide(
                    AddMember(widget.communityName)),
              );
            },
          ),
        );
      }),
    );
  }

  Widget checkStreamBuilder(bool isValue) {
    // 絞り込み画面
    if (isValue) {
      return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where("community", isEqualTo: widget.communityName)
            .where(_selectedField!, isEqualTo: _selectedValue)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: const CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }
          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              final data = document.data()! as Map<String, dynamic>;
              return Card(
                child: ListTile(
                  title: Text('${data['name']}'),
                  trailing: (data['isHost'] != true)
                      ? Text('${data['department']}')
                      : Text('管理者'),
                  subtitle: Text('${data['email']}'),
                  onTap: () async {
                    showDialog<List?>(
                      context: context,
                      builder: (_) {
                        return UserEditModal(data['uid'], widget.nowHost, true);
                      },
                    );
                  },
                ),
              );
            }).toList(),
          );
        },
      );
    } else if (_isHost == true) {
      // 管理者画面
      return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where("community", isEqualTo: widget.communityName)
            .where("isHost", isEqualTo: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: const CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }
          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              final data = document.data()! as Map<String, dynamic>;
              return Card(
                child: ListTile(
                  title: Text('${data['name']}'),
                  trailing: (data['isHost'] != true)
                      ? Text('${data['department']}')
                      : Text('管理者'),
                  subtitle: Text('${data['email']}'),
                  onTap: () async {
                    showDialog<List?>(
                      context: context,
                      builder: (_) {
                        return UserEditModal(data['uid'], widget.nowHost, true);
                      },
                    );
                  },
                ),
              );
            }).toList(),
          );
        },
      );
    } else {
      // 通常画面
      return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where("community", isEqualTo: widget.communityName)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: const CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }
          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              final data = document.data()! as Map<String, dynamic>;
              return Card(
                child: ListTile(
                  title: Text('${data['name']}'),
                  trailing: (data['isHost'] != true)
                      ? Text('${data['department']}')
                      : Text('管理者'),
                  subtitle: Text('${data['email']}'),
                  onTap: () async {
                    showDialog<List?>(
                      context: context,
                      builder: (_) {
                        return UserEditModal(data['uid'], widget.nowHost, true);
                      },
                    );
                  },
                ),
              );
            }).toList(),
          );
        },
      );
    }
  }
}
