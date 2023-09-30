import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_forecast/controllers/global_controller.dart';
import 'package:weather_forecast/utilities/custom_colors.dart';
import 'package:weather_forecast/widgets/comfort_level.dart';
import 'package:weather_forecast/widgets/current_weather.dart';
import 'package:weather_forecast/widgets/daily_data_forecast.dart';
import 'package:weather_forecast/widgets/header.dart';
import 'package:weather_forecast/widgets/hourly_data_widget.dart';
import 'package:weather_forecast/widgets/searchbar.dart';
import 'package:weather_forecast/widgets/toggle.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // call
  final args = Get.arguments;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final GlobalController globalController =
      Get.put(GlobalController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    String city = args != null ? args[0] : '';

    return Scaffold(
      key: _scaffoldKey,
      endDrawer: Drawer(
        width: MediaQuery.sizeOf(context).width * 0.6,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 120,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const Text(
                      'Settings',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: CustomColors.firstGradientColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: const BoxDecoration(
                      border: Border(
                    top: BorderSide(
                      color: Colors.white,
                      width: 1,
                    ),
                  )),
                  child: Column(
                    children: [
                      Obx(() {
                        return Toggle(
                          label: 'Dark Mode',
                          value: globalController.isDarkMode.value,
                          onChanged: (newValue) {
                            globalController.isDarkMode.value = newValue;
                          },
                        );
                      }),
                      Obx(() {
                        return Toggle(
                          label: 'Show in Farenheit',
                          value: globalController.isFahrenheit.value,
                          onChanged: (newValue) async {
                            globalController.isFahrenheit.value = newValue;
                          },
                        );
                      }),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      // bottomNavigationBar: SearchFeld(
      //   onSubmitted: globalController.search,
      // ),
      body: SafeArea(
        bottom: false,
        child: Obx(() => globalController.checkLoading().isTrue
            ? Center(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/icons/clouds.png",
                    height: 200,
                    width: 200,
                  ),
                  const CircularProgressIndicator(),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text('Getting location info...')
                ],
              ))
            : Obx(() {
                final data = globalController.getData();
                return Stack(
                  children: [
                    ListView(
                      scrollDirection: Axis.vertical,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Header(searchCity: city),
                            SizedBox(
                              width: 70,
                              child: IconButton(
                                  onPressed: () {
                                    _scaffoldKey.currentState!.openEndDrawer();
                                  },
                                  icon: const Icon(
                                    Icons.settings,
                                    size: 40,
                                  )),
                            )
                          ],
                        ),
                        CurrentWeather(
                          weatherDataCurrent: data.getCurrentWeather(),
                        ),
                        const SizedBox(height: 20),
                        HourlyData(
                          weatherDataHourly: data.getHourlyWeather(),
                        ),
                        DailyDataForecast(
                          weatherDataDaily: data.getDailyWeather(),
                        ),
                        Container(
                          height: 1,
                          color: CustomColors.dividerLine,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ComfortLevel(
                          weatherDataCurrent: data.getCurrentWeather(),
                        )
                      ],
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Card(
                        margin: EdgeInsets.zero,
                        child: SearchFeld(
                          onSubmitted: globalController.search,
                        ),
                      ),
                    ),
                  ],
                );
              })),
      ),
    );
  }
}
