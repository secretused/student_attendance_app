import 'package:flutter/material.dart';

class NavigationSettings extends StatelessWidget {
  const NavigationSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

// ページ遷移(フェードイン)
  static PageRouteBuilder<dynamic> navigationFade(pageName) {
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
  static PageRouteBuilder<dynamic> navigationButtomSlide(pageName) {
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
  static PageRouteBuilder<dynamic> navigationButtonCutIn(pageName) {
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
}

// 例外・エラーモーダルUI
class ErrorModal extends StatelessWidget {
  const ErrorModal({
    required this.errorMessage,
    Key? key,
  }) : super(key: key);

  final String errorMessage;

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
            errorMessage,
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
class ValidatorModal extends StatelessWidget {
  const ValidatorModal({
    required this.title,
    required this.validateMessage,
    required this.validateButton,
    required this.validateCancel,
    required this.colors,
    Key? key,
  }) : super(key: key);

  final String title;
  final String validateMessage;
  final String validateButton;
  final String validateCancel;
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
            validateMessage,
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
                  child: Text(validateCancel),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, isCancel);
                  },
                  child: Text(
                    validateButton,
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
