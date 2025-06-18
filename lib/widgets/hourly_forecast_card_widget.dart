import 'package:flutter/material.dart';

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
              Icon(icon, size: 21, color: theme.colorScheme.primary),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  '$label: $value${unit ?? ""}',
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
      addRow(Icons.thermostat_outlined, "Ressentie", "${hourData['apparent_temperature']![index]}", unit: "°C");
    }
    if (hourData['relative_humidity_2m']!.length > index) {
      addRow(Icons.water_drop, "Humidité", "${hourData['relative_humidity_2m']![index]}", unit: "%");
    }
    if (hourData['cloudcover']!.length > index) {
      addRow(Icons.cloud, "Nuages", "${hourData['cloudcover']![index]}", unit: "%");
    }
    if (hourData['precipitation']!.length > index) {
      addRow(Icons.grain, "Précip.", "${hourData['precipitation']![index]}", unit: "mm");
    }
    if (hourData['windspeed_10m']!.length > index) {
      addRow(Icons.air, "Vent", "${hourData['windspeed_10m']![index]}", unit: "km/h");
    }
    if (hourData['is_day']!.length > index) {
      final isDay = hourData['is_day']![index] == 1;
      addRow(isDay ? Icons.sunny : Icons.nightlight_round, "Période", isDay ? "Jour" : "Nuit");
    }

    return Card(
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