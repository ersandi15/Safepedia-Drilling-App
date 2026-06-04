import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/app_colors.dart';

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
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          const SizedBox(height: 8),
          Obx(
            () => Column(
              children: [
                Text('X: ${values[0].toStringAsFixed(2)}'),
                Text('Y: ${values[1].toStringAsFixed(2)}'),
                Text('Z: ${values[2].toStringAsFixed(2)}'),
              ],
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: onRead,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryLight,
              foregroundColor: AppColors.white,
              padding: const EdgeInsets.symmetric(horizontal: 8),
            ),
            child: const Text('Read', style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }
}
