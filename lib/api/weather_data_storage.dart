import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_forecast/models/weather_data.dart';

class WeatherDataStorage {
  // Define a key for storing WeatherData in shared preferences.
  static const String weatherDataKey = 'weather_data';

  // Function to save WeatherData to shared preferences.
  static Future<void> saveWeatherData(WeatherData? weatherData) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData =
        weatherDataToJson(weatherData); // Convert WeatherData to JSON
    await prefs.setString(weatherDataKey, jsonData);
  }

  // Function to retrieve WeatherData from shared preferences.
  static Future<WeatherData?> getWeatherData() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData = prefs.getString(weatherDataKey);
    if (jsonData != null) {
      return weatherDataFromJson(jsonData); // Convert JSON to WeatherData
    }
    return null;
  }
}
