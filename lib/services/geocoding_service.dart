import 'dart:convert';
import 'package:http/http.dart' as http;

/// A service for geocoding city names using the Open-Meteo Geocoding API.
/// This service can fetch multiple candidates for a city name in case of ambiguity.
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
    String language = 'en',
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

  /// Extracts a list of candidate cities from the API response.
  ///
  /// Returns a list of maps with city information (name, latitude, longitude, country, admin1).
  List<Map<String, dynamic>> _extractCityCandidates(Map<String, dynamic> json) {
    final results = json['results'];
    if (results != null && results is List && results.isNotEmpty) {
      return results.map<Map<String, dynamic>>((city) => {
        'name': city['name'],
        'latitude': city['latitude'],
        'longitude': city['longitude'],
        'country': city['country'],
        'admin1': city['admin1'],
      }).toList();
    }
    return [];
  }

  /// Fetches multiple city candidates for a given [cityName].
  ///
  /// Returns a list of possible city matches, or an empty list if none are found.
  Future<List<Map<String, dynamic>>> fetchCityCandidates(String cityName, {int count = 10}) async {
    final url = _buildGeocodingUrl(cityName: cityName, count: count);
    final json = await _getJsonFromUrl(url);
    return _extractCityCandidates(json);
  }
}