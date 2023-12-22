# Robot

This library is designed to facilitate the use of the Robot pattern when developing apps using the Flutter framework. The Robot pattern is a software testing technique that aims to encapsulate a repetitive series of user actions into classes that can be re-used efficiently to simulate & test user interaction with the app, allowing the development of higher-quality applications.

## Features

- Provides the Robot class that can be extended to create a Robot for each widget in the app.

## Getting started

### 1. Add this to your package's `pubspec.yaml` file

```yaml
dev_dependencies:
  robot: ^0.0.4
```

### 2. Install it by running the following command at the root of your project

```sh
flutter pub get
```

### 3. Import it by adding the following import statement to your Flutter test code

```dart
import 'package:robot/robot.dart';
```

## Usage

Create a Robot class for each widget in the app that you want to test. The Robot class should extend the Robot class from the Robot package.

```dart
class MyWidgetRobot extends Robot<MyWidget> {
  MyWidgetRobot(super.tester);

  late String text;

  Finder get textFinder => find.descendant(of: this, matching: find.text(text));

  Future<void> show() => tester.pumpWidget(MaterialApp(home: MyWidget(text: text)));

  void expectText() => expect(textFinder, findsOneWidget);
}
```

Create a test file for each widget in the app that you want to test. The test file should import the Robot class for the widget and the Flutter test package.

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:robot/robot.dart';

import 'my_widget_robot.dart';

void main() {
  group('MyWidget', () {
    testWidgets('should show text', (tester) async {
      final robot = MyWidgetRobot(tester)..text = 'Hello, World!';
      await robot.show();
      robot.expectText();
    });
  });
}
```

It can be useful to use the Robot class directly.

```dart
Robot<Text> get countText => Robot.byKey(tester, const Key('count'));
```

That can be used like this.

```dart
countText.expectText('Count: 0');
```

See more details on how to use this package in the [robot_test.dart](./test/robot_test.dart) file.

## LICENSE

MIT License
