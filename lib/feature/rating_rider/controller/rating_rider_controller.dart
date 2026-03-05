import 'package:get/get.dart';

class RatingController extends GetxController {
  var rating = 0.obs;
  var details = ''.obs;

  void setRating(int value) {
    rating.value = value;
  }

  void setDetails(String value) {
    details.value = value;
  }

  bool isValid() {
    return rating.value > 0 || details.value.trim().isNotEmpty;
  }
}
