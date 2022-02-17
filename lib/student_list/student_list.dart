import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:quiver/iterables.dart';

import '../main.dart';
import '../add_student/add_student.dart';
import 'student_model.dart';

class StudentListHome extends StatefulWidget {
  @override
  StudentList createState() => StudentList();
}

class StudentList extends State<StudentListHome> {
  MyHomePageState main_data = MyHomePageState();
  int _groupValue = 0;
  var _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("生徒管理"),
        backgroundColor: Color.fromARGB(255, 67, 176, 190),
      ),
      body: Container(
        // height: double.infinity,
        width: double.infinity,
        // color: Color.fromARGB(255, 223, 198, 135),
        child: CupertinoSegmentedControl<int>(
          padding: EdgeInsets.all(10),
          groupValue: _groupValue,
          borderColor: Color.fromARGB(255, 66, 140, 224),
          // pressedColor: Color.fromARGB(255, 66, 140, 224),
          // selectedColor: Colors.black,
          unselectedColor: Colors.white,
          children: {
            0: buildSegment("一期生"),
            1: buildSegment("二期生"),
            2: buildSegment("三期生")
          },
          onValueChanged: (groupValue) {
            setState(() {
              _groupValue = groupValue;
            });
            ListViewWidget();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            main_data.NavigationButtomSlide(AddStudent()),
          );
        },
      ),
    );
  }

  Widget buildSegment(String text) => Container(
        padding: EdgeInsets.all(6),
        child: Text(
          text,
          style: TextStyle(fontSize: 15),
        ),
      );
}

class ListViewWidget extends StatelessWidget {
  late int gotgroupValue;
  // ListViewWidget({required this.gotgroupValue});
  final student_list = StudentList();

  @override
  Widget build(BuildContext context) {
    print(student_list);
    return ChangeNotifierProvider<StudentListModel>(
      create: (_) => StudentListModel()..getStudents(),
      child: Container(
        child: Consumer<StudentListModel>(
          builder: (context, model, child) {
            final students = model.students;
            // 値渡している
            gotgroupValue = student_list._groupValue;
            return Stack(
              children: [
                ListView.builder(
                  itemCount: students.length, // moviesの長さだけ表示
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        ListTile(
                          // ここにif (student[index].grad e== N)で条件分岐したい
                          // NをgotgroupValueで受け取った値で判断する
                          title: Text(students[index].name), // タイトル
                          subtitle: Text(students[index].email),
                          trailing: Text(students[index].classroom),
                        ),
                      ],
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
