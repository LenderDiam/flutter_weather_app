import 'package:flutter/material.dart';
import 'package:flutter_weather_app/models/grid_item_model.dart';

/// A tile widget for displaying a [GridItem] in a grid layout, showing its icon, label, and value.
///
/// Typically used within a grid to present metrics, statistics, or properties with consistent styling.
/// Alternates background color on odd/even indices for visual distinction.
///
/// Example usage:
/// ```dart
/// GridItemTile(
///   item: GridItem(
///     icon: CupertinoIcons.thermometer,
///     label: "Temperature",
///     value: "24",
///     unity: "°C",
///   ),
///   index: 0,
/// )
/// ```
///
/// Fields:
/// - [item]: The [GridItem] to display in the tile. (Required)
/// - [theme]: Optional [ThemeData] to override the inherited theme. (Optional)
/// - [index]: The position of the tile in the grid, used for alternating background color. (Required)

class GridItemTile extends StatelessWidget {
  final GridItem item;
  final ThemeData? theme;
  final int index;

  const GridItemTile({
    super.key,
    required this.item,
    this.theme,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData usedTheme = theme ?? Theme.of(context);
    final int maxLabelLines = item.label.contains(' ') ? 2 : 1;

    return Card(
      color:
          index % 2 == 1 ? usedTheme.colorScheme.surfaceContainerHighest : null,
      child: SizedBox.expand(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(item.icon, size: 26, color: usedTheme.colorScheme.secondary),
            const SizedBox(height: 4),
            Text(
              item.label,
              style: usedTheme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
              maxLines: maxLabelLines,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              item.unity != null ? "${item.value} ${item.unity}" : item.value,
              style: usedTheme.textTheme.labelSmall,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
