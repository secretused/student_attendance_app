import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../setting.dart';
import 'picker_list.dart';
import 'picker_modal.dart';

class SelectDateHome extends StatefulWidget {
  String? gotCommunity;
  SelectDateHome(String? community) {
    this.gotCommunity = community;
  }

  @override
  State<StatefulWidget> createState() {
    return SelectDate();
  }
}

class SelectDate extends State<SelectDateHome> {
  var _labelText = '日付選択';

  final setting_date = SettingClass();
  late bool showButton = false;

  String? _selectedValue; //渡されてきた2つ目の値
  late int _selectedIndex; //渡されてきた1つ目のindex
  String? _selectedField; //Firebaseの表記
  bool _isValue = false; //値が戻ってきたのか初期画面なのか判断

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PickerModel>(
      create: (_) => PickerModel(widget.gotCommunity),
      child: Consumer<PickerModel>(builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              _labelText,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: Color.fromARGB(255, 67, 176, 190),
            actions: <Widget>[
              Visibility(
                child: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () async {
                    // 絞り込みモーダル表示
                    model.getChildData();
                    // 2個目のPickerで返ってきた値を格納
                    List? pickerSelectedValue = await showDialog<List?>(
                      context: context,
                      builder: (_) {
                        return SelectInfo(widget.gotCommunity);
                      },
                    );
                    // 戻るボタンではなく選択されて返ってきた場合
                    if (pickerSelectedValue != null) {
                      _selectedIndex = pickerSelectedValue[0];
                      setState(() {
                        _isValue = true;
                        _selectedField = model.dataBaseList[_selectedIndex];
                        _selectedValue = pickerSelectedValue[1];
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
      }),
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
                  trailing: Text('${data['time']}'),
                ),
              );
            }).toList(),
          );
        },
      );
      // 通常画面
    } else {
      return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('attendances')
            .where("createdAt", isEqualTo: _labelText)
            .where("community", isEqualTo: widget.gotCommunity)
            // .where(_selectedField!, isEqualTo: _selectedValue)
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
                  trailing: Text('${data['time']}'),
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
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime(2023),
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
