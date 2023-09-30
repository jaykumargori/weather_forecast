import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_forecast/screens/home.dart';
import 'package:weather_forecast/screens/search.dart';
import 'package:weather_forecast/utilities/custom_colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: CustomColors.textColorBlack),
      darkTheme:
          ThemeData(brightness: Brightness.dark, primaryColor: Colors.white),
      home: const HomeScreen(),
      getPages: [
        GetPage(name: '/', page: () => const HomeScreen()),
        GetPage(name: '/search', page: () => const Search()),
      ],
      title: "Weather Forecast",
      debugShowCheckedModeBanner: false,
    );
  }
}
