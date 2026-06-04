import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/app_colors.dart';
import '../../../../../config/app_fonts.dart';

class SensorCard extends StatelessWidget {
  final String title;
  final RxList<double> values;
  final VoidCallback onRead;

  const SensorCard({
    super.key,
    required this.title,
    required this.values,
    required this.onRead,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16), // Sudut lebih melengkung
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03), // Shadow sangat lembut
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100), // Border sangat tipis
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                // Jika judulnya Accel, pakai icon speed. Jika Gyro, pakai screen_rotation
                title.contains('Accel')
                    ? Icons.speed_rounded
                    : Icons.screen_rotation_rounded,
                size: 16,
                color: AppColors.primary,
              ),
              const SizedBox(width: 6),
              Text(
                title,
                style: AppFonts.bodyMedium.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Container khusus untuk nilai X, Y, Z agar terlihat seperti layar digital kecil
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'X: ${values[0].toStringAsFixed(3)}',
                    style: AppFonts.caption.copyWith(fontFamily: 'monospace'),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Y: ${values[1].toStringAsFixed(3)}',
                    style: AppFonts.caption.copyWith(fontFamily: 'monospace'),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Z: ${values[2].toStringAsFixed(3)}',
                    style: AppFonts.caption.copyWith(fontFamily: 'monospace'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Tombol Read yang dilebarkan (full width) dengan gaya soft
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onRead,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                foregroundColor: AppColors.primary,
                elevation: 0, // Hilangkan shadow bawaan tombol
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 10),
              ),
              child: const Text(
                'Read',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
