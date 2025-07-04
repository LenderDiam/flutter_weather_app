import 'package:flutter/material.dart';

/// A card widget that displays detailed hourly weather forecast information,
/// including temperature, wind speed, cloud cover, precipitation, humidity, and time of day.
///
/// Typically used in weather apps to present hourly data for a specific day,
/// supporting visual distinction via alternating background color.
///
/// Example usage:
/// ```dart
/// HourlyForecastCard(
///   theme: Theme.of(context),
///   hourData: weatherData,
///   dayNumber: 2,
///   time: '2025-06-20T13:00:00',
///   index: 0,
/// )
/// ```
///
/// Fields:
/// - [theme]: The [ThemeData] used for styling the card and its contents. (Required)
/// - [hourData]: A map containing lists of hourly weather data keyed by variable names, e.g., 'temperature_2m'. (Required)
/// - [dayNumber]: The day number to display (e.g., 1 for today, 2 for tomorrow). (Required)
/// - [time]: The time value for the forecast (should be parsable to a string). (Required)
/// - [index]: The position in the hourly list, used for alternating the card's background color. (Required)

class HourlyForecastCard extends StatelessWidget {
  final ThemeData theme;
  final Map<String, List<dynamic>> hourData;
  final int dayNumber;
  final dynamic time;
  final int index;

  const HourlyForecastCard({
    super.key,
    required this.theme,
    required this.hourData,
    required this.dayNumber,
    required this.time,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final timeStr = time.toString();
    final hour = timeStr.substring(11, 16);

    List<Widget> dataRows = [];

    void addRow(IconData icon, String label, String value, {String? unit}) {
      dataRows.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Icon(icon, size: 21, color: theme.colorScheme.secondary),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  '$label : $value${unit ?? ""}',
                  style: theme.textTheme.bodyMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (hourData['temperature_2m']!.length > index) {
      addRow(Icons.thermostat, "Temp", "${hourData['temperature_2m']![index]}", unit: "°C");
    }
    if (hourData['apparent_temperature']!.length > index) {
      addRow(Icons.thermostat_outlined, "Feels like", "${hourData['apparent_temperature']![index]}", unit: "°C");
    }
    if (hourData['windspeed_10m']!.length > index) {
      addRow(Icons.air, "Wind", "${hourData['windspeed_10m']![index]}", unit: "km/h");
    }
    if (hourData['cloudcover']!.length > index) {
      addRow(Icons.cloud, "Cloud cover", "${hourData['cloudcover']![index]}", unit: "%");
    }
    if (hourData['precipitation']!.length > index) {
      addRow(Icons.grain, "Precip.", "${hourData['precipitation']![index]}", unit: "mm");
    }
    if (hourData['relative_humidity_2m']!.length > index) {
      addRow(Icons.water_drop, "Humidity", "${hourData['relative_humidity_2m']![index]}", unit: "%");
    }
    if (hourData['is_day']!.length > index) {
      final isDay = hourData['is_day']![index] == 1;
      addRow(isDay ? Icons.sunny : Icons.nightlight_round, "Time", isDay ? "Day" : "Night");
    }

    return Card(
      color: index % 2 == 1 ? theme.colorScheme.surfaceContainerHighest : null,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 300,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Jour $dayNumber",
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.secondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              hour,
              style: theme.textTheme.headlineMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            ...dataRows,
          ],
        ),
      ),
    );
  }
}