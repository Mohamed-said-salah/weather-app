import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../models/weather_model.dart';

class WeatherAPI {
  final String _baseUrl = 'https://api.openweathermap.org/data/2.5/weather';
  final String _apiKey = dotenv.get('API_KEY', fallback: "");

  Future<WeatherResult> getWeather(String cityName) async {
    final url = Uri.parse('$_baseUrl?q=$cityName&appid=$_apiKey&units=metric');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        final weather = Weather.fromJson(json);
        return WeatherResult(status: WeatherStatus.success, weather: weather);
      } else if (response.statusCode == 404) {
        // City not found
        return WeatherResult(status: WeatherStatus.noCity);
      } else {
        // Something went wrong
        return WeatherResult(status: WeatherStatus.somethingWentWrong);
      }
    } catch (e) {
      // Handle network error or unexpected errors
      return WeatherResult(status: WeatherStatus.networkError);
    }
  }
}
