import 'package:get/get.dart';

class RiderSearchingController extends GetxController {
  var isOnline = true.obs;

  void toggleStatus(bool status) {
    isOnline.value = status;

    if (status) {
      Get.toNamed("/rider-searching");
    }
  }
}
