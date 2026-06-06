import 'package:get/get.dart';
import 'package:safepedia_drilling_app/features/home/models/drilling_activity_model.dart';

class ActivityDetailController extends GetxController {
  late final DrillingActivityModel activity;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is DrillingActivityModel) {
      activity = Get.arguments as DrillingActivityModel;
    }
  }
}
