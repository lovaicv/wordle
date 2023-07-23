import 'package:flutter/material.dart';

class EmptyBox extends StatefulWidget {
  final int crossAxisCount;
  final int mainAxisCount;

  const EmptyBox({
    Key? key,
    required this.crossAxisCount,
    required this.mainAxisCount,
  }) : super(key: key);

  @override
  State<EmptyBox> createState() => _ListItemState();
}

class _ListItemState extends State<EmptyBox> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
      ),
      child: const Text(''),
    );
  }
}
