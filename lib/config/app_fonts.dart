import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppFonts {
  // Heading / Judul Utama (Lebih tebal dan menonjol)
  static const TextStyle heading3 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w800, // Extra Bold
    color: AppColors.textPrimary,
    letterSpacing: -0.3, // Rapat sedikit agar terlihat modern
  );

  // Body / Teks Standar
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500, // Medium
    color: AppColors.textPrimary,
  );

  // Caption / Detail (Lebih kecil dan redup)
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400, // Regular
    color: AppColors.textSecondary,
  );

  // Badge Text (Kecil, tebal, dan berjarak)
  static const TextStyle badge = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w800, // Extra Bold
    letterSpacing: 0.5,
  );
}
