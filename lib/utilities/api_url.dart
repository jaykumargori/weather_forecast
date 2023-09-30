import 'package:weather_forecast/api/api_key.dart';

String apiURL(var lat, var lon, var units) {
  String url;

  url =
      "https://api.openweathermap.org/data/3.0/onecall?lat=$lat&lon=$lon&appid=$apiKey&units=$units&exclude=minutely";
  return url;
}
