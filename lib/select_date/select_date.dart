import 'package:attendanc_management_app/select_date/picker_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../student_list/edit_user_modal.dart';
import 'picker_dialog.dart';

class SelectDate extends ConsumerStatefulWidget {
  String? gotCommunity;
  SelectDate(String? community) {
    gotCommunity = community;
  }

  @override
  _SelectDateState createState() => _SelectDateState();
}

class _SelectDateState extends ConsumerState<SelectDate> {
  var _labelText = '日付選択';
  late bool showButton = false;

  String? _selectedValue; //渡されてきた2つ目の値
  late int _selectedIndex; //渡されてきた1つ目のindex
  String? _selectedField; //FireStoreのフィールド名
  bool _isValue = false; //値が戻ってきたのか初期画面なのか判断
  bool _isHost = false; //管理者が選ばれた場合

  bool _isInitial = true;

  @override
  Widget build(BuildContext context) {
    final pickerModel = ref.watch(pickerModelProvider);

    if(_isInitial) {
      pickerModel.setCommunityName(widget.gotCommunity);
      _isInitial = false;
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: (() {
          if (showButton && _selectedValue != null) {
            // 絞り込み(grade以外)
            if (_selectedField != "grade") {
              return FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  "${_labelText.substring(5, 11)}:$_selectedValue",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              );
            } else {
              // grade
              return Text(
                "${_labelText.substring(5, 11)}:$_selectedValue",
                style: TextStyle(fontWeight: FontWeight.bold),
              );
            }
          } else {
            // 通常
            return Text(
              _labelText,
              style: TextStyle(fontWeight: FontWeight.bold),
            );
          }
        })(),
        backgroundColor: Color.fromARGB(255, 67, 176, 190),
        actions: <Widget>[
          Visibility(
            child: IconButton(
              icon: Icon(Icons.filter_alt_outlined),
              onPressed: () async {
                // 絞り込みモーダル表示
                pickerModel.getChildData();
                // 2個目のPickerで返ってきた値を格納
                List? pickerSelectedValue = await showDialog<List?>(
                  context: context,
                  builder: (_) {
                    return PickerDialog(widget.gotCommunity);
                  },
                );
                // 戻るボタンではなく選択されて返ってきた場合
                if (pickerSelectedValue != null) {
                  if (pickerSelectedValue[0] != "host") {
                    // 絞り込み画面
                    _selectedIndex = pickerSelectedValue[0];
                    setState(() {
                      _isValue = true;
                      _selectedField =
                          pickerModel.dataBaseList?[_selectedIndex];
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
                    _selectedValue = "全て";
                  });
                }
              },
            ),
            visible: showButton,
          ),
        ],
      ),
      body: Container(
        // 絞られたのか初期画面なのか判断
        child: checkStreamBuilder(_isValue),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(FontAwesomeIcons.solidCalendarAlt),
        onPressed: () {
          _selectDate(context);
        },
      ),
    );
  }

  Widget checkStreamBuilder(bool isValue) {
    // 絞り込み画面
    if (isValue) {
      return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('attendances')
            .where("createdAt", isEqualTo: _labelText)
            .where("community", isEqualTo: widget.gotCommunity)
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
                  subtitle: Text('${data['email']}'),
                  trailing: Text('${data['time']}'),
                  onTap: () async {
                    showDialog<List?>(
                      context: context,
                      builder: (_) {
                        return UserEditModal(data['uid'], false, false);
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
            .collection('attendances')
            .where("createdAt", isEqualTo: _labelText)
            .where("community", isEqualTo: widget.gotCommunity)
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
                  subtitle: Text('${data['email']}'),
                  trailing: Text('${data['time']}'),
                  onTap: () async {
                    showDialog<List?>(
                      context: context,
                      builder: (_) {
                        return UserEditModal(data['uid'], false, false);
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
            .collection('attendances')
            .where("createdAt", isEqualTo: _labelText)
            .where("community", isEqualTo: widget.gotCommunity)
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
                  subtitle: Text('${data['email']}'),
                  trailing: Text('${data['time']}'),
                  onTap: () async {
                    showDialog<List?>(
                      context: context,
                      builder: (_) {
                        return UserEditModal(data['uid'], false, false);
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

  Future<void> _selectDate(BuildContext context) async {
    late String isList;
    String? createdAt = DateFormat('yyyy').format(DateTime.now());
    int datetime = int.parse(createdAt);
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(datetime - 4),
      lastDate: DateTime(datetime + 1),
    );
    if (selected != null) {
      // 出席データあるか
      _labelText = (DateFormat('yyyy年MM月dd日')).format(selected);
      final getCommunity = await FirebaseFirestore.instance
          .collection('attendances')
          .where("createdAt", isEqualTo: _labelText)
          .where("community", isEqualTo: widget.gotCommunity)
          .get();
      final community_data = getCommunity.docs;
      try {
        community_data.map((data) {
          isList = data["name"];
        }).toList();
        if (isList != null) {
          showButton = true;
        }
      } catch (e) {
        showButton = false;
      }
      setState(() {
        _labelText = _labelText;
        showButton = showButton;
      });
    }
  }
}
