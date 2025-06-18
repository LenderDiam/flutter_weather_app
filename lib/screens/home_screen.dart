import 'package:flutter/material.dart';
import 'package:flutter_weather_app/models/grid_item_model.dart';
import 'package:flutter_weather_app/services/weather_service.dart';
import 'package:flutter_weather_app/utils/theme/custom_themes/color_scheme.dart';
import 'package:flutter_weather_app/utils/weather/weather_utils.dart';
import 'package:flutter_weather_app/widgets/expendable_button_widget.dart';
import 'package:flutter_weather_app/widgets/generic_grid_widget.dart';
import 'package:flutter_weather_app/widgets/grid_item_tile_widget.dart';
import 'package:flutter_weather_app/widgets/hourly_forecast_card_widget.dart';

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
    final hourData = WeatherUtils.getHourlySeries(
      hourly,
      hourlyFields,
      selectedHours,
    );

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
        _mainDataGrid(theme, hourData),
        const SizedBox(height: 24),
        _hourlyButton(theme),
        if (showHourly) _hourlyForecastList(theme, hourData),
      ],
    );
  }

  Widget _mainDataGrid(ThemeData theme, Map<String, List<dynamic>> hourData) {
    final firstValues = WeatherUtils.getFirstHourlyValues(
      hourData,
      hourlyFields,
    );

    final items = <GridItem>[
      if (firstValues['apparent_temperature'] != null)
        GridItem(
          icon: Icons.thermostat,
          label: "Feels like",
          value: "${firstValues['apparent_temperature']}",
          unity: "°C",
        ),
      GridItem(
        icon: Icons.air,
        label: "Wind",
        value: "${current!['windspeed']}",
        unity: "km/h",
      ),
      if (firstValues['cloudcover'] != null)
        GridItem(
          icon: Icons.cloud,
          label: "Cloud cover",
          value: "${firstValues['cloudcover']}",
          unity: "%",
        ),
      if (firstValues['precipitation'] != null)
        GridItem(
          icon: Icons.grain,
          label: "Precip.",
          value: "${firstValues['precipitation']}",
          unity: "mm",
        ),
      if (firstValues['relative_humidity_2m'] != null)
        GridItem(
          icon: Icons.water_drop,
          label: "Humidity",
          value: "${firstValues['relative_humidity_2m']}",
          unity: "%",
        ),
      if (firstValues['is_day'] != null)
        GridItem(
          icon: firstValues['is_day'] == 1 ? Icons.sunny : Icons.nightlight,
          label: "Time",
          value: firstValues['is_day'] == 1 ? "Day" : "Night",
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

  Widget _hourlyForecastList(
      ThemeData theme, Map<String, List<dynamic>> hourData) {
    final times = WeatherUtils.takeHours(hourly!['time'], selectedHours);
    if (times.isEmpty) {
      return const Text("No hourly forecast available for this interval.");
    }

    final dayNumbers = WeatherUtils.computeDayNumbers(times);

    return SizedBox(
      height: 350,
      width: double.infinity,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: times.length,
        itemBuilder: (context, i) => HourlyForecastCard(
          theme: theme,
          hourData: hourData,
          dayNumber: dayNumbers[i],
          time: times[i],
          index: i,
        ),
      ),
    );
  }
}
