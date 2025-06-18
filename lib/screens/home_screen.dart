import 'package:flutter/material.dart';
import 'package:flutter_weather_app/models/grid_item_model.dart';
import 'package:flutter_weather_app/services/weather_service.dart';
import 'package:flutter_weather_app/utils/theme/custom_themes/color_scheme.dart';
import 'package:flutter_weather_app/utils/weather/weather_utils.dart';
import 'package:flutter_weather_app/widgets/expendable_button_widget.dart';
import 'package:flutter_weather_app/widgets/generic_grid_widget.dart';
import 'package:flutter_weather_app/widgets/grid_item_tile_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? city;
  Map<String, dynamic>? current;
  Map<String, dynamic>? hourly;
  bool isLoading = false;
  String? error;
  int selectedHours = 24;
  bool showHourly = false;
  final List<String> hourlyFields = WeatherService.hourlyFields;

  final weatherService = WeatherService();
  final _formKey = GlobalKey<FormState>();
  final _cityController = TextEditingController();

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  Future<void> fetchWeather() async {
    setState(() {
      isLoading = true;
      error = null;
      current = null;
      hourly = null;
    });

    try {
      // TODO: replace with geocoding city -> lat/lon
      final data = await weatherService.fetchWeather(
        latitude: 48.8566,
        longitude: 2.3522,
      );
      setState(() {
        current = data['current'];
        hourly = data['hourly'];
      });
    } catch (e) {
      setState(() {
        error = 'Failed to load weather data';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Weather",
          style: theme.textTheme.titleLarge?.copyWith(
            color: theme.colorScheme.onPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _formSection(theme),
                  const SizedBox(height: 28),
                  if (isLoading)
                    const CircularProgressIndicator()
                  else if (error != null)
                    Text(error!,
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(color: AppColors.error))
                  else if (current != null && hourly != null)
                    _weatherDisplay(theme)
                  else
                    const Text(
                      "Please enter the parameters and click \"Get weather\"",
                      textAlign: TextAlign.center,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _formSection(ThemeData theme) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _cityController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'City (not used yet)',
              suffixIcon: Icon(Icons.location_city),
            ),
            onChanged: (text) => city = text,
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<int>(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Interval",
            ),
            value: selectedHours,
            items: const [
              DropdownMenuItem(value: 24, child: Text('24h')),
              DropdownMenuItem(value: 48, child: Text('48h')),
              DropdownMenuItem(value: 72, child: Text('72h')),
            ],
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  selectedHours = value;
                });
              }
            },
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.search),
              label: const Text("Get weather"),
              onPressed: isLoading ? null : fetchWeather,
            ),
          ),
        ],
      ),
    );
  }

  Widget _weatherDisplay(ThemeData theme) {
    return Column(
      children: [
        Icon(
          WeatherUtils.weatherIconFromCode(current!['weathercode']),
          size: 110,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(height: 18),
        Text(
          "${current!['temperature']}°C",
          style: theme.textTheme.headlineLarge?.copyWith(fontSize: 58),
        ),
        const SizedBox(height: 24),
        _mainDataGrid(theme),
        const SizedBox(height: 24),
        _hourlyButton(theme),
        if (showHourly) _hourlyForecastList(theme),
      ],
    );
  }

  Widget _mainDataGrid(ThemeData theme) {
    final items = <GridItem>[
      GridItem(
        icon: Icons.air,
        label: "Wind",
        value: "${current!['windspeed']}",
        unity: "km/h",
      ),
      if (WeatherUtils.takeHours(hourly!['apparent_temperature'], selectedHours)
          .isNotEmpty)
        GridItem(
          icon: Icons.thermostat,
          label: "Feels like",
          value:
              "${WeatherUtils.takeHours(hourly!['apparent_temperature'], selectedHours)[0]}",
          unity: "°C",
        ),
      if (WeatherUtils.takeHours(hourly!['cloudcover'], selectedHours)
          .isNotEmpty)
        GridItem(
          icon: Icons.cloud,
          label: "Cloud cover",
          value:
              "${WeatherUtils.takeHours(hourly!['cloudcover'], selectedHours)[0]}",
          unity: "%",
        ),
      if (WeatherUtils.takeHours(hourly!['relative_humidity_2m'], selectedHours)
          .isNotEmpty)
        GridItem(
          icon: Icons.water_drop,
          label: "Humidity",
          value:
              "${WeatherUtils.takeHours(hourly!['relative_humidity_2m'], selectedHours)[0]}",
          unity: "%",
        ),
      if (WeatherUtils.takeHours(hourly!['precipitation'], selectedHours)
          .isNotEmpty)
        GridItem(
          icon: Icons.grain,
          label: "Precip.",
          value:
              "${WeatherUtils.takeHours(hourly!['precipitation'], selectedHours)[0]}",
          unity: "mm",
        ),
      if (WeatherUtils.takeHours(hourly!['is_day'], selectedHours).isNotEmpty)
        GridItem(
          icon: hourly!['is_day'] == 1 ? Icons.sunny : Icons.nightlight,
          label: "Time",
          value: hourly!['is_day'] == 1 ? "Day" : "Night",
        ),
    ];
    return GenericGrid<GridItem>(
      items: items,
      itemBuilder: (context, item) => GridItemTile(item: item, theme: theme),
    );
  }

  Widget _hourlyButton(ThemeData theme) {
    return ExpandableButton(
      expanded: showHourly,
      expandedLabel: "Hide hourly forecast",
      collapsedLabel: "Show hourly forecast",
      onPressed: () {
        setState(() {
          showHourly = !showHourly;
        });
      },
      iconColor: theme.colorScheme.secondary,
      textStyle: theme.textTheme.bodyMedium,
    );
  }

  Widget _hourlyForecastList(ThemeData theme) {
    final times = WeatherUtils.takeHours(hourly!['time'], selectedHours);
    if (times.isEmpty) {
      return const Text("No hourly forecast available for this interval.");
    }


    DateTime? firstDay;
    List<int> dayNumbers = [];
    for (var t in times) {
      DateTime dt = DateTime.parse(t);
      firstDay ??= DateTime(dt.year, dt.month, dt.day);
      int dayNum = dt.difference(firstDay).inDays + 1;
      dayNumbers.add(dayNum);
    }

    return SizedBox(
      height: 350,
      width: double.infinity,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: times.length,
        itemBuilder: (context, i) {
          final timeStr = times[i].toString();
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

          final temp = WeatherUtils.takeHours(hourly!['temperature_2m'], selectedHours);
          if (temp.length > i) {
            addRow(Icons.thermostat, "Temp", "${temp[i]}", unit: "°C");
          }
          final apparent = WeatherUtils.takeHours(hourly!['apparent_temperature'], selectedHours);
          if (apparent.length > i) {
            addRow(Icons.thermostat_outlined, "Ressentie", "${apparent[i]}", unit: "°C");
          }
          final humidity = WeatherUtils.takeHours(hourly!['relative_humidity_2m'], selectedHours);
          if (humidity.length > i) {
            addRow(Icons.water_drop, "Humidité", "${humidity[i]}", unit: "%");
          }
          final cloud = WeatherUtils.takeHours(hourly!['cloudcover'], selectedHours);
          if (cloud.length > i) {
            addRow(Icons.cloud, "Nuages", "${cloud[i]}", unit: "%");
          }
          final precip = WeatherUtils.takeHours(hourly!['precipitation'], selectedHours);
          if (precip.length > i) {
            addRow(Icons.grain, "Précip.", "${precip[i]}", unit: "mm");
          }
          final wind = WeatherUtils.takeHours(hourly!['windspeed_10m'], selectedHours);
          if (wind.length > i) {
            addRow(Icons.air, "Vent", "${wind[i]}", unit: "km/h");
          }

          // Optionnel : afficher si c'est le jour ou la nuit avec un icône
          final isDay = WeatherUtils.takeHours(hourly!['is_day'], selectedHours);
          if (isDay.length > i) {
            addRow(
                isDay[i] == 1 ? Icons.sunny : Icons.nightlight_round,
                "Période",
                isDay[i] == 1 ? "Jour" : "Nuit"
            );
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
                  // Affichage Jour et Heure
                  Text(
                    "Jour ${dayNumbers[i]}",
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
        },
      ),
    );
  }
}
