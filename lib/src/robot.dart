import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// This class is the Robot of Robot pattern. It is a wrapper around a Finder that
/// provides a more fluent API for testing Widgets.
///
/// Two ways to use the Robot class are:
/// 1. Extend the Robot class to create a Robot for a specific Widget.
///
/// ```dart
/// class MyWidgetRobot extends Robot<MyWidget> {
///  MyWidgetRobot(super.tester);
/// }
/// ```
///
/// 2. Use the Robot class directly to create a Robot for a specific Widget.
///
/// ```dart
/// final robot = Robot<MyWidget>(tester);
/// ```
///
/// The Robot class provides a constructor that takes a WidgetTester and a Finder.
/// The Finder is optional and defaults to finding the Widget by type. If you want
/// to find the Widget by something other than type, you can pass a Finder to the
/// constructor.
class Robot<T extends Widget> extends Finder {
  Robot(this.tester, [Finder? finder]) : _finder = finder ?? find.byType(T);

  /// [Robot.descendant] is a convenience constructor that finds a descendant of
  /// the Finder passed to it. It is useful for finding Widgets that are not
  /// direct children of the Widget under test.
  Robot.descendant(this.tester, {required Finder of, FinderBase<Element>? matching})
      : _finder = find.descendant(of: of, matching: matching ?? find.byType(T));

  /// [Robot.byKey] is a convenience constructor that finds a Widget by its Key.
  /// It is useful for finding Widgets that are not direct children of the Widget
  /// under test.
  Robot.byKey(this.tester, Key key) : _finder = find.byKey(key);

  final Finder _finder;
  final WidgetTester tester;

  @override
  Iterable<Element> findInCandidates(Iterable<Element> candidates) => _finder.findInCandidates(candidates);

  @override
  // ignore: deprecated_member_use
  String get description => _finder.description;

  @override
  FinderResult<Element> evaluate() => _finder.evaluate();

  @override
  void runCached(VoidCallback run) => _finder.runCached(run);

  T get widget => tester.widget<T>(this);
}

extension RobotAction on Robot {
  Future<void> tap({String? text, Key? key, Finder? finder, bool waitAfter = true}) async {
    final target = finder ??
        (key != null
            ? find.byKey(key)
            : (text != null ? find.text(text) : throw ArgumentError('text or key or finder must be provided')));
    await tester.tap(target);
    if (waitAfter) await tester.pumpAndSettle();
  }

  Future<void> enterText(String input, {String? text, Key? key, Finder? finder, bool waitAfter = true}) async {
    final target = finder ??
        (key != null
            ? find.byKey(key)
            : text != null
                ? find.text(text)
                : throw ArgumentError('text or key or finder must be provided'));
    await tester.enterText(target, input);
    if (waitAfter) await tester.pumpAndSettle();
  }

  Future<void> eraseText({String? text, Key? key, Finder? finder, bool waitAfter = true}) async {
    final target = finder ??
        (key != null
            ? find.byKey(key)
            : text != null
                ? find.text(text)
                : throw ArgumentError('text or key or finder must be provided'));
    await tester.enterText(target, '');
    if (waitAfter) await tester.pumpAndSettle();
  }
}

extension RobotExpectation on Robot {
  void expectShown() => expect(this, findsOneWidget);
  void expectHidden() => expect(this, findsNothing);
}

extension TextRobot on Robot<Text> {
  String? get text => widget.data;

  void expectText(String text) => expect(text, this.text);
}

extension TapRobot on Robot<ButtonStyleButton> {
  Future<void> tap({bool waitAfter = true}) async {
    await tester.tap(this);
    if (waitAfter) await tester.pumpAndSettle();
  }
}

extension TextFieldRobot on Robot<TextField> {
  String? get text => widget.controller?.text;

  TextEditingController? get controller => widget.controller;

  Future<void> enter(String text, {bool waitAfter = true}) => enterText(text, finder: this, waitAfter: waitAfter);

  Future<void> erase({bool waitAfter = true}) => eraseText(finder: this, waitAfter: waitAfter);
}
