import 'package:flutter/material.dart';
import 'package:weather_app/apis/weather_api.dart';
import 'package:weather_app/models/weather_model.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final TextEditingController _controller = TextEditingController();
  Weather? _weather;
  String _errorMessage = '';

  /// A Scaffold that displays a text field, a button, and a column of text
  /// and an image. The text field is used to enter a city name, and the button
  /// triggers a call to the weather API to fetch the weather for the city.
  /// The column displays the city name, current temperature, a description of
  /// the current weather, and an image representing the current weather. If
  /// there is an error, the column displays the error message in red.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Weather App')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              /// City Text Field
              TextField(
                controller: _controller,
                decoration: const InputDecoration(hintText: 'Enter city name'),
              ),
              const SizedBox(height: 10),

              /// Find City Button
              ElevatedButton(
                onPressed: _fetchWeather,
                child: const Text(
                  'Get Weather',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              /// Error Message
              const SizedBox(height: 20),
              if (_errorMessage.isNotEmpty)
                Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),

              /// Weather Information
              if (_weather != null)
                Column(
                  children: [
                    Text(_weather!.cityName,
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                    Text(_weather!.temperature.toString(),
                        style: const TextStyle(fontSize: 22)),
                    Text(_weather!.description,
                        style: const TextStyle(fontSize: 18)),
                    Image.network(_weather!.icon),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// Triggers a call to the weather API to fetch the weather for the city
  /// name entered in the text field.
  ///
  /// If the text field is empty, it displays an error message asking the user
  /// to enter a city name. If the city is not found, it displays an error
  /// message indicating that the city was not found. If there is a network error
  /// or an unexpected error, it displays an error message indicating the
  /// error. If the request is successful, it displays the city name, current
  /// temperature, a description of the current weather, and an image
  /// representing the current weather.
  void _fetchWeather() async {
    if (_controller.text.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter a city name.';
      });
      return;
    }

    setState(() {
      _errorMessage = '';
      _weather = null;
    });

    try {
      final weatherService = WeatherAPI();
      final result = await weatherService.getWeather(_controller.text);

      setState(() {
        _weather = result.weather;

        switch (result.status) {
          case WeatherStatus.noCity:
            _errorMessage = 'City not found.';
            break;
          case WeatherStatus.somethingWentWrong:
            _errorMessage = 'Something went wrong.';
            break;
          case WeatherStatus.networkError:
            _errorMessage = 'Network error.';
          default:
        }
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
      });
    }
  }
}
