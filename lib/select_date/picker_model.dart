import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final pickerModelProvider =
Provider((ref) => PickerModel()..getChildData());

class PickerModel {
  String? communityName;
  setCommunityName(String? gotCommunity) {
    communityName = gotCommunity;
  }

  // 一個目のPicker用
  List? parentList = [];
  // StreamBuilderのクエリ用
  List? dataBaseList;
  // データが入る値
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

    final List tempPickerList = ["全て"];
    final List tempParentList = [];
    final List tempBaseList = [];

    final community = await FirebaseFirestore.instance
        .collection('users')
        .where("community", isEqualTo: communityName)
        .get();
    documentList = community.docs;

    documentList.map((data) {
      late String departmentData = data["department"];
      late String classData = data["classroom"];
      late String gradeData = data["grade"];
      if (!tempDepartmentList.contains(departmentData) &&
          !departmentData.isEmpty) {
        tempDepartmentList.add(data["department"]);
      }
      if (!gradeData.isEmpty) {
        // int型に変換
        if (!tempGradeListInt.contains(int.parse(gradeData))) {
          // int型として追加
          tempGradeListInt.add(int.parse(data["grade"]));
          // 並び替え
          tempGradeListInt.sort((a, b) => a - b);
        }
      }
      if (!tempClassList.contains(classData) && !classData.isEmpty) {
        tempClassList.add(data["classroom"]);
      }
    }).toList();

    // 初期化のための代入 => 選択肢1で使用
    departmentList = tempDepartmentList;
    classList = tempClassList;
    // tempGradeListIntをStringで再代入
    tempGradeListInt.map((data) {
      tempGradeListString.add(data.toString());
    }).toList();
    gradeList = tempGradeListString;

    // 初期化のための代入 => 選択肢2で使用
    if (!departmentList!.isEmpty) {
      tempParentList.add(departmentList);
      tempBaseList.add("department");
      tempPickerList.add("部署・学科");
    }
    if (!gradeList!.isEmpty) {
      tempParentList.add(gradeList);
      tempBaseList.add("grade");
      tempPickerList.add("期生・学年");
    }
    if (!classList!.isEmpty) {
      tempParentList.add(classList);
      tempBaseList.add("classroom");
      tempPickerList.add("チーム・クラス");
    }
    gotParentList = tempParentList;
    dataBaseList = tempBaseList;
    tempPickerList.add("管理者");
    parentList = tempPickerList;
    // 情報がない場合Pickerを表示させない

    if (gotParentList!.isEmpty) {
      return true;
    } else {
      return false;
    }
  }
}
