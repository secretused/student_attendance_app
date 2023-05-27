import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'picker_model.dart';

class PickerDialog extends ConsumerStatefulWidget {
  String? gotCommunity;
  PickerDialog(String? gotCommunity, {Key? key}) : super(key: key) {
    this.gotCommunity = gotCommunity;
  }

  @override
  _PickerDialogState createState() => _PickerDialogState();
}

// 絞り込みモーダル
class _PickerDialogState extends ConsumerState<PickerDialog> {
  String? _selectedParent; //1つ目の選択肢のpicker
  String? _selectedParentValue; //決定された一つ目の選択肢
  String? _selectedChild; //2つ目の選択肢のpicker
  int? _selectedIndex;
  late int pickerOneValue = 1;

  int count = 0;
  bool _visible = false;

  //最初か監視して、init stateしたい
  bool _isInitial = true;

  @override
  Widget build(BuildContext context) {
    late List hostList = ["host"];

    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height;

    final pickerModel = ref.watch(pickerModelProvider);
    
    if(_isInitial) {
      pickerModel.setCommunityName(widget.gotCommunity);
      _isInitial = false;
    }

      return Dialog(
        insetPadding: const EdgeInsets.all(0),
        elevation: 0,
        child: ConstrainedBox(
          constraints: BoxConstraints.expand(
              width: deviceWidth * 3 / 4, height: deviceHeight / 4),
          child: Stack(alignment: Alignment.center, children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      const Text(
                        "絞り込み",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      SizedBox(
                        width: deviceWidth * 1 / 2,
                        child: ElevatedButton(
                          child: Text(
                            _selectedParentValue ?? "選択してください",
                            style: const TextStyle(color: Colors.black),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.orange,
                          ),
                          onPressed: () async {
                            // 自動で詳細のモーダルを表示
                            int? result = await selectParentPicker(
                                context, pickerModel.parentList);
                            late int? hostNumber = pickerModel.parentList?.indexWhere(
                                (parentList) => parentList == "管理者");
                            // 決定が押されたとき && 全てじゃない時
                            if (result != null &&
                                result != 0 &&
                                result != hostNumber) {
                              setState(() {
                                pickerOneValue = result;
                              });
                              // 選択肢2に選択肢1で選ばれたparentのListを渡す
                              // 二つ目の選択肢の値をresultListで受け取る
                              var resultList = await selectChildPicker(
                                  context,
                                  pickerModel.gotParentList?[result - 1],
                                  pickerOneValue);
                              if (resultList.runtimeType == bool) {
                                //戻るの場合: 二個目のpickerはinvisible
                                setState(() {
                                  _visible = resultList;
                                });
                              } else {
                                // 二個目の値が選ばれてリストとして返る
                                // select_dateのStreamBuilderにあげる
                                Navigator.of(context).pop(resultList);
                              }
                            } else if (result == 0) {
                              Navigator.popUntil(context, (_) => count++ >= 2);
                            } else if (result == hostNumber) {
                              Navigator.of(context).pop(hostList);
                            }
                          },
                        ),
                      ),
                      Visibility(
                        visible: _visible,
                        child: SizedBox(
                          width: deviceWidth * 1 / 2,
                          child: ElevatedButton(
                            child: Text(
                              pickerModel.gotParentList?[pickerOneValue - 1][0] ??
                                  "詳細",
                              style: const TextStyle(color: Colors.black),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                            ),
                            onPressed: () {
                              //  押せないため処理なし
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
          ]),
        ),
      );
  }

  // 選択肢1
  Future<dynamic> selectParentPicker(BuildContext context, List? parentList) {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height / 3,
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  CupertinoButton(
                    child: const Text("戻る"),
                    onPressed: () => Navigator.pop(context, null),
                  ),
                  CupertinoButton(
                    child: const Text("決定"),
                    onPressed: () {
                      setState(() {
                        _selectedParentValue = _selectedParent;
                      });
                      if (_selectedIndex == 0 || _selectedParentValue == null) {
                        Navigator.popUntil(context, (_) => count++ >= 2);
                      }
                      // 管理者の場合
                      else if (_selectedIndex == parentList?.last) {
                        Navigator.of(context).pop(_selectedIndex);
                      } else {
                        _visible = true;
                        Navigator.pop(context, _selectedIndex);
                      }
                    },
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 4,
                child: CupertinoPicker(
                  itemExtent: 40,
                  children:
                      parentList!.map((title) => Tab(text: title)).toList(),
                  onSelectedItemChanged: (index) {
                    setState(() {
                      _selectedParent = parentList[index];
                      _selectedIndex = index;
                    });
                  },
                ),
              )
            ],
          ),
        );
      },
    );
  }

  // 選択肢2
  Future<dynamic> selectChildPicker(
      BuildContext context, List? gotParentList, int pickerOneValue) {
    late String? _selectedChildValue;
    // StreamBuilderに渡すリスト
    late List? popList = [];
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height / 3,
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  CupertinoButton(
                    child: const Text("戻る"),
                    onPressed: () => Navigator.pop(context, false),
                  ),
                  CupertinoButton(
                      child: const Text("決定"),
                      onPressed: () {
                        setState(() {
                          if (_selectedChild == null) {
                            // 一つ目かどうか
                            _selectedChildValue = gotParentList![0];
                          } else {
                            _selectedChildValue = _selectedChild;
                          }
                        });

                        popList
                            .addAll([pickerOneValue - 1, _selectedChildValue]);
                        // modalに値を返している
                        Navigator.of(context).pop(popList);
                      }),
                ],
              ),
              SizedBox(
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
