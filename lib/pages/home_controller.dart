import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:get/get.dart';
import 'package:wordle/box_state.dart';
import 'package:wordle/core/app_colors.dart';
import 'package:wordle/models/box_model.dart';

class HomeController extends GetxController {
  List<dynamic> words = [];
  String keyword = 'bread';
  RxList<Box> boxes = <Box>[].obs;
  RxMap<String, Color> keyboardChar = <String, Color>{}.obs;
  List<String> successWords = ['Genius', 'Magnificent', 'Impressive', 'Splendid', 'Great', 'Phew'];
  int currentRow = 1;
  RxInt crossAxisCount = 5.obs;
  RxInt mainAxisCount = 6.obs;
  RxList<int> numbers = List<int>.from([0]).obs;
  List<AnimationController> animationControllers = [];
  RxString popUpText = ''.obs;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  void onInit() {
    readFile();
    int count = 0;
    int row = 1;
    while (count < crossAxisCount.value * mainAxisCount.value) {
      if (count != 0 && count % 5 == 0) {
        row += 1;
      }
      boxes.add(Box(index: count, row: row, char: '', state: BoxState.empty));
      count++;
    }
    // boxes.forEach((element) {
    //   print('${element.index} ${element.row} ${element.char}');
    // });
    super.onInit();
  }

  readFile() async {
    var input = await rootBundle.loadString('assets/json/5-letter-words.json');
    words = json.decode(input);
  }

  void addChar(String text) {
    Box box = boxes.firstWhere((element) => element.char.isEmpty, orElse: () => Box(state: BoxState.error));
    if (box.row == currentRow && box.state != BoxState.error) {
      // int newCharIndex = boxes.indexWhere((element) => element.char.isEmpty);
      // Box box = boxes[newCharIndex];
      boxes[box.index] = Box(index: box.index, row: box.row, char: text, state: BoxState.newText, duration: 100);
      resetAnimation(box.index);
      // boxes.asMap().forEach((index, box) {
      //   if (box.index != index && box.row == currentRow) {
      //     boxes[index] = Box(row: box.row, char: box.char, state: box.char.isEmpty ? BoxState.empty : BoxState.newText, duration: 0);
      //   }
      // });
    }
  }

  void enter() {
    int index = boxes.lastIndexWhere((element) => element.char.isNotEmpty);
    if ((index + 1) % 5 == 0) {
      List<Box> currentRowOfBox = boxes.where((p0) => p0.row == currentRow).toList();

      String word = '';
      for (var element in currentRowOfBox) {
        word = '$word${element.char}';
      }

      Iterable isWordExist = words.where((element) => element.toUpperCase() == word);

      if (isWordExist.isEmpty) {
        //invalid due to word not found
        invalidShake(index);
        showPopUpText('not in word list');
      } else {
        //split keyword into 5 individual string
        List<String> check1 = keyword.toUpperCase().split('');
        List<String> check2 = word.split('');
        // print('$check1 $check2');

        List<Box> filteredRow = currentRowOfBox.where((element) => element.row == currentRow).toList();
        check2.asMap().forEach((index, char) {
          String keywordChar = check1[index];
          Box box = filteredRow[index];
          BoxState state;
          Color color;
          if (char == keywordChar) {
            //correct spot
            state = BoxState.correctSpot;
            color = AppColors.green;
          } else if (check1.contains(char)) {
            //wrong spot
            state = BoxState.wrongSpot;
            color = AppColors.beige;
          } else {
            //not found
            state = BoxState.notFound;
            color = AppColors.grey;
          }
          Future.delayed(Duration(milliseconds: index * 100), () {
            boxes[box.index] = Box(index: box.index, row: box.row, char: box.char, state: state, duration: 300);
          }).whenComplete(() {
            //add a bit of delay for the flip animation to end first
            if (index == crossAxisCount.value - 1) {
              Future.delayed(const Duration(milliseconds: 500), () {
                checkWinner(filteredRow);
              });
            }
          });

          if (keyboardChar[box.char] == null) {
            keyboardChar[box.char] = color;
          } else {
            if (keyboardChar[box.char] == AppColors.green) {
              //do nothing
            } else if (keyboardChar[box.char] == AppColors.beige && color == AppColors.green) {
              //beige to green
              keyboardChar[box.char] = color;
            } else if (keyboardChar[box.char] == AppColors.grey && (color == AppColors.beige || color == AppColors.green)) {
              // grey to beige/green
              keyboardChar[box.char] = color;
            }
          }
        });
      }
    } else {
      //invalid due to word not complete
      invalidShake(index);
      showPopUpText('not enough letters');
    }
  }

  checkWinner(List<Box> filteredRow) {
    Iterable<Box> currentRowOfBox = boxes.where((p0) => p0.row == currentRow && p0.state == BoxState.correctSpot);
    // for (var element in currentRowOfBox) {
    //   showLog('${element.char} ${element.state}');
    // }
    if (currentRowOfBox.length == crossAxisCount.value) {
      showPopUpText(successWords[currentRow - 1]);
      filteredRow.asMap().forEach((index, box) async {
        Future.delayed(Duration(milliseconds: index * 100), () {
          boxes[box.index] = Box(index: box.index, row: box.row, char: box.char, state: BoxState.win, duration: 500);
        });
      });
    } else {
      currentRow += 1;
      if (currentRow > mainAxisCount.value) {
        showPopUpText(keyword.toUpperCase());
      }
    }
  }

  Timer? _timer;
  int _start = 2;

  showPopUpText(String text) {
    popUpText.value = text;
    if (_timer != null) _timer?.cancel();
    _timer = Timer.periodic(
      const Duration(seconds: 2),
      (Timer timer) {
        if (_start == 0) {
          popUpText.value = '';
          timer.cancel();
        } else {
          _start--;
        }
      },
    );
  }

  void removeLast() {
    Box box = boxes.lastWhere((element) => element.char.isNotEmpty, orElse: () => Box(state: BoxState.error));
    if (box.row == currentRow && box.state != BoxState.error) {
      // int newCharIndex = boxes.lastIndexWhere((element) => element.char.isNotEmpty);
      // Box box = boxes[newCharIndex];
      // boxes[newCharIndex] = Box(row: box.row, char: '', state: BoxState.empty);
      boxes[box.index] = Box(index: box.index, row: box.row, char: '', state: BoxState.empty);
      resetAnimation(box.index);
      // boxes.asMap().forEach((index, box) {
      //   if (box.index != index && box.row == currentRow) {
      //     boxes[index] = Box(row: box.row, char: box.char, state: box.char.isEmpty ? BoxState.empty : BoxState.newText, duration: 0);
      //   }
      // });
    }
  }

  resetAnimation(int index) {
    // reset the shake animation if it happen before
    boxes.where((p0) => p0.row == currentRow).forEach((element) {
      if (element.index != index) {
        boxes[element.index] = Box(
          index: element.index,
          row: element.row,
          char: element.char,
          state: element.char.isEmpty ? BoxState.empty : BoxState.newText,
          duration: 0,
        );
      }
    });
  }

  //todo fix bug no word is entered prompt error no in word list, should be not enough letters
  invalidShake(int index) {
    boxes.where((p0) => p0.row == currentRow).forEach((element) {
      boxes[element.index] = Box(index: element.index, row: element.row, char: element.char, state: BoxState.notEnough, duration: 300);
    });
  }
}
