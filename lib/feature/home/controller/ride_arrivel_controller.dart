import 'package:get/get.dart';

class RideController extends GetxController {
  var isArrived = false.obs;

  void confirmArrival() {
    isArrived.value = true;
  }

  void callRider() {
    // Logic to call rider (dummy for now)
    print("Calling rider...");
  }

  void chatWithRider() {
    // Logic to open chat (dummy for now)
    print("Opening chat with rider...");
  }
}
