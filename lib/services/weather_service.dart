import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  static const _baseUrl = 'https://api.open-meteo.com/v1/forecast';

  Uri _buildWeatherUrl({
    required double latitude,
    required double longitude,
    String timezone = 'Europe/Paris',
    List<String>? hourlyFields,
  }) {
    final hourlyParams = (hourlyFields ?? [
      "temperature_2m",
      "apparent_temperature",
      "relative_humidity_2m",
      "cloudcover",
      "precipitation",
      "windspeed_10m",
      "is_day"
    ]).join(',');

    final urlString = '$_baseUrl'
        '?latitude=$latitude'
        '&longitude=$longitude'
        '&current_weather=true'
        '&hourly=$hourlyParams'
        '&timezone=$timezone';

    return Uri.parse(urlString);
  }

  Future<Map<String, dynamic>> _getJsonFromUrl(Uri url) async {
    final response = await http.get(url);
    if (response.statusCode != 200) {
      throw Exception('Erreur HTTP ${response.statusCode}');
    }
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  Map<String, dynamic> _extractHourlyData(Map<String, dynamic> json) {
    final Map<String, dynamic> hourly = {};
    if (json['hourly'] != null) {
      for (var key in json['hourly'].keys) {
        hourly[key] = json['hourly'][key];
      }
    }
    return hourly;
  }

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