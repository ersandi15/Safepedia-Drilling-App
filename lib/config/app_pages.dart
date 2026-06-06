import 'package:get/get.dart';
import 'package:safepedia_drilling_app/config/app_routes.dart';
import 'package:safepedia_drilling_app/features/drilling_form/controller/drilling_form_controller.dart';
import 'package:safepedia_drilling_app/features/drilling_form/view/ui/drilling_form_view.dart';
import 'package:safepedia_drilling_app/features/home/controller/home_controller.dart';
import 'package:safepedia_drilling_app/features/home/models/drilling_activity_model.dart';
import 'package:safepedia_drilling_app/features/home/view/ui/home_view.dart';
import 'package:safepedia_drilling_app/features/activity_detail/controller/activity_detail_controller.dart';
import 'package:safepedia_drilling_app/features/activity_detail/view/ui/activity_detail_view.dart';
import 'package:safepedia_drilling_app/features/splash/controller/splash_controller.dart';
import 'package:safepedia_drilling_app/features/splash/view/ui/splash_view.dart';

class AppPages {
  AppPages._();

  static List<GetPage> getPages() {
    return [
      // Rute Splash Screen
      GetPage(
        name: AppRoutes.splash,
        page: () => const SplashView(),
        binding: BindingsBuilder(() {
          Get.put(SplashController());
        }),
      ),

      // Rute Home (Beranda dengan Tab Offline & Online)
      GetPage(
        name: AppRoutes.home,
        page: () => const HomeView(),
        binding: BindingsBuilder(() {
          Get.lazyPut(() => HomeController());
        }),
      ),

      // Rute Form Drilling
      GetPage(
        name: AppRoutes.drillingForm,
        page: () => const DrillingFormView(),
        binding: BindingsBuilder(() {
          final controller = Get.put(DrillingFormController());
          // Jika ada argument berupa DrillingActivityModel, berarti mode EDIT
          final args = Get.arguments;
          if (args is DrillingActivityModel) {
            controller.loadDraft(args);
          }
        }),
      ),
      // Rute Detail Aktivitas (read-only untuk Submitted)
      GetPage(
        name: AppRoutes.activityDetail,
        page: () => const ActivityDetailView(),
        binding: BindingsBuilder(() {
          Get.put(ActivityDetailController());
        }),
      ),
    ];
  }
}
