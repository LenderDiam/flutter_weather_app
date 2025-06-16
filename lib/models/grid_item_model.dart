import 'package:flutter/cupertino.dart';

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