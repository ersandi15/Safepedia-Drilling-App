import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:safepedia_drilling_app/services/image_service.dart';
import 'package:safepedia_drilling_app/services/sensor_service.dart';

class DrillingFormController extends GetxController {
  // Controller untuk teks input
  final holeIdController = TextEditingController();

  // Variabel reaktif (Obx) untuk merender UI secara otomatis saat nilai berubah
  final selectedDate = ''.obs;
  final accelValues = <double>[0.0, 0.0, 0.0].obs; // [x, y, z]
  final gyroValues = <double>[0.0, 0.0, 0.0].obs; // [x, y, z]
  final imagePath = ''.obs;
  final selectedStatus = 'Complete'.obs;

  // Inisialisasi Service
  final ImageService imageService = ImageService();
  final SensorService sensorService = SensorService();

  // Variabel untuk menyimpan info ukuran file (opsional, untuk dipamerkan ke UI)
  final fileSizeKb = ''.obs;

  @override
  void onClose() {
    holeIdController.dispose();
    super.onClose();
  }

  void saveAsDraft() {
    Get.snackbar('Info', 'Disimpan sebagai Draft');
  }

  void submitData() {
    Get.snackbar('Info', 'Data disubmit (Online)');
  }

  // Ubah fungsi pickDate menjadi seperti ini:
  Future<void> pickDate(BuildContext context) async {
    // Menampilkan dialog kalender bawaan Material Design
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000), // Batas tahun paling bawah
      lastDate: DateTime(2100), // Batas tahun paling atas
      builder: (context, child) {
        // Sedikit kustomisasi agar warna kalendernya senada dengan tema aplikasi
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF005A9C), // AppColors.primary
              onPrimary: Colors.white,
              onSurface: Color(0xFF2C3E50), // AppColors.textPrimary
            ),
          ),
          child: child!,
        );
      },
    );

    // Jika user memilih tanggal (tidak menekan cancel), format dan simpan nilainya
    if (picked != null) {
      selectedDate.value = DateFormat('dd MMMM yyyy').format(picked);
    }
  }

  Future<void> takePicture() async {
    // Tampilkan dialog pilihan Kamera / Galeri
    await Get.bottomSheet(
      Container(
        color: Colors.white,
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Kamera'),
              onTap: () {
                Get.back();
                _processImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Galeri'),
              onTap: () {
                Get.back();
                _processImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _processImage(ImageSource source) async {
    try {
      final File? result = await imageService.pickAndCompressImage(source);

      if (result != null) {
        imagePath.value = result.path;

        // Hitung ukuran file akhirnya untuk memastikan masuk kriteria bonus
        int bytes = await result.length();
        double kb = bytes / 1024;
        fileSizeKb.value = '${kb.toStringAsFixed(2)} KB';

        Get.snackbar(
          'Sukses',
          'Gambar berhasil diambil. Ukuran: ${fileSizeKb.value}',
          backgroundColor: Colors.green.shade100,
        );
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal memproses gambar: $e');
    }
  }

  Future<void> readAccelerometer() async {
    try {
      // Mengambil nilai asli dari hardware
      final event = await sensorService.getAccelerometerData();

      // Update UI melalui variabel reaktif (Obx)
      accelValues.value = [event.x, event.y, event.z];
    } catch (e) {
      Get.snackbar(
        'Error',
        'Sensor Accelerometer tidak tersedia/tidak terbaca: $e',
      );
    }
  }

  Future<void> readGyroscope() async {
    try {
      // Mengambil nilai asli dari hardware
      final event = await sensorService.getGyroscopeData();

      // Update UI melalui variabel reaktif (Obx)
      gyroValues.value = [event.x, event.y, event.z];
    } catch (e) {
      Get.snackbar(
        'Error',
        'Sensor Gyroscope tidak tersedia/tidak terbaca: $e',
      );
    }
  }
}
