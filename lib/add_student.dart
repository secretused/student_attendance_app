import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

class AddStudent extends StatelessWidget {
  // final _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("生徒登録"),
        backgroundColor: Color.fromARGB(255, 67, 176, 190),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        // color: Color.fromARGB(255, 223, 198, 135),
        child: Form(
          child: TextFormField(
            decoration: InputDecoration(labelText: 'Title'),
          ),
        ),
      ),
    );
    // throw UnimplementedError();
  }
}
