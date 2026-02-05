import 'package:get/get.dart';

class RideRequestController extends GetxController {
  var isLoading = false.obs;
  var isAccepted = false.obs;

  void acceptRequest() {
    isAccepted.value = true;
  }

  void declineRequest() {
    isAccepted.value = false;
  }
}
