import 'package:flutter/material.dart';

class WeatherUtils {

  /// Truncates a list to a maximum of [selectedHours] elements.
  /// Useful for displaying a limited number of hourly weather entries.
  static List<T> takeHours<T>(List? list, int selectedHours) {
    if (list == null) return [];
    if (list.length < selectedHours) return List<T>.from(list);
    return List<T>.from(list.take(selectedHours));
  }

  /// Maps a weather code to a corresponding Flutter [IconData].
  static IconData weatherIconFromCode(int? code) {
    if (code == null) return Icons.help_outline;
    if (code == 0) return Icons.wb_sunny;
    if (code == 1 || code == 2) return Icons.cloud;
    if (code == 3) return Icons.cloud_queue;
    if (code >= 45 && code <= 48) return Icons.foggy;
    if (code >= 51 && code <= 67) return Icons.grain;
    if (code >= 71 && code <= 77) return Icons.ac_unit;
    if (code >= 80 && code <= 82) return Icons.grain;
    if (code >= 95) return Icons.flash_on;
    return Icons.help_outline;
  }

  /// Computes the day number for each timestamp in [times], starting from 1 for the earliest date.
  /// Returns a list of day numbers corresponding to each entry in [times].
  static List<int> computeDayNumbers(List<dynamic> times) {
    DateTime? firstDay;
    List<int> dayNumbers = [];
    for (var t in times) {
      DateTime dt = DateTime.parse(t);
      firstDay ??= DateTime(dt.year, dt.month, dt.day);
      int dayNum = dt.difference(firstDay).inDays + 1;
      dayNumbers.add(dayNum);
    }
    return dayNumbers;
  }
  /// Returns a map containing the first value for each key in [hourData].
  /// If a list is empty or missing, the value will be null for that key.
  static Map<String, dynamic> getFirstHourlyValues(
      Map<String, List<dynamic>> hourData,
      List<String> fields,
      ) {
    final Map<String, dynamic> result = {};
    for (final field in fields) {
      final list = hourData[field];
      result[field] = (list != null && list.isNotEmpty) ? list[0] : null;
    }
    return result;
  }
}