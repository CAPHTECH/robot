import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:robot/robot.dart';

void main() {
  testWidgets('Robot pattern test', (tester) async {
    // This test uses the Robot pattern to test the TestWidget.
    // The Robot pattern is a way to make widget tests more readable and maintainable.
    // It is based on the Page Object pattern used in web testing.
    // The Robot pattern is implemented in the Robot class in lib/src/robot.dart.

    final robot = TestWidgetRobot(tester)
      ..text = 'Hello, World!'; // This line creates the Robot with the tester and sets the text property.

    await robot.show();
    robot.expectText();
    robot.myButton.expectShown();

    await robot.myButton.tap();
    robot.myButton.expectAlertDialog();
  });
}

class TestWidget extends StatelessWidget {
  const TestWidget({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: Column(
        children: [
          Text(text),
          const MyButton(),
        ],
      ),
    );
  }
}

class MyButton extends StatelessWidget {
  const MyButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: ElevatedButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const AlertDialog(
              title: Text('Title'),
              content: Text('Content'),
            ),
          );
        },
        child: const Text('Button'),
      ),
    );
  }
}

/// This class is the Robot for the TestWidget. It uses super() to find the TestWidget
/// by type.
class TestWidgetRobot extends Robot<TestWidget> {
  TestWidgetRobot(super.tester);

  late String text;

  /// This getter uses find.descendant() to find the Text widget with the given text.
  /// Because it is a descendant of the TestWidget, it is a descendant of this Robot.
  Finder get _textFinder => find.descendant(of: this, matching: find.text(text));

  /// This getter uses super.descendant() to find the MyButton widget.
  /// Because it is a descendant of the TestWidget, it is a descendant of this
  /// Robot.
  MyButtonRobot get myButton => MyButtonRobot.descendant(tester, of: this);

  /// [show] uses the RobotHelper extension to wrap the TestWidget in a MaterialApp.
  /// It then uses tester.pumpWidget() to show the widget.
  Future<void> show() => tester.pumpWidget(wrapMaterialApp(TestWidget(text: text)));

  /// [expectText] checks that the text is shown.
  /// It uses the _textFinder getter to find the Text widget.
  void expectText() => expect(_textFinder, findsOneWidget);
}

/// This class is a descendant of the TestWidgetRobot, and uses super.descendant() to
/// find the MyButton widget.
class MyButtonRobot extends Robot<MyButton> {
  MyButtonRobot.descendant(super.tester, {required super.of}) : super.descendant();

  Finder get _buttonFinder => find.descendant(of: this, matching: find.byType(ElevatedButton));

  Future<void> tap() async {
    await tester.tap(_buttonFinder);
    await tester.pumpAndSettle();
  }

  void expectAlertDialog() {
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Title'), findsOneWidget);
    expect(find.text('Content'), findsOneWidget);
  }
}

/// This extension is not part of the library, but is used in the test.
extension RobotHelper on Robot {
  Widget wrapMaterialApp(Widget widget) => MaterialApp(home: widget);
}
