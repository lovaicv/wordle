import 'dart:math';

import 'package:flutter/material.dart';

class FlipBox extends StatefulWidget {
  final String char;
  final int duration;
  final Color backgroundColor;

  const FlipBox({
    Key? key,
    required this.char,
    required this.duration,
    required this.backgroundColor,
  }) : super(key: key);

  @override
  State<FlipBox> createState() => _FlipBoxState();
}

class _FlipBoxState extends State<FlipBox> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: widget.duration))..forward();
    _animation = Tween(begin: 0.0, end: 0.5).animate(_controller)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reverse();
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: FractionalOffset.center,
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.0015)
        ..rotateX(pi * _animation.value),
      child: _controller.status == AnimationStatus.forward
          ? Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
              ),
              child: Text(
                widget.char,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ))
          : Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: widget.backgroundColor,
              ),
              child: Text(
                widget.char,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
    );
  }
}
