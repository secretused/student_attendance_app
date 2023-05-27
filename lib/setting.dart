import 'package:flutter/material.dart';

class SettingClass extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

// ページ遷移(フェードイン)
  PageRouteBuilder<dynamic> NavigationFade(pageName) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        return pageName;
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const double begin = 0.0;
        const double end = 5.0;
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
  PageRouteBuilder<dynamic> NavigationButtomSlide(pageName) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        return pageName;
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const Offset begin = Offset(0.0, 1.5); // 下から上
        // final Offset begin = Offset(0.0, -1.0); // 上から下
        const Offset end = Offset.zero;
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
  PageRouteBuilder<dynamic> NavigationButtonCutIn(pageName) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        return pageName;
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const Offset begin = Offset(1.0, 0.0); // 右から左
        // final Offset begin = Offset(-1.0, 0.0); // 左から右
        const Offset end = Offset.zero;
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

// 閉じるボタン
  Widget closeButton(
    BuildContext context,
    double buttonSize,
    Function() onPressed,
  ) {
    return SizedBox(
      width: buttonSize * 1.2,
      height: buttonSize * 1.2,
      child: FloatingActionButton(
        child: Icon(
          Icons.clear,
          size: buttonSize,
          color: Colors.white,
        ),
        onPressed: () {
          onPressed();
        },
      ),
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
      title: const Text(
        "エラー",
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            error_message,
            textAlign: TextAlign.center,
          ),
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
                      foregroundColor: const Color.fromARGB(255, 66, 140, 224),
                    ),
                    child: const Text(
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

// 確認モーダルUI
class ValidaterModal extends StatelessWidget {
  const ValidaterModal({
    required this.title,
    required this.validate_message,
    required this.validate_button,
    required this.validate_cancel,
    required this.colors,
    Key? key,
  }) : super(key: key);

  final String title;
  final String validate_message;
  final String validate_button;
  final String validate_cancel;
  final Color colors;

  @override
  Widget build(BuildContext context) {
    late bool isCancel = false;
    return AlertDialog(
      title: Text(
        title,
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            validate_message,
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                  onPressed: () {
                    isCancel = true;
                    Navigator.pop(context, isCancel);
                  },
                  child: Text(validate_cancel),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, isCancel);
                  },
                  child: Text(
                    validate_button,
                    style: TextStyle(color: colors),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
// くるくる処理
class CircleLoadingAction extends StatelessWidget {
  const CircleLoadingAction({Key? key, required this.visible}) : super(key: key);

  //表示状態
  final bool visible;

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    return visible
        ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 13.0),
              child: SizedBox(
                child: const LinearProgressIndicator(),
                height: 5.0,
                width: deviceWidth * 0.90,
              ),
            ),
          ],
        )
        : const SizedBox.shrink();
  }
}
