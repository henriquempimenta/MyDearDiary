import 'dart:async';
import 'package:flutter/material.dart';

class AnimatedGradientBackground extends StatefulWidget {
  const AnimatedGradientBackground({super.key, required this.child});

  final Widget child;

  @override
  _AnimatedGradientBackgroundState createState() => _AnimatedGradientBackgroundState();
}

class _AnimatedGradientBackgroundState extends State<AnimatedGradientBackground> {
  List<Color> colorList = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
  ];
  int index = 0;
  Color bottomColor = Colors.red;
  Color topColor = Colors.yellow;
  Alignment begin = Alignment.bottomLeft;
  Alignment end = Alignment.topRight;

  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 2),
      () {
        setState(
          () {
            bottomColor = Colors.blue;
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(seconds: 2),
      onEnd: () {
        setState(
          () {
            index = index + 1;
            bottomColor = colorList[index % colorList.length];
            topColor = colorList[(index + 1) % colorList.length];
          },
        );
      },
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: begin,
          end: end,
          colors: [bottomColor, topColor],
        ),
      ),
      child: widget.child,
    );
  }
}
