import 'package:flutter/material.dart';

/// A compact dropdown widget for selecting the application's [ThemeMode].
///
/// This widget is designed for use in app bars or other constrained layouts where space is limited.
/// It displays an icon for the selected theme mode (system, light, or dark), and when tapped,
/// presents a menu with both icon and label for each theme mode option.
///
/// Example usage:
/// ```dart
/// ThemeModeDropdown(
///   value: themeMode,
///   onChanged: (mode) => setState(() => themeMode = mode),
/// )
/// ```
///
/// Fields:
/// - [value]: The currently selected [ThemeMode]. (Required)
/// - [onChanged]: Callback invoked when the user selects a different [ThemeMode]. (Required)
///
/// Design details:
/// - The dropdown is wrapped in a [SizedBox] to enforce a fixed width for compact display.
/// - The [selectedItemBuilder] customizes the appearance of the selected value, showing only an icon aligned with the dropdown arrow.
/// - Menu items display both icon and text for clarity.
/// - The underline is removed for a cleaner appearance in toolbars.
/// - The dropdown's background color, icon color, and text style adapt to the current theme.
///
/// This widget is suitable for theme toggles in settings menus, app bars, or anywhere a concise theme selection control is needed.
class ThemeModeDropdown extends StatelessWidget {
  final ThemeMode value;
  final ValueChanged<ThemeMode> onChanged;

  const ThemeModeDropdown({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: 80,
      child: DropdownButton<ThemeMode>(
        value: value,
        onChanged: (mode) {
          if (mode != null) onChanged(mode);
        },
        dropdownColor: theme.colorScheme.surfaceContainerHighest,
        iconEnabledColor: theme.colorScheme.onPrimary,
        style: theme.textTheme.bodyMedium,
        isExpanded: true,
        elevation: 0,
        underline: const SizedBox(),
        selectedItemBuilder: (context) {
          return [
            Row(
              children: [
                const SizedBox(width: 30),
                Icon(Icons.settings,
                    color: theme.colorScheme.onPrimary, size: 20),
              ],
            ),
            Row(
              children: [
                const SizedBox(width: 30),
                Icon(Icons.light_mode,
                    color: theme.colorScheme.onPrimary, size: 20),
              ],
            ),
            Row(
              children: [
                const SizedBox(width: 30),
                Icon(Icons.dark_mode,
                    color: theme.colorScheme.onPrimary, size: 20),
              ],
            ),
          ];
        },
        items: [
          DropdownMenuItem(
            value: ThemeMode.system,
            child: Row(
              children: [
                Icon(Icons.settings,
                    color: theme.colorScheme.primary, size: 18),
                const SizedBox(width: 4),
                Text(
                  'Auto',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          DropdownMenuItem(
            value: ThemeMode.light,
            child: Row(
              children: [
                Icon(Icons.light_mode,
                    color: theme.colorScheme.primary, size: 18),
                const SizedBox(width: 4),
                Text(
                  'Light',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          DropdownMenuItem(
            value: ThemeMode.dark,
            child: Row(
              children: [
                Icon(Icons.dark_mode,
                    color: theme.colorScheme.primary, size: 18),
                const SizedBox(width: 4),
                Text(
                  'Dark',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
