import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'picker_list.dart';

class SelectInfo extends StatefulWidget {
  String? gotCommunity;
  SelectInfo(String? gotCommunity) {
    this.gotCommunity = gotCommunity;
  }

  @override
  State<StatefulWidget> createState() {
    return SelectInfoHome();
  }
}

// 絞り込みモーダル
class SelectInfoHome extends State<SelectInfo> {
  String? _selectedParent;
  String? _selectedParentValue;
  String? _selectedChild;
  String? _selectedChildValue;
  int? _selectedIndex;

  int count = 0;
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height;
    return ChangeNotifierProvider<PickerModel>(
      create: (_) => PickerModel(widget.gotCommunity),
      child: Dialog(
        insetPadding: const EdgeInsets.all(0),
        elevation: 0,
        child: ConstrainedBox(
          constraints: BoxConstraints.expand(
              width: deviceWidth * 3 / 4, height: deviceHeight / 4),
          child: Stack(alignment: Alignment.center, children: [
            Consumer<PickerModel>(
              builder: (context, model, child) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(
                        "絞り込み",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      SizedBox(
                        width: deviceWidth * 1 / 2,
                        child: ElevatedButton(
                          child: Text(
                            _selectedParentValue ?? "ジャンル",
                            style: TextStyle(color: Colors.black),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            onPrimary: Colors.orange,
                          ),
                          onPressed: () {
                            model.getChildData();
                            selectParentPicker(context);
                          },
                        ),
                      ),
                      Visibility(
                        visible: _visible,
                        child: SizedBox(
                          width: deviceWidth * 1 / 2,
                          child: ElevatedButton(
                            child: const Text(
                              '詳細',
                              style: TextStyle(color: Colors.black),
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                              onPrimary: Colors.orange,
                            ),
                            onPressed: () {
                              // 選択肢2に選択肢1で選ばれたparentのListを渡す
                              selectChildPicker(context,
                                  model.gotParentList?[_selectedIndex! - 1]);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            )
          ]),
        ),
      ),
    );
  }

  // 選択肢1
  Future<dynamic> selectParentPicker(BuildContext context) {
    PickerModel pickerData = PickerModel(widget.gotCommunity);
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height / 3,
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  CupertinoButton(
                    child: Text("戻る"),
                    onPressed: () => Navigator.pop(context),
                  ),
                  CupertinoButton(
                    child: Text("決定"),
                    onPressed: () {
                      setState(() {
                        _selectedParentValue = _selectedParent;
                      });
                      if (_selectedIndex == 0 || _selectedParentValue == null) {
                        Navigator.popUntil(context, (_) => count++ >= 2);
                      } else {
                        _visible = true;
                        Navigator.pop(context);
                      }
                    },
                  ),
                ],
              ),
              Container(
                height: MediaQuery.of(context).size.height / 4,
                child: CupertinoPicker(
                  itemExtent: 40,
                  children: pickerData.parentList
                      .map((title) => Tab(text: title))
                      .toList(),
                  onSelectedItemChanged: _onSelectedParentChanged,
                ),
              )
            ],
          ),
        );
      },
    );
  }

  void _onSelectedParentChanged(int index) {
    PickerModel pickerData = PickerModel(widget.gotCommunity);
    setState(() {
      _selectedParent = pickerData.parentList[index];
      _selectedIndex = index;
    });
  }

  // 選択肢2
  Future<dynamic> selectChildPicker(BuildContext context, List? gotParentList) {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height / 3,
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  CupertinoButton(
                    child: Text("戻る"),
                    onPressed: () => Navigator.pop(context),
                  ),
                  CupertinoButton(
                      child: Text("決定"),
                      onPressed: () {
                        Navigator.popUntil(context, (_) => count++ >= 2);
                        setState(() {
                          if (_selectedChild == null) {
                            // 一つ目かどうか
                            _selectedChildValue = gotParentList![0];
                          } else {
                            _selectedChildValue = _selectedChild;
                          }
                        });
                      }),
                ],
              ),
              Container(
                height: MediaQuery.of(context).size.height / 4,
                child: CupertinoPicker(
                    itemExtent: 40,
                    children: gotParentList!
                        .map((title) => Tab(text: title))
                        .toList(),
                    onSelectedItemChanged: (index) => setState(() {
                          _selectedChild = gotParentList[index];
                        })),
              )
            ],
          ),
        );
      },
    );
  }
}
