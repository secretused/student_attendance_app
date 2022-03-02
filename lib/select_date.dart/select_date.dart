import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../main.dart';

void main() => runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SelectDateHome(),
      ),
    );

class SelectDateHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SelectDate();
  }
}

class SelectDate extends State<SelectDateHome> {
  var _labelText = '日付選択';

  final main_date = MyHomePageState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _labelText,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color.fromARGB(255, 67, 176, 190),
      ),
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('attendances')
              .where("createdAt", isEqualTo: _labelText)
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
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(FontAwesomeIcons.solidCalendarAlt),
        // child: Icon(Icons.calendar_view_week_rounded),
        onPressed: () {
          _selectDate(context);
        },
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime(2023),
    );
    if (selected != null) {
      setState(() {
        _labelText = (DateFormat('yyyy年MM月dd日')).format(selected);
      });
    }
  }
}
