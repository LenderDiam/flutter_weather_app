import 'package:flutter/material.dart';

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