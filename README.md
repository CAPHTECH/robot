# Robot

This library is designed to facilitate the use of the Robot pattern when developing apps using the Flutter framework. The Robot pattern is a software testing technique that aims to encapsulate a repetitive series of user actions into classes that can be re-used efficiently to simulate & test user interaction with the app, allowing the development of higher-quality applications.

## Features

- Provides the Robot class that can be extended to create a Robot for each widget in the app.

## Getting started

### 1. Add this to your package's `pubspec.yaml` file

```yaml
dev_dependencies:
  robot: ^0.0.1
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
class MyWidgetRobot extends Robot {
  MyWidgetRobot(super.tester);
}
```

See more details on how to use this package in the [robot_test.dart](./test/robot_test.dart) file.

## LICENSE

MIT License
