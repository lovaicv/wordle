import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wordle/core/app_strings.dart';
import 'package:wordle/pages/home_controller.dart';
import 'package:wordle/pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      onGenerateTitle: (context) => AppStrings.appTitle,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/home',
      initialBinding: BindingsBuilder(() {}),
      getPages: [
        GetPage(
          name: '/home',
          page: () => const MyHomePage(
            title: AppStrings.appTitle,
          ),
          binding: BindingsBuilder(() {
            Get.put(HomeController());
          }),
        ),
      ],
    );
  }
}
