import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:quiver/iterables.dart';

import '../main.dart';
import '../add_student/add_student.dart';
import 'student_model.dart';

class StudentListHome extends StatefulWidget {
  String? communityName;
  StudentListHome(String? community) {
    this.communityName = community;
  }

  @override
  StudentList createState() => StudentList();
}

class StudentList extends State<StudentListHome> {
  MyHomePageState main_data = MyHomePageState();
  int _groupValue = 1;
  var _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "生徒管理",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color.fromARGB(255, 67, 176, 190),
      ),
      body: Column(
        children: [
          Container(
            // height: double.infinity,
            width: double.infinity,

            child: CupertinoSegmentedControl<int>(
              padding: EdgeInsets.all(10),
              groupValue: _groupValue,
              borderColor: Color.fromARGB(255, 66, 140, 224),
              // pressedColor: Color.fromARGB(255, 66, 140, 224),
              // selectedColor: Colors.black,
              unselectedColor: Colors.white,
              children: {
                1: buildSegment("一期生"),
                2: buildSegment("二期生"),
                3: buildSegment("三期生")
              },
              onValueChanged: (groupValue) {
                setState(() {
                  _groupValue = groupValue;
                });
              },
            ),
          ),
          Container(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .where("grade", isEqualTo: _groupValue.toString())
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
                return Expanded(
                  child: ListView(
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      final data = document.data()! as Map<String, dynamic>;
                      return Card(
                        child: ListTile(
                          title: Text('${data['name']}'),
                          subtitle: Text('${data['email']}'),
                          trailing: Text('${data['classroom']}'),
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          )
        ],
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
