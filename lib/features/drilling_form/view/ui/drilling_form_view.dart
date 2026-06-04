import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/app_colors.dart';
import '../../../../config/app_fonts.dart';
import '../../controller/drilling_form_controller.dart';
import '../components/sensor_card.dart';
import '../components/form_components.dart';

class DrillingFormView extends GetView<DrillingFormController> {
  const DrillingFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'Form Aktivitas',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Date Picker
            FormComponents.buildLabel('Tanggal Aktivitas'),
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => controller.pickDate(context),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.calendar_month_rounded,
                      color: AppColors.textSecondary,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Obx(
                        () => Text(
                          controller.selectedDate.value.isEmpty
                              ? 'Pilih Tanggal'
                              : controller.selectedDate.value,
                          style: TextStyle(
                            color: controller.selectedDate.value.isEmpty
                                ? Colors.grey.shade400
                                : AppColors.textPrimary,
                            fontSize: 14,
                            fontWeight: controller.selectedDate.value.isEmpty
                                ? FontWeight.normal
                                : FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const Icon(Icons.chevron_right_rounded, color: Colors.grey),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 2. Hole ID Input
            FormComponents.buildLabel('Hole ID'),
            TextField(
              controller: controller.holeIdController,
              style: AppFonts.bodyMedium.copyWith(fontWeight: FontWeight.w600),
              decoration: FormComponents.inputDecoration(
                'Masukkan huruf dan angka...',
                Icons.tag_rounded,
              ),
            ),
            const SizedBox(height: 24),

            // 3. Accelerometer & Gyroscope Cards
            FormComponents.buildLabel('Data Sensor Hardware', isRequired: false),
            Row(
              children: [
                Expanded(
                  child: SensorCard(
                    title: 'Accelerometer',
                    values: controller.accelValues,
                    onRead: controller.readAccelerometer,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: SensorCard(
                    title: 'Gyroscope',
                    values: controller.gyroValues,
                    onRead: controller.readGyroscope,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 4. Take a Picture
            FormComponents.buildLabel('Foto Lokasi (< 250 KB)'),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                border: Border.all(color: Colors.grey.shade200),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Obx(() {
                    if (controller.isImageLoading.value) {
                      return const Padding(
                        padding: EdgeInsets.all(24.0),
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      );
                    }

                    return controller.imagePath.value.isEmpty
                        ? Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.add_a_photo_rounded,
                              size: 36,
                              color: Colors.grey.shade400,
                            ),
                          )
                        : GestureDetector(
                            onTap: () {
                              Get.dialog(
                                Dialog(
                                  backgroundColor: Colors.transparent,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      InteractiveViewer(
                                        child: Image.file(
                                          File(controller.imagePath.value),
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                      Positioned(
                                        top: 10,
                                        right: 10,
                                        child: IconButton(
                                          icon: const Icon(
                                            Icons.cancel,
                                            color: Colors.white,
                                            size: 36,
                                          ),
                                          onPressed: () => Get.back(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(
                                File(controller.imagePath.value),
                                height: 180,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                  }),

                  const SizedBox(height: 16),

                  Obx(
                    () => controller.fileSizeKb.value.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.check_circle_rounded,
                                  color: AppColors.statusSubmitted,
                                  size: 16,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Ukuran File: ${controller.fileSizeKb.value}',
                                  style: const TextStyle(
                                    color: AppColors.statusSubmitted,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),

                  Obx(
                    () => SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: controller.isImageLoading.value
                            ? null
                            : () => controller.takePicture(),
                        icon: const Icon(Icons.camera_alt_rounded),
                        label: Text(
                          controller.isImageLoading.value
                              ? 'Memproses...'
                              : (controller.imagePath.value.isEmpty
                                    ? 'Ambil Gambar'
                                    : 'Ganti Gambar'),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 5. Status Dropdown
            FormComponents.buildLabel('Status Pengerjaan'),
            Obx(
              () => DropdownButtonFormField<String>(
                initialValue: controller.selectedStatus.value,
                icon: const Icon(
                  Icons.expand_more_rounded,
                  color: AppColors.textSecondary,
                ),
                decoration: FormComponents.inputDecoration(
                  '',
                  Icons.flag_rounded,
                ).copyWith(hintText: null),
                items: ['Complete', 'Not Complete'].map((String status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(
                      status,
                      style: AppFonts.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (newValue) {
                  if (newValue != null) {
                    controller.selectedStatus.value = newValue;
                  }
                },
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),

      // 6. Action Buttons
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => controller.saveAsDraft(),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(
                      color: AppColors.statusDraft.withValues(alpha: 0.5),
                      width: 1.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    foregroundColor: AppColors.statusDraft,
                  ),
                  child: const Text(
                    'Save as Draft',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => controller.submitData(),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    elevation: 4,
                    shadowColor: AppColors.primary.withValues(alpha: 0.4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Submit',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
