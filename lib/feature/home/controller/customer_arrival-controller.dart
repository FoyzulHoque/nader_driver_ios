import 'package:get/get.dart';

class CustomerArrivalController extends GetxController {
  var isArrived = false.obs;

  void confirmArrival() {
    isArrived.value = true;
    // Place API call or navigation here if needed
    print("Customer arrival confirmed!");
  }
}
