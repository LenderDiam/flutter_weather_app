import 'package:flutter/material.dart';
import 'color_scheme.dart';

final ButtonStyle elevatedButtonStyleLight = ElevatedButton.styleFrom(
  backgroundColor: AppColors.light.surface,
  foregroundColor: AppColors.light.primary,
  minimumSize: const Size(64, 56),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
);

final ButtonStyle elevatedButtonStyleDark = ElevatedButton.styleFrom(
  backgroundColor: AppColors.dark.surface,
  foregroundColor: AppColors.dark.primary,
  minimumSize: const Size(64, 56),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
);
