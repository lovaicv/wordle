import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wordle/pages/home_controller.dart';

Widget customKeyboard(double width) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 2.5),
        child: Row(
          children: [
            keyboardKey('Q', width),
            keyboardKey('W', width),
            keyboardKey('E', width),
            keyboardKey('R', width),
            keyboardKey('T', width),
            keyboardKey('Y', width),
            keyboardKey('U', width),
            keyboardKey('I', width),
            keyboardKey('O', width),
            keyboardKey('P', width),
          ],
        ),
      ),
      const SizedBox(height: 5),
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 2.5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            keyboardKey('A', width),
            keyboardKey('S', width),
            keyboardKey('D', width),
            keyboardKey('F', width),
            keyboardKey('G', width),
            keyboardKey('H', width),
            keyboardKey('J', width),
            keyboardKey('K', width),
            keyboardKey('L', width),
          ],
        ),
      ),
      const SizedBox(height: 5),
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 2.5),
        child: Row(
          children: [
            Expanded(child: keyboardKey('ENTER', width, isBigButton: true)),
            keyboardKey('Z', width),
            keyboardKey('X', width),
            keyboardKey('C', width),
            keyboardKey('V', width),
            keyboardKey('B', width),
            keyboardKey('N', width),
            keyboardKey('M', width),
            Expanded(child: keyboardKey('XX', width, isBigButton: true)),
          ],
        ),
      ),
      const SizedBox(height: 5),
    ],
  );
}

Widget keyboardKey(String text, double width, {bool isBigButton = false}) {
  HomeController controller = Get.find();
  return InkWell(
    onTap: () {
      HomeController controller = Get.find();
      if (text == 'ENTER') {
        controller.enter();
      } else if (text == 'XX') {
        controller.removeLast();
      } else {
        controller.addChar(text);
      }
    },
    child: Obx(() => Container(
          margin: const EdgeInsets.symmetric(horizontal: 2.5),
          width: (width - 5) / 10 - 5,
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            color: controller.keyboardChar[text] ?? Colors.grey.shade300,
            borderRadius: const BorderRadius.all(Radius.circular(5)),
          ),
          child: text == 'XX'
              ? const Icon(
                  Icons.backspace_outlined,
                  size: 18,
                )
              : Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: controller.keyboardChar[text] != null ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: isBigButton ? 10 : 14),
                ),
        )),
  );
}
