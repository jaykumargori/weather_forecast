import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_forecast/api/fetch_weather.dart';
import 'package:weather_forecast/models/weather_data.dart';

class GlobalController extends GetxController {
  static GlobalController get to => Get.find();

  final RxList<Placemark> _placemarks = RxList<Placemark>([]);

  List<Placemark> get placemarks => _placemarks;

  // create various variables
  final RxBool _isFahrenheit = false.obs;
  final RxBool _isDarkMode = false.obs;
  final RxBool _isLoading = true.obs;
  final RxDouble _lattitude = 0.0.obs;
  final RxDouble _longitude = 0.0.obs;
  final RxInt _currentIndex = 0.obs;

  // instance for them to be called
  RxBool get isFahrenheit => _isFahrenheit;
  RxBool get isDarkMode => _isDarkMode;
  RxBool checkLoading() => _isLoading;
  RxDouble getLattitude() => _lattitude;
  RxDouble getLongitude() => _longitude;

  final weatherData = WeatherData().obs;

  WeatherData getData() {
    return weatherData.value;
  }

  @override
  void onInit() async {
    if (_isLoading.isTrue) {
      getLocation();
    } else {
      getIndex();
    }
    final prefs = await SharedPreferences.getInstance();
    ever(_isFahrenheit, (callback) async {
      await prefs.setBool('isFahrenheit', callback);
    });
    ever(_isDarkMode, (callback) async {
      await prefs.setBool('isDarkMode', callback);
      Get.changeThemeMode(callback ? ThemeMode.dark : ThemeMode.light);
    });
    _isFahrenheit.value = prefs.getBool('isFahrenheit') ?? false;
    _isDarkMode.value = prefs.getBool('isDarkMode') ?? false;

    super.onInit();
  }

  getLocation() async {
    bool isServiceEnabled;
    LocationPermission locationPermission;

    isServiceEnabled = await Geolocator.isLocationServiceEnabled();
    // return if service is not enabled
    if (!isServiceEnabled) {
      return Future.error("Location not enabled");
    }

    // status of permission
    locationPermission = await Geolocator.checkPermission();

    if (locationPermission == LocationPermission.deniedForever) {
      return Future.error("Location permission are denied forever");
    } else if (locationPermission == LocationPermission.denied) {
      // request permission
      locationPermission = await Geolocator.requestPermission();
      if (locationPermission == LocationPermission.denied) {
        return Future.error("Location permission is denied");
      }
    }

    // getting the currentposition
    return await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high)
        .then((value) {
      // update our lattitude and longitude
      _lattitude.value = value.latitude;
      _longitude.value = value.longitude;
      // calling our weather api
      return FetchWeatherAPI()
          .processData(value.latitude, value.longitude, 'metric')
          .then((value) {
        weatherData.value = value;
        _isLoading.value = false;
      });
    });
  }

  getLocationUsingCoordinates(
    double lat,
    double long,
    String units, {
    bool forceRefresh = false,
  }) {
    return FetchWeatherAPI()
        .processData(lat, long, units, forceRefresh: forceRefresh)
        .then((value) {
      weatherData.value = value;
      _isLoading.value = false;
    });
  }

  RxInt getIndex() {
    return _currentIndex;
  }

  Future<void> search(String query, [bool redirect = true]) async {
    if (query.isEmpty) {
      Get.showSnackbar(
        const GetSnackBar(message: 'Please enter a valid address.'),
      );
      return;
    }
    try {
      final locations = await locationFromAddress(query);
      if (locations.isEmpty) {
        Get.showSnackbar(
          const GetSnackBar(
              message: 'No locations found for the provided address.'),
        );
        return;
      }
      final placemarkFuture = locations.map((location) {
        return placemarkFromCoordinates(
          locations[0].latitude,
          locations[0].longitude,
        );
      }).toList();
      final result = await Future.wait(placemarkFuture);
      final placemarks = result.expand((element) => element).toList();
      _placemarks.value = placemarks;
      if (!redirect) {
        return;
      }
      Get.toNamed('search', arguments: [placemarks, query]);
    } catch (e) {
      Get.showSnackbar(
        const GetSnackBar(
            message: 'No locations found for the provided address.'),
      );
    }
  }
}
