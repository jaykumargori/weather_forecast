import 'dart:convert';

import 'package:weather_forecast/models/weather_data_current.dart';
import 'package:weather_forecast/models/weather_data_daily.dart';
import 'package:weather_forecast/models/weather_data_hourly.dart';

class WeatherData {
  final WeatherDataCurrent? current;

  final WeatherDataHourly? hourly;

  final WeatherDataDaily? daily;

  WeatherData([this.current, this.hourly, this.daily]);

  // function to fetch these values
  WeatherDataCurrent getCurrentWeather() => current!;
  WeatherDataHourly getHourlyWeather() => hourly!;
  WeatherDataDaily getDailyWeather() => daily!;
}

String weatherDataToJson(WeatherData? weatherData) {
  final Map<String, dynamic> data = {
    'current': weatherData?.current?.toJson(),
    'hourly': weatherData?.hourly?.toJson(),
    'daily': weatherData?.daily?.toJson(),
    'cacheTime': DateTime.now().millisecondsSinceEpoch,
  };
  return jsonEncode(data);
}

// Convert JSON to WeatherData.
WeatherData weatherDataFromJson(String jsonString) {
  final Map<String, dynamic> data = jsonDecode(jsonString);
  final WeatherDataCurrent current =
      WeatherDataCurrent.fromJson(data['current']);
  final WeatherDataHourly hourly = WeatherDataHourly.fromJson(data['hourly']);
  final WeatherDataDaily daily = WeatherDataDaily.fromJson(data['daily']);
  return WeatherData(current, hourly, daily);
}
