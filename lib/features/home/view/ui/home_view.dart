import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/app_routes.dart';
import '../../../../config/app_colors.dart';
import '../../controller/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    // Membungkus Scaffold dengan DefaultTabController untuk fitur Tab
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white, // Warna teks & icon menjadi putih
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
        body: const TabBarView(
          children: [
            // Konten Tab 1: Offline (Draft)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox, size: 64, color: AppColors.textSecondary),
                  SizedBox(height: 16),
                  Text(
                    'Belum ada data Draft',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),

            // Konten Tab 2: Online (Submitted)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cloud_done_outlined,
                    size: 64,
                    color: AppColors.textSecondary,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Belum ada data API/Submitted',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => Get.toNamed(AppRoutes.drillingForm),
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          icon: const Icon(Icons.add),
          label: const Text('Aktivitas Baru'),
        ),
      ),
    );
  }
}
