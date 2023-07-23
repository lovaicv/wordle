import 'package:wordle/box_state.dart';

class Box {
  late int index;
  late int row;
  late String char;
  late BoxState state;
  late int duration;

  Box({this.index = 0, this.row = 1, this.char = '', this.state = BoxState.empty, this.duration = 0});
}
