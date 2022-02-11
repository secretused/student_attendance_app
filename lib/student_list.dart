import 'package:flutter/material.dart';
import 'main.dart';
import 'add_student.dart';

class StudentList extends StatelessWidget {
  MyHomePageState main_data = MyHomePageState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("生徒管理"),
        backgroundColor: Color.fromARGB(255, 67, 176, 190),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        // color: Color.fromARGB(255, 223, 198, 135),
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
    // throw UnimplementedError();
  }
}
