import 'package:flutter/material.dart';

/// A generic grid widget for displaying a list of items of any type,
/// using a provided item builder function.
///
/// Typically used for dashboards, galleries, or any grid-based UI where
/// the content and layout are highly customizable.
///
/// Example usage:
/// ```dart
/// GenericGrid<GridItem>(
///   items: items,
///   crossAxisCount: 2,
///   itemBuilder: (context, item, index) => Card(
///     child: Column(
///       mainAxisAlignment: MainAxisAlignment.center,
///       children: [
///         Icon(item.icon),
///         Text(item.label),
///         Text(item.value),
///         if (item.unity != null) Text(item.unity!),
///       ],
///     ),
///   ),
/// )
/// ```
///
/// Fields:
/// - [items]: The list of items to display in the grid. (Required)
/// - [itemBuilder]: A function that builds a widget for each item, given its context, value, and index. (Required)
/// - [crossAxisCount]: The number of columns in the grid. Defaults to 3. (Optional)

class GenericGrid<T> extends StatelessWidget {
  final List<T> items;
  final int crossAxisCount;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;

  const GenericGrid({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.crossAxisCount = 3,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: crossAxisCount,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      childAspectRatio: 0.8,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      children: List.generate(
        items.length,
        (index) => itemBuilder(context, items[index], index),
      ),
    );
  }
}
