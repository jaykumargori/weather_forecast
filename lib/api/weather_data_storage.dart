import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_forecast/models/weather_data.dart';

class WeatherDataStorage {
  // Define a key for storing WeatherData in shared preferences.
  static const String weatherDataKey = 'weather_data_test';

  static String createCacheKey(lat, lon, units) {
    return '$weatherDataKey,$lat,$lon,$units';
  }

  // Function to save WeatherData to shared preferences.
  static Future<void> saveWeatherData(
      WeatherData? weatherData, lat, lon, units) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData =
        weatherDataToJson(weatherData); // Convert WeatherData to JSON
    await prefs.setString(createCacheKey(lat, lon, units), jsonData);
  }

  // Function to retrieve WeatherData from shared preferences.
  static Future<WeatherData?> getWeatherData(lat, lon, units) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData = prefs.getString(createCacheKey(lat, lon, units));
    if (jsonData != null && isCacheValid(jsonData)) {
      return weatherDataFromJson(jsonData); // Convert JSON to WeatherData
    }
    clearWeatherData(lat, lon, units);
    return null;
  }

  static bool isCacheValid(String jsonData) {
    final Map<String, dynamic> json = jsonDecode(jsonData);
    final int cacheTime = json['cacheTime'];
    final int currentTime = DateTime.now().millisecondsSinceEpoch;
    if (currentTime - cacheTime > 1000 * 60 * 60) {
      // Cache is valid for 1 hour.
      return false;
    }
    return true;
  }

  static Future<void> clearWeatherData(lat, lon, units) async {
    final prefs = await SharedPreferences.getInstance();
    final exists = prefs.containsKey(createCacheKey(lat, lon, units));
    if (!exists) return;
    await prefs.remove(createCacheKey(lat, lon, units));
  }
}
