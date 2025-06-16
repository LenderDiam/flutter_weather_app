import 'package:flutter/material.dart';
import 'package:flutter_weather_app/models/grid_item_model.dart';

class GridItemTile extends StatelessWidget {
  final GridItem item;
  final ThemeData? theme;

  const GridItemTile({
    super.key,
    required this.item,
    this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData usedTheme = theme ?? Theme.of(context);

    return Card(
      child: SizedBox.expand(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(item.icon, size: 26, color: Theme.of(context).colorScheme.secondary),
            const SizedBox(height: 4),
            Text(
              item.label,
              style: usedTheme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
              maxLines: 2,
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
