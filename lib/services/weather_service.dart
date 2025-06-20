import 'dart:convert';
import 'package:http/http.dart' as http;

/// A service for fetching weather data from the Open-Meteo API.
class WeatherService {
  /// List of weather fields to fetch for hourly data.
  static const List<String> hourlyFields = [
    "temperature_2m",
    "apparent_temperature",
    "relative_humidity_2m",
    "cloudcover",
    "precipitation",
    "windspeed_10m",
    "is_day"
  ];

  /// Comma-separated parameters for the hourly API request.
  static String get hourlyParams => hourlyFields.join(',');

  /// Base URL for the Open-Meteo weather API.
  static const _baseUrl = 'https://api.open-meteo.com/v1/forecast';

  /// Builds a URL for fetching weather data from Open-Meteo.
  ///
  /// [latitude] and [longitude] specify the location.
  /// [timezone] sets the timezone for the data (default: 'Europe/Paris').
  Uri _buildWeatherUrl({
    required double latitude,
    required double longitude,
    String timezone = 'Europe/Paris',
  }) {
    final urlString = '$_baseUrl'
        '?latitude=$latitude'
        '&longitude=$longitude'
        '&current_weather=true'
        '&hourly=$hourlyParams'
        '&timezone=$timezone';

    return Uri.parse(urlString);
  }

  /// Performs an HTTP GET request to the given [url] and returns the decoded JSON data.
  ///
  /// Throws an [Exception] if the HTTP status code is not 200.
  Future<Map<String, dynamic>> _getJsonFromUrl(Uri url) async {
    final response = await http.get(url);
    if (response.statusCode != 200) {
      throw Exception('HTTP Error ${response.statusCode}');
    }
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  /// Extracts and returns the hourly weather data from the API response [json].
  ///
  /// Returns a map with keys corresponding to hourly data fields.
  Map<String, dynamic> _extractHourlyData(Map<String, dynamic> json) {
    final Map<String, dynamic> hourly = {};
    if (json['hourly'] != null) {
      for (var key in json['hourly'].keys) {
        hourly[key] = json['hourly'][key];
      }
    }
    return hourly;
  }

  /// Fetches weather data for the given [latitude] and [longitude].
  ///
  /// Returns a map containing:
  ///   - 'current': The current weather data.
  ///   - 'hourly': The hourly weather data extracted by [_extractHourlyData].
  ///
  /// Throws an [Exception] if there is a network or API error.
  Future<Map<String, dynamic>> fetchWeather({
    required double latitude,
    required double longitude,
  }) async {
    final url = _buildWeatherUrl(
      latitude: latitude,
      longitude: longitude,
    );

    final json = await _getJsonFromUrl(url);

    return {
      'current': json['current_weather'],
      'hourly': _extractHourlyData(json),
    };
  }
}
