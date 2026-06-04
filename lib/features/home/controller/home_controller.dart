import 'package:get/get.dart';
import '../../../services/database_service.dart';
import '../models/drilling_activity_model.dart';

class HomeController extends GetxController {
  final DatabaseService databaseService = DatabaseService();

  // Variabel reaktif penampung data
  final offlineList = <DrillingActivityModel>[].obs;
  final onlineList = <DrillingActivityModel>[].obs;

  // Indikator loading
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    // Ambil data pertama kali saat halaman Home dibuka
    fetchActivities();
  }

  Future<void> fetchActivities() async {
    isLoading.value = true;
    try {
      // Ambil data dari SQLite melalui Service
      final drafts = await databaseService.getOfflineActivities();
      final submitted = await databaseService.getOnlineActivities();

      // Masukkan ke dalam variabel reaktif
      offlineList.assignAll(drafts);
      onlineList.assignAll(submitted);
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat data dari database: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
