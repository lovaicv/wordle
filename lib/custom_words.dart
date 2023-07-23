import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wordle/box_state.dart';
import 'package:wordle/core/app_colors.dart';
import 'package:wordle/models/box_model.dart';
import 'package:wordle/pages/home_controller.dart';
import 'package:wordle/widgets/empty_box.dart';
import 'package:wordle/widgets/flip_box.dart';
import 'package:wordle/widgets/new_char_box.dart';
import 'package:wordle/widgets/not_enough_box.dart';
import 'package:wordle/widgets/win_box.dart';

Widget customWords(BuildContext context) {
  HomeController controller = Get.find();
  return Obx(
    () => GridView.builder(
      shrinkWrap: true,
      primary: false,
      padding: const EdgeInsets.all(10),
      itemCount: controller.boxes.length,
      itemBuilder: (context, index) {
        Box box = controller.boxes[index];
        switch (box.state) {
          case BoxState.newText:
            return NewCharBox(
              char: box.char,
              duration: box.duration,
            );
          case BoxState.empty:
            return EmptyBox(
              crossAxisCount: controller.crossAxisCount.value,
              mainAxisCount: controller.mainAxisCount.value,
            );
          case BoxState.correctSpot:
            return FlipBox(
              char: box.char,
              duration: box.duration,
              backgroundColor: AppColors.green,
            );
          case BoxState.wrongSpot:
            return FlipBox(
              char: box.char,
              duration: box.duration,
              backgroundColor: AppColors.beige,
            );
          case BoxState.notFound:
            return FlipBox(
              char: box.char,
              duration: box.duration,
              backgroundColor: AppColors.grey,
            );
          case BoxState.error:
            break;
          case BoxState.notEnough:
            return NotEnoughBox(
              char: box.char,
              duration: box.duration,
            );
          case BoxState.win:
            return WinBox(
              char: box.char,
              duration: box.duration,
              backgroundColor: AppColors.green,
            );
        }
        return Container();
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: controller.crossAxisCount.value,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
    ),
  );
}
