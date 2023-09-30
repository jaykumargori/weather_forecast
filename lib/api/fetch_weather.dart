import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weather_forecast/api/weather_data_storage.dart';
import 'package:weather_forecast/models/weather_data.dart';
import 'package:weather_forecast/models/weather_data_current.dart';
import 'package:weather_forecast/models/weather_data_daily.dart';
import 'package:weather_forecast/models/weather_data_hourly.dart';
import 'package:weather_forecast/utilities/api_url.dart';

class FetchWeatherAPI {
  WeatherData? weatherData;

  // procecssing the data from response -> to json
  Future<WeatherData> processData(lat, lon, units,
      {forceRefresh = false}) async {
    if (!forceRefresh) {
      final savedWeatherData =
          await WeatherDataStorage.getWeatherData(lat, lon, units);
      if (savedWeatherData != null) {
        return savedWeatherData;
      }
    }

    try {
      var response = await http.get(Uri.parse(apiURL(lat, lon, units)));

      if (response.statusCode == 200) {
        var jsonString = jsonDecode(response.body);
        weatherData = WeatherData(
            WeatherDataCurrent.fromJson(jsonString),
            WeatherDataHourly.fromJson(jsonString),
            WeatherDataDaily.fromJson(jsonString));
        await WeatherDataStorage.saveWeatherData(weatherData, lat, lon, units);
        return weatherData!;
      } else {
        // Handle non-200 status codes here, e.g., by throwing an exception
        throw Exception('Failed to fetch weather data: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exceptions here, e.g., network errors or JSON parsing errors
      throw Exception('Failed to fetch weather data: $e');
    }
  }
}
