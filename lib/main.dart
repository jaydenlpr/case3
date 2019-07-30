import 'dart:math';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinning_wheel/flutter_spinning_wheel.dart';
import 'package:case3/widget/emoji_feedback.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final StreamController _divideController = StreamController<int>();

  @override
  void dispose() {
    _divideController.close();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Case 3",
      theme: ThemeData(
        primaryColor: Colors.blue[900],
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Case 3"),
        ),
        body: Column(
          children: [
            Card(
              margin: EdgeInsets.all(20),
              child: Container(
                margin: EdgeInsets.all(10),
                child: Text(
                  " Please spin the wheel to rate the issues that you currently problems for you.\n"
                  " You click or tap anywhere on the wheel iteself.",
                  style: TextStyle(
                    color: Colors.blue[900],
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),
            ),
            Image.asset(
              'assets/arrow-bottom.png',
              width: 30,
              height: 30,
            ),
            SpinningWheel(
              Image.asset('assets/wheel-bg.png'),
              width: 300,
              height: 300,
              initialSpinAngle: 0,
              spinResistance: 0.2,
              dividers: 6,
              onUpdate: _divideController.add,
              onEnd: _divideController.add,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                "Please select the appropriate number",
                style: TextStyle(
                  color: Colors.blue[900]
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: EmojiFeedback(),
            )
          ],
        ),
      ),
    );
  }
}