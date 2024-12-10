import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../models/weather_model.dart';

class WeatherAPI {
  final String _baseUrl = 'https://api.openweathermap.org/data/2.5/weather';
  final String _apiKey = dotenv.get('API_KEY', fallback: "");

  /// Fetches the current weather data for a specified city.
  ///
  /// This method sends an HTTP GET request to the OpenWeatherMap API using
  /// the provided city name. If the request is successful, it decodes the
  /// JSON response to create a [Weather] object and returns a [WeatherResult]
  /// with a [WeatherStatus.success] status.
  ///
  /// If the specified city is not found, it returns a [WeatherResult] with a
  /// [WeatherStatus.noCity] status. For any other errors, it returns a
  /// [WeatherResult] with a [WeatherStatus.somethingWentWrong] status.
  ///
  /// In case of a network error or unexpected exception, it returns a
  /// [WeatherResult] with a [WeatherStatus.networkError] status.
  ///
  /// [cityName]: The name of the city to fetch weather data for.
  ///
  /// Returns a [Future] that resolves to a [WeatherResult] containing the
  /// status and weather data.
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
