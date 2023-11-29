import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// This class is the Robot of Robot pattern. It is a wrapper around a Finder that
/// provides a more fluent API for testing Widgets.
///
/// The Robot class is abstract and must be extended to provide the type of Widget
/// that it will find. For example, if you have a Widget called MyWidget, you would
/// create a Robot for it like this:
///
/// ```dart
/// class MyWidgetRobot extends Robot<MyWidget> {
///  MyWidgetRobot(super.tester);
/// }
/// ```
///
/// The Robot class provides a constructor that takes a WidgetTester and a Finder.
/// The Finder is optional and defaults to finding the Widget by type. If you want
/// to find the Widget by something other than type, you can pass a Finder to the
/// constructor.
abstract class Robot<T extends Widget> extends Finder {
  Robot(this.tester, [Finder? finder]) : _finder = finder ?? find.byType(T);

  /// [Robot.descendant] is a convenience constructor that finds a descendant of
  /// the Finder passed to it. It is useful for finding Widgets that are not
  /// direct children of the Widget under test.
  Robot.descendant(this.tester, {required Finder of, FinderBase<Element>? matching})
      : _finder = find.descendant(of: of, matching: matching ?? find.byType(T));

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
}

extension RobotExpectation on Robot {
  void expectShown() => expect(this, findsOneWidget);
  void expectHidden() => expect(this, findsNothing);
}
