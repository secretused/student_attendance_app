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
                    showDialog<void>(
                      context: context,
                      builder: (_) {
                        return SelectInfo(widget.gotCommunity);
                      },
                    );
                  },
                ),
                visible: showButton,
              ),
            ],
          ),
          body: Container(
            child: StreamBuilder<QuerySnapshot>(
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
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
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
            ),
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
