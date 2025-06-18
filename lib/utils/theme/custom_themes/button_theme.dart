import 'package:flutter/material.dart';
import 'color_scheme.dart';

final ButtonStyle elevatedButtonStyleLight = ElevatedButton.styleFrom(
  backgroundColor: AppColors.light.secondary,
  foregroundColor: AppColors.light.onSecondary,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
);

final ButtonStyle elevatedButtonStyleDark = ElevatedButton.styleFrom(
  backgroundColor: AppColors.dark.secondary,
  foregroundColor: AppColors.dark.onSecondary,
  minimumSize: const Size(64, 56),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
);
