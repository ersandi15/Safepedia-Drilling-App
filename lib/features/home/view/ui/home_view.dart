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
          centerTitle: false,
          title: const Text(
            'Aktivitas Drilling',
            style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5),
          ),
          bottom: TabBar(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.white,
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: AppColors.white, // Pill shape indicator
            ),
            dividerColor: Colors.transparent, // Hilangkan garis bawah default
            tabs: const [
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.edit_document, size: 18),
                    SizedBox(width: 8),
                    Text(
                      'Draft',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.cloud_done, size: 18),
                    SizedBox(width: 8),
                    Text(
                      'Submitted',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          return TabBarView(
            children: [
              ActivityListComponent(
                list: controller.offlineList,
                isDraft: true,
              ),
              ActivityListComponent(
                list: controller.onlineList,
                isDraft: false,
              ),
            ],
          );
        }),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => Get.toNamed(AppRoutes.drillingForm)?.then((_) {
            controller.fetchActivities();
          }),
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          elevation: 4,
          icon: const Icon(Icons.add_rounded),
          label: const Text(
            'Aktivitas Baru',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
