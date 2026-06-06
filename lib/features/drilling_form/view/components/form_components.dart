import 'package:flutter/material.dart';
import '../../../../../config/app_colors.dart';
import '../../../../../config/app_fonts.dart';

/// Kumpulan komponen/helper statis untuk DrillingFormView.
/// Dipisahkan agar view tetap bersih dan helper mudah di-reuse.
class FormComponents {
  FormComponents._(); // Prevent instantiation

  /// Widget label untuk setiap field input.
  /// [isRequired] menambahkan tanda '*' merah jika true.
  static Widget buildLabel(String text, {bool isRequired = true}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Row(
        children: [
          Text(
            text,
            style: AppFonts.bodyMedium.copyWith(fontWeight: FontWeight.w700),
          ),
          if (isRequired)
            Text(
              ' *',
              style: AppFonts.bodyMedium.copyWith(color: Colors.red.shade400),
            ),
        ],
      ),
    );
  }

  /// Dekorasi input yang seragam untuk semua TextField / Dropdown.
  static InputDecoration inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      hintStyle: AppFonts.caption.copyWith(
        color: Colors.grey.shade400,
        fontSize: 14,
      ),
      prefixIcon: Icon(icon, color: AppColors.textSecondary, size: 20),
      filled: true,
      fillColor: AppColors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
    );
  }
}
