enum WeatherStatus {
  success,
  noCity,
  somethingWentWrong,
  networkError,
}

class WeatherResult {
  final WeatherStatus status;
  final Weather? weather;

  WeatherResult({
    required this.status,
    this.weather,
  });
}

class Weather {
  final String cityName;
  final double temperature;
  final String description;
  final String icon;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.description,
    required this.icon,
  });

  // Factory method to create a Weather object from JSON with error handling
  factory Weather.fromJson(Map<String, dynamic> json) {
    try {
      return Weather(
          cityName: json['name'] ?? 'Unknown City', // Default to 'Unknown City'
          temperature:
              (json['main']?['temp'] ?? 0.0).toDouble(), // Default to 0.0
          description: (json['weather'] != null && json['weather'].isNotEmpty)
              ? json['weather'][0]['description'] ?? 'No description'
              : 'No description', // Default to 'No description'
          icon: (json['weather'] != null && json['weather'].isNotEmpty)
              ? getIconUrl(json['weather'][0]['icon'] ?? '01d')
              : getIconUrl('01d'));
    } catch (e) {
      // Log error (optional) and provide fallback values

      return Weather(
        cityName: 'Unknown City',
        temperature: 0.0,
        description: 'No description',
        icon: '01d',
      );
    }
  }
}

String getIconUrl(String icon) {
  return "http://openweathermap.org/img/wn/$icon@2x.png";
}
