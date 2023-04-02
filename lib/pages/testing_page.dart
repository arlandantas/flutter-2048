import 'package:flutter/material.dart';
import 'package:flutter2048/components/swipe_detector.dart';

class TestingPage extends StatefulWidget {
  const TestingPage({super.key});

  @override
  State<TestingPage> createState() => _TestingPageState();
}

const int defaultAnimationDuration = 1000;

class _TestingPageState extends State<TestingPage> {
  bool animating = false;
  Color color = Colors.blue;
  int animationDuration = defaultAnimationDuration;

  void toggleAnimation() {
    if (!animating) {
      setState(() {
        animating = true;
        // animationDuration = defaultAnimationDuration;
      });
      Future.delayed(
        const Duration(milliseconds: defaultAnimationDuration),
        () {
          setState(
            () {
              // animationDuration = 0;
              color = Colors.red;
            },
          );
          Future.delayed(
            const Duration(milliseconds: defaultAnimationDuration),
            () => {
              setState(
                () {
                  // animationDuration = 0;
                  animating = false;
                  color = Colors.blue;
                  // color = Colors.green;
                },
              )
            },
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Testing Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AnimatedContainer(
              decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              duration: Duration(milliseconds: animationDuration),
              curve: Curves.fastOutSlowIn,
              padding: const EdgeInsets.all(10),
              transform: Matrix4.translationValues(animating ? 200 : 0, 0, 0),
              child: Text(animating ? 'Animating' : 'stopped'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: toggleAnimation,
        tooltip: 'Toggle Animation',
        child: Icon(animating ? Icons.toggle_on : Icons.toggle_off),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
