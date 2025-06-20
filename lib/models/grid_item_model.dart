import 'package:flutter/cupertino.dart';

/// A model representing an item to be displayed in a grid, containing an icon,
/// a label, a value, and an optional unit.
///
/// Typically used for dashboard tiles, statistics panels, or weather summaries,
/// where each grid cell summarizes a specific metric or property.
///
/// Example usage:
/// ```dart
/// GridItem(
///   icon: CupertinoIcons.thermometer,
///   label: "Temperature",
///   value: "24",
///   unity: "°C",
/// )
/// ```
///
/// Fields:
/// - [icon]: The icon to visually represent the item. (Required)
/// - [label]: A brief description or name of the item. (Required)
/// - [value]: The value to display, as a string. (Required)
/// - [unity]: The unit associated with the value, such as "°C" or "km/h". (Optional)

class GridItem {
  final IconData icon;
  final String label;
  final String value;
  final String? unity;

  const GridItem({
    required this.icon,
    required this.label,
    required this.value,
    this.unity,
  });
}