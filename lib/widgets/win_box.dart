import 'package:flutter/material.dart';

class WinBox extends StatefulWidget {
  final String char;
  final int duration;
  final Color backgroundColor;

  const WinBox({
    Key? key,
    required this.char,
    required this.duration,
    required this.backgroundColor,
  }) : super(key: key);

  @override
  State<WinBox> createState() => _ListItemState();
}

class _ListItemState extends State<WinBox> with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(vsync: this, duration: Duration(milliseconds: widget.duration))
    ..forward();
  late final Animation<Offset> _animation = Tween<Offset>(begin: const Offset(0, 0), end: const Offset(0, -0.4)).animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.elasticIn,
  ));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _animation,
      child: Container(
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
