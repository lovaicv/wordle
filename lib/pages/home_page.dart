import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wordle/custom_keyboard.dart';
import 'package:wordle/custom_words.dart';
import 'package:wordle/pages/home_controller.dart';

class MyHomePage extends GetView<HomeController> {
  final String title;

  const MyHomePage({Key? key, required this.title}) : super(key: key);

  //Get.width does not trigger rebuild on dynamic size
  //use MediaQuery.of(context).size.width instead
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body:
            // context.isTablet
            //     ? TwoPane(startPane: customWords(context), endPane: customKeyboard(MediaQuery.of(context).size.width / 2))
            //     :
            mobileScreen(context));
  }

  mobileScreen(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                customWords(context),
                customKeyboard(MediaQuery.of(context).size.width),
              ],
            ),
          ),
          Obx(() => Visibility(
                visible: controller.popUpText.value.isNotEmpty,
                child: Positioned(
                  top: 10,
                  left: 0,
                  right: 0,
                  child: Container(
                    alignment: Alignment.center,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                      child: Text(
                        controller.popUpText.value,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
