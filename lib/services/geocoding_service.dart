import 'dart:convert';
import 'package:http/http.dart' as http;

/// A service for geocoding city names using the Open-Meteo Geocoding API.
class GeocodingService {
  static const _baseUrl = 'https://geocoding-api.open-meteo.com/v1/search';

  /// Builds the URL for the geocoding API call.
  ///
  /// [cityName] - The name of the city to search for.
  /// [language] - The language for the results (default: 'fr').
  /// [count] - The number of results to return (default: 1).
  /// [format] - The response format (default: 'json').
  Uri _buildGeocodingUrl({
    required String cityName,
    String language = 'fr',
    int count = 1,
    String format = 'json',
  }) {
    final urlString = '$_baseUrl'
        '?name=${Uri.encodeComponent(cityName)}'
        '&count=$count'
        '&language=$language'
        '&format=$format';

    return Uri.parse(urlString);
  }

  /// Performs a HTTP GET request and returns the decoded JSON as a map.
  ///
  /// Throws an [Exception] if the HTTP response status is not 200.
  Future<Map<String, dynamic>> _getJsonFromUrl(Uri url) async {
    final response = await http.get(url);
    if (response.statusCode != 200) {
      throw Exception('HTTP Error ${response.statusCode}');
    }
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  /// Extracts the first city result from the API response.
  ///
  /// Returns a map with city information (name, latitude, longitude, country, admin1),
  /// or null if no city was found.
  Map<String, dynamic>? _extractFirstCity(Map<String, dynamic> json) {
    final results = json['results'];
    if (results != null && results is List && results.isNotEmpty) {
      final city = results[0];
      return {
        'name': city['name'],
        'latitude': city['latitude'],
        'longitude': city['longitude'],
        'country': city['country'],
        'admin1': city['admin1'],
      };
    }
    return null;
  }

  /// Geocodes a city name and returns a map with its coordinates and info.
  ///
  /// Returns `null` if the city is not found.
  Future<Map<String, dynamic>?> fetchCityCoordinates(String cityName) async {
    final url = _buildGeocodingUrl(cityName: cityName);
    final json = await _getJsonFromUrl(url);
    return _extractFirstCity(json);
  }
}