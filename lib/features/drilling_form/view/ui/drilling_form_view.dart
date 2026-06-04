import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/app_colors.dart';
import '../../controller/drilling_form_controller.dart';
import '../components/sensor_card.dart';

class DrillingFormView extends GetView<DrillingFormController> {
  const DrillingFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        title: const Text('Form Aktivitas Drilling'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Date Picker
            const Text('Date', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            InkWell(
              onTap: () => controller.pickDate(context),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(8),
                  color: AppColors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(
                      () => Text(
                        controller.selectedDate.value.isEmpty
                            ? 'Pilih Tanggal'
                            : controller.selectedDate.value,
                        style: TextStyle(
                          color: controller.selectedDate.value.isEmpty
                              ? Colors.grey
                              : AppColors.textPrimary,
                        ),
                      ),
                    ),
                    const Icon(Icons.calendar_today, color: AppColors.primary),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 2. Hole ID Input
            const Text(
              'Hole ID',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: controller.holeIdController,
              decoration: InputDecoration(
                hintText: 'Masukkan huruf dan angka',
                filled: true,
                fillColor: AppColors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 3. Accelerometer & Gyroscope Cards
            Row(
              children: [
                Expanded(
                  child: SensorCard(
                    title: 'Accelerometer',
                    values: controller.accelValues,
                    onRead: controller.readAccelerometer,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SensorCard(
                    title: 'Gyroscope',
                    values: controller.gyroValues,
                    onRead: controller.readGyroscope,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 4. Take a Picture
            const Text(
              'Foto Lokasi (< 250 KB)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Obx(
                    () => controller.imagePath.value.isEmpty
                        ? const Icon(
                            Icons.image_outlined,
                            size: 48,
                            color: Colors.grey,
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              File(controller.imagePath.value),
                              height: 150,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                  Obx(
                    () => controller.fileSizeKb.value.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Text(
                              controller.fileSizeKb.value,
                              style: TextStyle(
                                color: AppColors.statusSubmitted,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),

                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: () => controller.takePicture(),
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Take a Picture'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryLight,
                      foregroundColor: AppColors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 5. Status Dropdown
            const Text('Status', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Obx(
              () => DropdownButtonFormField<String>(
                initialValue: controller.selectedStatus.value,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                items: ['Complete', 'Not Complete'].map((String status) {
                  return DropdownMenuItem(value: status, child: Text(status));
                }).toList(),
                onChanged: (newValue) {
                  if (newValue != null) {
                    controller.selectedStatus.value = newValue;
                  }
                },
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),

      // 6. Action Buttons di bagian bawah
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => controller.saveAsDraft(),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: const BorderSide(color: AppColors.statusDraft),
                  foregroundColor: AppColors.statusDraft,
                ),
                child: const Text(
                  'Save as Draft',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () => controller.submitData(),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
