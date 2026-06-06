import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/app_routes.dart';
import '../../../../config/app_colors.dart';
import '../../controller/home_controller.dart';
import '../components/activity_list_component.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  // Lebar max untuk konten di tablet agar tidak terlalu melebar
  static const double _maxContentWidth = 900;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 600;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          elevation: 0,
          centerTitle: isTablet,
          title: const Text(
            'Aktivitas Drilling',
            style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(56),
            child: Align(
              alignment: Alignment.center,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: _maxContentWidth),
                child: TabBar(
                  padding: EdgeInsets.symmetric(
                    // Tablet: tab lebih sempit agar tidak terlalu lebar
                    horizontal: isTablet ? screenWidth * 0.15 : 16,
                    vertical: 8,
                  ),
                  labelColor: AppColors.primary,
                  unselectedLabelColor: AppColors.white,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: AppColors.white,
                  ),
                  dividerColor: Colors.transparent,
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
            ),
          ),
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          return Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: _maxContentWidth),
              child: TabBarView(
                children: [
                  ActivityListComponent(
                    list: controller.offlineList,
                    isDraft: true,
                    onEdit: (draft) {
                      Get.toNamed(
                        AppRoutes.drillingForm,
                        arguments: draft,
                      )?.then((_) => controller.fetchActivities());
                    },
                  ),
                  ActivityListComponent(
                    list: controller.onlineList,
                    isDraft: false,
                    onView: (activity) {
                      Get.toNamed(AppRoutes.activityDetail, arguments: activity);
                    },
                  ),
                ],
              ),
            ),
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
