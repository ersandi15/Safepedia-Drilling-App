import 'package:get/get.dart';
import 'package:safepedia_drilling_app/config/app_routes.dart';
import 'package:safepedia_drilling_app/features/drilling_form/controller/drilling_form_controller.dart';
import 'package:safepedia_drilling_app/features/drilling_form/view/ui/drilling_form_view.dart';
import 'package:safepedia_drilling_app/features/home/controller/home_controller.dart';
import 'package:safepedia_drilling_app/features/home/view/ui/home_view.dart';
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
          Get.lazyPut(() => DrillingFormController());
        }),
      ),
    ];
  }
}
