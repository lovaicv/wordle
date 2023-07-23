import 'dart:math';

import 'package:flutter/material.dart';

class NotEnoughBox extends StatefulWidget {
  final String char;
  final int duration;

  const NotEnoughBox({
    Key? key,
    required this.char,
    required this.duration,
  }) : super(key: key);

  @override
  NotEnoughBoxState createState() => NotEnoughBoxState();
}

class NotEnoughBoxState extends State<NotEnoughBox> with TickerProviderStateMixin {
  late final _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: widget.duration));

  late final Animation<double> _sineAnimation = Tween(
    begin: 0.0,
    end: 1.0,
  ).animate(CurvedAnimation(
    parent: _animationController,
    curve: SineCurve(count: 3.toDouble()),
  ));

  @override
  void initState() {
    super.initState();
    _animationController.addStatusListener(_updateStatus);
  }

  @override
  void dispose() {
    _animationController.removeStatusListener(_updateStatus);
    _animationController.dispose();
    super.dispose();
  }

  void _updateStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _animationController.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_sineAnimation.status == AnimationStatus.dismissed) _animationController.forward();
    return AnimatedBuilder(
      animation: _sineAnimation,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: widget.char.isEmpty ? Colors.grey : Colors.black),
        ),
        child: Text(
          widget.char,
          style: const TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_sineAnimation.value * 10, 0),
          child: child,
        );
      },
    );
  }
}

class SineCurve extends Curve {
  const SineCurve({this.count = 3});

  final double count;

  @override
  double transformInternal(double t) {
    return sin(count * 2 * pi * t);
  }
}
