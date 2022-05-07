import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PickerModel extends ChangeNotifier {
  String? communityName;
  PickerModel(String? gotCommunity) {
    this.communityName = gotCommunity;
  }

  List? parentList = ["全て"];
  final dataBaseList = ["department", "grade", "classroom"];
  List? gotParentList;

  List? departmentList;
  List? gradeList;
  List? classList;

  List? hostList;

  Future getChildData() async {
    List<DocumentSnapshot> documentList = [];

    final List tempDepartmentList = [];
    final List tempClassList = [];
    final List<int> tempGradeListInt = [];
    final List<String> tempGradeListString = [];
    final List tempParentList = [];

    final department = await FirebaseFirestore.instance
        .collection('users')
        .where("community", isEqualTo: communityName)
        .get();
    documentList = department.docs;

    documentList.map((data) {
      late String departmentData = data["department"];
      late String classData = data["classroom"];
      late String gradeData = data["grade"];
      if (!tempDepartmentList.contains(departmentData) &&
          !departmentData.isEmpty) {
        parentList?.add("部署・学科");
        tempDepartmentList.add(data["department"]);
      }
      if (!tempClassList.contains(classData) && !classData.isEmpty) {
        parentList?.add("クラス");
        tempClassList.add(data["classroom"]);
      }
      if (!gradeData.isEmpty) {
        // int型に変換
        if (!tempGradeListInt.contains(int.parse(gradeData))) {
          parentList?.add("期生・学年");
          // int型として追加
          tempGradeListInt.add(int.parse(data["grade"]));
          // 並び替え
          tempGradeListInt.sort((a, b) => a - b);
        }
      }
    }).toList();
    parentList?.add("管理者");
    parentList = this.parentList;

    // 初期化のための代入 => 選択肢1で使用
    this.departmentList = tempDepartmentList;
    this.classList = tempClassList;
    // tempGradeListIntをStringで再代入
    tempGradeListInt.map((data) {
      tempGradeListString.add(data.toString());
    }).toList();
    this.gradeList = tempGradeListString;
    // 初期化のための代入 => 選択肢2で使用
    if (!departmentList!.isEmpty) {
      tempParentList.add(departmentList);
    }
    if (!gradeList!.isEmpty) {
      tempParentList.add(gradeList);
    }
    if (!classList!.isEmpty) {
      tempParentList.add(classList);
    }
    // tempParentList.addAll([departmentList, gradeList, classList]);
    this.gotParentList = tempParentList;
    notifyListeners();
  }
}
