import 'package:attendanc_management_app/student_list/temp.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'student_list/student_list.dart';

class ManagementHome extends StatelessWidget {
  MyHomePageState main_data = MyHomePageState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("管理画面"),
          backgroundColor: Color.fromARGB(255, 67, 176, 190),
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          // color: Color.fromARGB(255, 223, 198, 135),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 40.0),
                child: Container(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ButtonDesign(
                          onPressed: () {},
                          backgroundColor: Color.fromARGB(255, 51, 166, 243),
                          text: "出席管理",
                          icon: Icon(
                            Icons.home,
                            size: 60,
                          ),
                        ),
                        ButtonDesign(
                          onPressed: () {
                            Navigator.push(
                              context,
                              main_data.NavigationFade(StudentListHome()),
                            );
                          },
                          backgroundColor: Color.fromARGB(255, 240, 130, 41),
                          text: "生徒管理",
                          icon: Icon(
                            Icons.account_circle,
                            size: 60,
                          ),
                        ),
                      ]),
                ),
              ),
              Container(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ButtonDesign(
                        onPressed: () {
                          Navigator.push(
                            context,
                            main_data.NavigationButtomSlide(TempClass()),
                          );
                        },
                        backgroundColor: Color.fromARGB(255, 61, 214, 125),
                        text: "出席管理",
                        icon: Icon(
                          Icons.add,
                          size: 60,
                        ),
                      ),
                      ButtonDesign(
                        onPressed: () {},
                        backgroundColor: Color.fromARGB(255, 241, 121, 195),
                        text: "生徒管理",
                        icon: Icon(
                          Icons.add,
                          size: 60,
                        ),
                      ),
                    ]),
              ),
            ],
          ),
        ));
    // throw UnimplementedError();
  }
}

class ButtonDesign extends StatelessWidget {
  const ButtonDesign({
    Key? key,
    required this.onPressed,
    required this.backgroundColor,
    required this.text,
    required this.icon,
  }) : super(key: key);

  final GestureTapCallback onPressed; //変数を宣言
  final Color backgroundColor;
  final String text;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 100,
          height: 100,
          child: ElevatedButton(
            child: icon,
            style: ElevatedButton.styleFrom(
              alignment: Alignment.center,
              primary: backgroundColor,
              onPrimary: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: onPressed,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 15,
            ),
          ),
        ),
      ],
    );
  }
}
