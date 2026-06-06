import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:safepedia_drilling_app/features/home/models/drilling_activity_model.dart';
import 'package:safepedia_drilling_app/services/database_service.dart';
import 'package:safepedia_drilling_app/services/image_service.dart';
import 'package:safepedia_drilling_app/services/sensor_service.dart';
import 'package:safepedia_drilling_app/config/app_routes.dart';

class DrillingFormController extends GetxController {
  // Controller untuk teks input
  final holeIdController = TextEditingController();

  // Variabel reaktif (Obx) untuk merender UI secara otomatis saat nilai berubah
  final selectedDate = ''.obs;
  final accelValues = <double>[0.0, 0.0, 0.0].obs; // [x, y, z]
  final gyroValues = <double>[0.0, 0.0, 0.0].obs; // [x, y, z]
  final imagePath = ''.obs;
  final selectedStatus = 'Complete'.obs;

  // Mode edit: menyimpan id draft yang sedang diedit (null = mode create baru)
  final Rxn<int> editingId = Rxn<int>();

  // Inisialisasi Service
  final ImageService imageService = ImageService();
  final SensorService sensorService = SensorService();
  final DatabaseService databaseService = DatabaseService();

  // Variabel untuk menyimpan info ukuran file (opsional, untuk dipamerkan ke UI)
  final fileSizeKb = ''.obs;

  // Indikator loading saat memproses/kompres gambar
  final isImageLoading = false.obs;

  @override
  void onClose() {
    holeIdController.dispose();
    super.onClose();
  }

  /// Pre-fill semua field form dari data draft yang ada
  void loadDraft(DrillingActivityModel draft) {
    editingId.value = draft.id;
    holeIdController.text = draft.holeId;
    selectedDate.value = draft.date == 'Belum diatur' ? '' : draft.date;
    accelValues.value = [draft.accelX, draft.accelY, draft.accelZ];
    gyroValues.value = [draft.gyroX, draft.gyroY, draft.gyroZ];
    imagePath.value = draft.imagePath;
    selectedStatus.value = draft.status;
  }

  // Fungsi utama untuk menyimpan data (0 = Draft, 1 = Submitted)
  Future<void> _saveData(int isSubmittedStatus) async {
    // 1. Validasi Berdasarkan Status
    if (isSubmittedStatus == 1) {
      // Validasi KETAT untuk SUBMIT (Semua wajib diisi)
      if (selectedDate.value.isEmpty ||
          holeIdController.text.isEmpty ||
          imagePath.value.isEmpty) {
        Get.snackbar(
          'Peringatan',
          'Tanggal, Hole ID, dan Foto Lokasi wajib diisi untuk Submit!',
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade900,
        );
        return;
      }
    } else {
      // Validasi LONGGAR untuk DRAFT (Minimal isi Hole ID agar bisa dikenali di daftar)
      if (holeIdController.text.isEmpty) {
        Get.snackbar(
          'Peringatan',
          'Minimal isi Hole ID untuk bisa disimpan sebagai Draft',
          backgroundColor: Colors.orange.shade100,
          colorText: Colors.orange.shade900,
        );
        return;
      }
    }

    // 2. Bungkus data ke dalam Model
    final activity = DrillingActivityModel(
      id: editingId.value, // null saat create baru, ada isinya saat edit
      date: selectedDate.value.isEmpty ? 'Belum diatur' : selectedDate.value,
      holeId: holeIdController.text,
      accelX: accelValues[0],
      accelY: accelValues[1],
      accelZ: accelValues[2],
      gyroX: gyroValues[0],
      gyroY: gyroValues[1],
      gyroZ: gyroValues[2],
      imagePath: imagePath.value,
      status: selectedStatus.value,
      isSubmitted: isSubmittedStatus,
    );

    // 3. Simpan / Update ke SQLite
    try {
      if (editingId.value != null) {
        // Mode EDIT: update baris yang sudah ada
        await databaseService.updateActivity(activity);
      } else {
        // Mode CREATE: insert baris baru
        await databaseService.insertActivity(activity);
      }

      Get.snackbar(
        'Sukses',
        isSubmittedStatus == 0
            ? 'Draft berhasil disimpan'
            : 'Data berhasil di-Submit',
        backgroundColor: Colors.green.shade100,
      );

      // 4. Kembali ke halaman Home
      Get.offAllNamed(AppRoutes.home);
    } catch (e) {
      Get.snackbar('Error', 'Gagal menyimpan data: $e');
    }
  }

  void saveAsDraft() {
    _saveData(0); // 0 = Offline/Draft
  }

  void submitData() {
    _saveData(1); // 1 = Online/Submitted
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
      isImageLoading.value = true;
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
    } finally {
      isImageLoading.value = false;
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
