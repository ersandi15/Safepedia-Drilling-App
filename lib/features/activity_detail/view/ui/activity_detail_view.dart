import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safepedia_drilling_app/config/app_colors.dart';
import 'package:safepedia_drilling_app/config/app_fonts.dart';
import '../../controller/activity_detail_controller.dart';

class ActivityDetailView extends GetView<ActivityDetailController> {
  const ActivityDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isComplete = controller.activity.status == 'Complete';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'Detail Aktivitas',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Hero Image ──────────────────────────────────────────────────
            _buildHeroImage(controller.activity.imagePath),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Header: Hole ID + Badge ──────────────────────────────
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          controller.activity.holeId,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.statusSubmitted.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'SUBMITTED',
                          style: AppFonts.badge.copyWith(
                            color: AppColors.statusSubmitted,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Status pengerjaan
                  Row(
                    children: [
                      Icon(
                        isComplete
                            ? Icons.check_circle_rounded
                            : Icons.pending_actions_rounded,
                        size: 16,
                        color: isComplete
                            ? AppColors.statusSubmitted
                            : AppColors.statusDraft,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        controller.activity.status,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isComplete
                              ? AppColors.statusSubmitted
                              : AppColors.statusDraft,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // ── Info Cards ───────────────────────────────────────────
                  _buildSectionTitle('Informasi Umum'),
                  const SizedBox(height: 12),
                  _buildInfoCard([
                    _buildInfoRow(
                      icon: Icons.calendar_month_rounded,
                      label: 'Tanggal Aktivitas',
                      value: controller.activity.date,
                    ),
                    const Divider(height: 1),
                    _buildInfoRow(
                      icon: Icons.tag_rounded,
                      label: 'Hole ID',
                      value: controller.activity.holeId,
                    ),
                  ]),
                  const SizedBox(height: 20),

                  // ── Sensor Data ──────────────────────────────────────────
                  _buildSectionTitle('Data Sensor'),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildSensorBox(
                          title: 'Accelerometer',
                          icon: Icons.vibration_rounded,
                          color: const Color(0xFF005A9C),
                          x: controller.activity.accelX,
                          y: controller.activity.accelY,
                          z: controller.activity.accelZ,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildSensorBox(
                          title: 'Gyroscope',
                          icon: Icons.rotate_90_degrees_ccw_rounded,
                          color: const Color(0xFF2E7D32),
                          x: controller.activity.gyroX,
                          y: controller.activity.gyroY,
                          z: controller.activity.gyroZ,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroImage(String imagePath) {
    return SizedBox(
      width: double.infinity,
      height: 240,
      child: File(imagePath).existsSync()
          ? Image.file(
              File(imagePath),
              width: double.infinity,
              height: 240,
              fit: BoxFit.cover,
            )
          : Container(
              color: AppColors.background,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.image_not_supported_rounded,
                    size: 48,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Foto tidak tersedia',
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: AppColors.textSecondary,
        letterSpacing: 0.8,
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primary.withValues(alpha: 0.7)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSensorBox({
    required String title,
    required IconData icon,
    required Color color,
    required double x,
    required double y,
    required double z,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 14, color: color),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildAxisRow('X', x, color),
          const SizedBox(height: 6),
          _buildAxisRow('Y', y, color),
          const SizedBox(height: 6),
          _buildAxisRow('Z', z, color),
        ],
      ),
    );
  }

  Widget _buildAxisRow(String axis, double value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          axis,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: color.withValues(alpha: 0.7),
          ),
        ),
        Text(
          value.toStringAsFixed(4),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
            fontFamily: 'monospace',
          ),
        ),
      ],
    );
  }
}
