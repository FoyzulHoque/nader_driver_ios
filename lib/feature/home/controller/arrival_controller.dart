import 'package:get/get.dart';

class ArrivalController extends GetxController {
  var isConfirmed = false.obs;

  void confirmArrival() {
    isConfirmed.value = true;
  }

  void refuseArrival() {
    isConfirmed.value = false;
  }
}
