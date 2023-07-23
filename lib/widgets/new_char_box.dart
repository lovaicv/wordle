import 'package:flutter/material.dart';

class NewCharBox extends StatefulWidget {
  final String char;
  final int duration;

  const NewCharBox({
    Key? key,
    required this.char,
    required this.duration,
  }) : super(key: key);

  @override
  State<NewCharBox> createState() => _ListItemState();
}

class _ListItemState extends State<NewCharBox> with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: Duration(milliseconds: widget.duration),
    vsync: this,
  );
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.bounceOut,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_animation.status == AnimationStatus.dismissed) _controller.forward();
    return ScaleTransition(
      scale: _animation,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
        ),
        child: Text(
          widget.char,
          style: const TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
