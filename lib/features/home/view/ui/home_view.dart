import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/app_routes.dart';
import '../../../../config/app_colors.dart';
import '../../controller/home_controller.dart';
import '../components/activity_list_component.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          elevation: 0,
          title: const Text(
            'Aktivitas Drilling',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          bottom: const TabBar(
            labelColor: AppColors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: AppColors.white,
            indicatorWeight: 3.0,
            tabs: [
              Tab(icon: Icon(Icons.edit_document), text: 'Offline (Draft)'),
              Tab(icon: Icon(Icons.cloud_done), text: 'Online (Submitted)'),
            ],
          ),
        ),
        body: Obx(() {
          // Jika sedang loading, tampilkan indikator putar
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return TabBarView(
            children: [
              // Tab 1: Menampilkan list Offline (Draft)
              ActivityListComponent(
                list: controller.offlineList,
                isDraft: true,
              ),

              // Tab 2: Menampilkan list Online (Submitted)
              ActivityListComponent(
                list: controller.onlineList,
                isDraft: false,
              ),
            ],
          );
        }),
        floatingActionButton: FloatingActionButton.extended(
          // PENTING: Gunakan .then() untuk merefresh data setelah form ditutup
          onPressed: () => Get.toNamed(AppRoutes.drillingForm)?.then((_) {
            controller.fetchActivities();
          }),
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          icon: const Icon(Icons.add),
          label: const Text('Aktivitas Baru'),
        ),
      ),
    );
  }
}
