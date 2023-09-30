import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
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

  bool toggleButton1Value = false;
  bool toggleButton2Value = false;

  @override
  void initState() {
    if (args != null) {
      final searchQuery = args[0];
      if (searchQuery != '') {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          List<Location> locations = await locationFromAddress(searchQuery);
          globalController.getLocationUsingCoordinates(
            locations[0].latitude,
            locations[0].longitude,
            'metric',
          );
        });
      }
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String city = args != null ? args[0] : '';

    return Scaffold(
      key: _scaffoldKey,
      endDrawer: Drawer(
        width: MediaQuery.of(context).size.width * 0.6,
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
                      Toggle(
                        label: 'Dark Mode',
                        value: toggleButton1Value,
                        onChanged: (newValue) {
                          setState(() {
                            toggleButton1Value = newValue;
                          });
                          Get.changeThemeMode(
                            newValue ? ThemeMode.dark : ThemeMode.light,
                          );
                        },
                      ),
                      Toggle(
                        label: 'Show in Farenheit',
                        value: toggleButton2Value,
                        onChanged: (newValue) async {
                          setState(() => toggleButton2Value = newValue);
                          if (city == '') {
                            final latitude =
                                globalController.getLattitude().value;
                            final longitude =
                                globalController.getLongitude().value;

                            globalController.getLocationUsingCoordinates(
                              latitude,
                              longitude,
                              newValue ? 'imperial' : 'metric',
                            );
                          } else {
                            List<Location> locations =
                                await locationFromAddress(city);
                            final latitude = locations[0].latitude;
                            final longitude = locations[0].longitude;
                            globalController.getLocationUsingCoordinates(
                              latitude,
                              longitude,
                              newValue ? 'imperial' : 'metric',
                            );
                          }
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SearchFeld(
        onSubmitted: (value) async {
          if (value.isNotEmpty) {
            try {
              List<Location> locations = await locationFromAddress(value);
              if (locations.isNotEmpty) {
                List<Placemark> placemarks = await placemarkFromCoordinates(
                    locations[0].latitude, locations[0].longitude);
                Get.toNamed('search', arguments: [placemarks, value]);
              } else {
                if (!context.mounted) return;
                // Handle the case where no locations were found
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content:
                        Text('No locations found for the provided address.'),
                  ),
                );
              }
            } catch (e) {
              if (!context.mounted) return;
              // Handle any errors that occur during geocoding or placemark lookup
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('No locations found for the provided address.'),
                ),
              );
            }
          } else {
            // Handle the case where the search field is empty
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Please enter a valid address.'),
              ),
            );
          }
        },
      ),
      body: SafeArea(
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
            : Center(
                child: ListView(
                  scrollDirection: Axis.vertical,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Header(
                          searchCity: city,
                        ),
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
                      weatherDataCurrent:
                          globalController.getData().getCurrentWeather(),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    HourlyData(
                        weatherDataHourly:
                            globalController.getData().getHourlyWeather()),
                    DailyDataForecast(
                      weatherDataDaily:
                          globalController.getData().getDailyWeather(),
                    ),
                    Container(
                      height: 1,
                      color: CustomColors.dividerLine,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ComfortLevel(
                        weatherDataCurrent:
                            globalController.getData().getCurrentWeather())
                  ],
                ),
              )),
      ),
    );
  }
}
