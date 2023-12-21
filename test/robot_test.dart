import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:robot/robot.dart';

import 'my_widget.dart';

void main() {
  testWidgets('Robot pattern test - tap MyButton', (tester) async {
    // This test uses the Robot pattern to test the TestWidget.
    // The Robot pattern is a way to make widget tests more readable and maintainable.
    // It is based on the Page Object pattern used in web testing.
    // The Robot pattern is implemented in the Robot class in lib/src/robot.dart.

    final robot = MyWidgetRobot(tester)
      ..text = 'Hello, World!'; // This line creates the Robot with the tester and sets the text property.

    await robot.show();
    robot.expectText();
    robot.myButton.expectShown();

    await robot.myButton.tap();
    robot.myButton.expectAlertDialog();
  });

  testWidgets('Robot pattern test - tap OutlinedButton', (tester) async {
    final robot = MyWidgetRobot(tester)
      ..text = 'Hello, World!'; // This line creates the Robot with the tester and sets the text property.

    await robot.show();

    robot.expectCount(0);
    await robot.countUpButton.tap();
    robot.expectCount(1);
  });

  testWidgets('get widget', (tester) async {
    final robot = MyWidgetRobot(tester)
      ..text = 'Hello, World!'; // This line creates the Robot with the tester and sets the text property.

    await robot.show();

    expect(robot.widget, isA<MyWidget>());
  });

  testWidgets('TextFieldRobot', (tester) async {
    final robot = Robot<TextField>(tester);

    final controller = TextEditingController();
    addTearDown(() => controller.dispose());

    await tester.pumpWidget(MaterialApp(home: Scaffold(body: TextField(controller: controller))));

    await robot.enter('test');
    expect(controller.text, 'test');
    expect(robot.controller!.text, 'test');

    await robot.erase();
    expect(controller.text, '');
  });
}

/// This class is the Robot for the MyWidget. It uses super() to find the MyWidget
/// by type.
class MyWidgetRobot extends Robot<MyWidget> {
  MyWidgetRobot(super.tester);

  late String text;

  /// This getter uses find.descendant() to find the Text widget with the given text.
  /// Because it is a descendant of the TestWidget, it is a descendant of this Robot.
  Finder get textFinder => find.descendant(of: this, matching: find.text(text));

  /// This getter uses super.descendant() to find the MyButton widget.
  /// Because it is a descendant of the TestWidget, it is a descendant of this
  /// Robot.
  Robot<MyButton> get myButton => Robot.descendant(tester, of: this);

  Robot<OutlinedButton> get countUpButton => Robot<OutlinedButton>.descendant(tester, of: this);

  Robot<Text> get count => Robot.byKey(tester, const Key('count'));

  /// [show] uses the RobotHelper extension to wrap the TestWidget in a MaterialApp.
  /// It then uses tester.pumpWidget() to show the widget.
  Future<void> show() => tester.pumpWidget(wrapMaterialApp(MyWidget(text: text)));

  /// [expectText] checks that the text is shown.
  /// It uses the _textFinder getter to find the Text widget.
  void expectText() => expect(textFinder, findsOneWidget);

  void expectCount(int i) {
    count.expectShown();
    count.expectText('Count: $i');
  }
}

/// This extension is used with Robot class directly.
/// This is useful for Widgets that don't have their state.
extension MyButtonRobot on Robot<MyButton> {
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
