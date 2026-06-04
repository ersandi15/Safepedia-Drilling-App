import 'package:get/get.dart';
import '../../../config/app_routes.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    // Simulasi loading 2 detik lalu pindah ke Home
    Future.delayed(const Duration(seconds: 2), () {
      Get.offNamed(AppRoutes.home);
    });
  }
}
