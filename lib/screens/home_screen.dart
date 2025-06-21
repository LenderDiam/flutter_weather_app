import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_weather_app/models/grid_item_model.dart';
import 'package:flutter_weather_app/services/weather_service.dart';
import 'package:flutter_weather_app/services/geocoding_service.dart';
import 'package:flutter_weather_app/utils/theme/custom_themes/color_scheme.dart';
import 'package:flutter_weather_app/utils/weather/weather_utils.dart';
import 'package:flutter_weather_app/widgets/custom_app_bar_widget.dart';
import 'package:flutter_weather_app/widgets/expendable_button_widget.dart';
import 'package:flutter_weather_app/widgets/generic_grid_widget.dart';
import 'package:flutter_weather_app/widgets/grid_item_tile_widget.dart';
import 'package:flutter_weather_app/widgets/hourly_forecast_card_widget.dart';
import 'package:flutter_weather_app/widgets/theme_mode_dropdown_widget.dart';

/// Home screen for the weather app.
/// Allows the user to search for a city, select from possible matches, and display weather data.
class HomeScreen extends StatefulWidget {
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeChanged;

  const HomeScreen({
    super.key,
    required this.themeMode,
    required this.onThemeChanged,
  });

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

  final WeatherService weatherService = WeatherService();
  final GeocodingService geocodingService = GeocodingService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _cityController = TextEditingController();
  String? displayCity;

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  /// Fetches weather data for a given latitude and longitude.
  ///
  /// Updates the state with weather data or error messages.
  Future<void> fetchWeather({
    required double latitude,
    required double longitude,
  }) async {
    setState(() {
      isLoading = true;
      error = null;
      current = null;
      hourly = null;
    });

    try {
      final data = await weatherService.fetchWeather(
        latitude: latitude,
        longitude: longitude,
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
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  /// Handles the city search process, including candidate selection if needed.
  ///
  /// - Fetches possible city candidates.
  /// - If one candidate: fetch weather directly.
  /// - If multiple: prompts user to select.
  /// - If none: shows error.
  Future<void> handleCitySearch() async {
    final cityName = _cityController.text.trim();
    if (cityName.isEmpty) {
      setState(() {
        error = "Please enter a city name.";
      });
      return;
    }

    setState(() {
      isLoading = true;
      error = null;
      displayCity = null;
      current = null;
      hourly = null;
    });

    List<Map<String, dynamic>> candidates = [];
    try {
      candidates = await geocodingService.fetchCityCandidates(cityName);
    } on SocketException {
      if (!mounted) return;
      setState(() {
        error = "Vérifiez votre connexion Internet.";
        isLoading = false;
      });
      return;
    } catch (e) {
      if (!mounted) return;
      setState(() {
        error = "Erreur inconnue: $e";
        isLoading = false;
      });
      return;
    }

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

    if (candidates.isEmpty) {
      setState(() {
        error = "City not found.";
      });
      return;
    }

    Map<String, dynamic>? chosenCity;
    if (candidates.length == 1) {
      // Only one candidate, use it directly.
      chosenCity = candidates[0];
    } else {
      // Multiple candidates, ask the user to choose.
      chosenCity = await showDialog<Map<String, dynamic>>(
        context: context,
        builder: (context) => SimpleDialog(
          title: const Text('Select the correct city'),
          backgroundColor:
              Theme.of(context).colorScheme.surfaceContainerHighest,
          children: candidates
              .map((city) => SimpleDialogOption(
                    child: Text(WeatherUtils.formatDisplayCityFromMap(city)),
                    onPressed: () => Navigator.pop(context, city),
                  ))
              .toList(),
        ),
      );
      if (!mounted) return;
      if (chosenCity == null) {
        // User dismissed dialog
        return;
      }
    }

    setState(() {
      displayCity = WeatherUtils.formatDisplayCityFromMap(chosenCity!);
      isLoading = true;
    });

    await fetchWeather(
      latitude: chosenCity['latitude'],
      longitude: chosenCity['longitude'],
    );

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: CustomAppBar(
        themeMode: widget.themeMode,
        onThemeChanged: widget.onThemeChanged,
        title: "Weather",
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
                    Text(
                      error!,
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(color: AppColors.error),
                      textAlign: TextAlign.center,
                    )
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

  /// Renders the form section for entering city name and selecting interval.
  Widget _formSection(ThemeData theme) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _cityController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'City',
              suffixIcon: Icon(Icons.location_city),
            ),
            onChanged: (text) => city = text,
            textInputAction: TextInputAction.search,
            onFieldSubmitted: (_) {
              if (!isLoading) handleCitySearch();
            },
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<int>(
            icon: const Icon(Icons.arrow_drop_down),
            iconEnabledColor: theme.colorScheme.secondary,
            dropdownColor: theme.colorScheme.tertiary,
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
            onChanged: isLoading
                ? null
                : (value) {
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
              onPressed: isLoading ? null : handleCitySearch,
            ),
          ),
        ],
      ),
    );
  }

  /// Renders the main weather display section after successful city search.
  Widget _weatherDisplay(ThemeData theme) {
    final hourData = WeatherUtils.getHourlySeries(
      hourly,
      hourlyFields,
      selectedHours,
    );

    return Column(
      children: [
        if (displayCity != null && displayCity!.trim().isNotEmpty) ...[
          Text(
            displayCity!,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.secondary,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
        ],
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

  /// Renders the grid with main weather data such as temperature, wind, humidity, etc.
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
          icon: current!['is_day'] == 1 ? Icons.sunny : Icons.nightlight,
          label: "Time",
          value: current!['is_day'] == 1 ? "Day" : "Night",
        ),
    ];

    return GenericGrid<GridItem>(
      items: items,
      itemBuilder: (context, item, index) => GridItemTile(
        item: item,
        index: index,
        theme: theme,
      ),
    );
  }

  /// Renders the expandable button to show or hide the hourly forecast.
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
      textStyle: theme.textTheme.bodyMedium,
    );
  }

  /// Renders the horizontal list of hourly forecast cards.
  Widget _hourlyForecastList(
    ThemeData theme,
    Map<String, List<dynamic>> hourData,
  ) {
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
