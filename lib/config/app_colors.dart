import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Warna Utama (Brand Safepedia)
  static const Color primary = Color(0xFF005A9C); // Biru laut dalam
  static const Color primaryLight = Color(0xFF4FA4FF);

  // Warna Latar & Teks
  static const Color background = Color(
    0xFFF5F7FA,
  ); // Abu-abu terang untuk background
  static const Color white = Colors.white;
  static const Color textPrimary = Color(0xFF2C3E50); // Navy gelap untuk judul
  static const Color textSecondary = Color(
    0xFF7F8C8D,
  ); // Abu-abu untuk teks detail

  // Warna Status (Sangat penting untuk membedakan Draft & Submitted)
  static const Color statusDraft = Color(0xFFF39C12); // Oranye
  static const Color statusSubmitted = Color(0xFF27AE60); // Hijau
}
