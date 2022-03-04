import 'package:flutter/material.dart';

class SettingClass extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

// ページ遷移(フェードイン)
  PageRouteBuilder<dynamic> NavigationFade(page_name) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        return page_name;
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final double begin = 0.0;
        final double end = 5.0;
        final Animatable<double> tween = Tween(begin: begin, end: end)
            .chain(CurveTween(curve: Curves.easeInOut));
        final Animation<double> doubleAnimation = animation.drive(tween);
        return FadeTransition(
          opacity: doubleAnimation,
          child: child,
        );
      },
    );
  }

  // ページ遷移(下から上)
  PageRouteBuilder<dynamic> NavigationButtomSlide(page_name) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        return page_name;
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final Offset begin = Offset(0.0, 1.5); // 下から上
        // final Offset begin = Offset(0.0, -1.0); // 上から下
        final Offset end = Offset.zero;
        final Animatable<Offset> tween = Tween(begin: begin, end: end)
            .chain(CurveTween(curve: Curves.easeInOut));
        final Animation<Offset> offsetAnimation = animation.drive(tween);
        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }

  // ページ遷移(右から左)
  PageRouteBuilder<dynamic> NavigationButtonCutIn(page_name) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        return page_name;
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final Offset begin = Offset(1.0, 0.0); // 右から左
        // final Offset begin = Offset(-1.0, 0.0); // 左から右
        final Offset end = Offset.zero;
        final Animatable<Offset> tween = Tween(begin: begin, end: end)
            .chain(CurveTween(curve: Curves.easeInOut));
        final Animation<Offset> offsetAnimation = animation.drive(tween);
        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }
}

// 例外・エラーモーダルUI
class ErrorModal extends StatelessWidget {
  const ErrorModal({
    required this.error_message,
    Key? key,
  }) : super(key: key);

  final String error_message;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "エラー",
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(error_message),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: SizedBox(
                  width: 100,
                  height: 35,
                  child: TextButton(
                    style: ElevatedButton.styleFrom(
                      onPrimary: Color.fromARGB(255, 66, 140, 224),
                    ),
                    child: Text(
                      'OK',
                      style: TextStyle(fontSize: 17),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
