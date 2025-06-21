import 'package:flutter/material.dart';
import 'package:flutter_weather_app/widgets/theme_mode_dropdown_widget.dart';

/// A custom [AppBar] widget with a title and a theme mode toggle action.
///
/// This app bar displays a centered title and includes a [ThemeModeDropdown]
/// in the [actions] section, allowing the user to switch between system, light, and dark modes.
/// The bar uses the current theme's primary color and ensures the title is styled
/// for proper contrast.
///
/// Example usage:
/// ```dart
/// CustomAppBar(
///   themeMode: themeMode,
///   onThemeChanged: (mode) => setState(() => themeMode = mode),
///   title: "Weather",
/// )
/// ```
///
/// Fields:
/// - [themeMode]: The current [ThemeMode] selected by the user. (Required)
/// - [onThemeChanged]: Callback invoked when a new [ThemeMode] is selected. (Required)
/// - [title]: The title displayed in the app bar. Defaults to "Weather". (Optional)
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeChanged;
  final String title;

  const CustomAppBar({
    super.key,
    required this.themeMode,
    required this.onThemeChanged,
    this.title = "Weather",
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppBar(
      automaticallyImplyLeading: false,
      title: Text(
        title,
        style: theme.textTheme.titleLarge?.copyWith(
          color: theme.colorScheme.onPrimary,
        ),
      ),
      centerTitle: true,
      backgroundColor: theme.colorScheme.primary,
      actions: [
        ThemeModeDropdown(
          value: themeMode,
          onChanged: onThemeChanged,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
