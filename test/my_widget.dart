import 'package:flutter/material.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({super.key, required this.text});

  final String text;

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: Column(
        children: [
          Text(widget.text),
          const MyButton(),
          OutlinedButton(
            onPressed: () {
              setState(() => _count++);
            },
            child: const Text('Button'),
          ),
          Text('Count: $_count', key: const Key('count')),
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
