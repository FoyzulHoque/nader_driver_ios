import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../../../core/network_caller/endpoints.dart';
import '../../../core/network_caller/network_config.dart';
import '../../../core/shared_preference/shared_preferences_helper.dart';
import '../model/review_model.dart';

class ReviewController extends GetxController {
  var isLoading = false.obs;
  var errorMessage = "".obs;
  var myReviews = <ReviewModel>[].obs;
  var avgRating = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMyReviews();
  }

  Future<void> fetchMyReviews() async {
    isLoading.value = true;
    errorMessage.value = "";

    try {
      final response = await NetworkCall.getRequest(url: NetworkPath.myReviews);

      if (response.isSuccess) {
        final dataWrapper = response.responseData?["data"];
        if (dataWrapper != null) {
          // Store the Average Rating
          avgRating.value = (dataWrapper["avgRating"] ?? 0).toDouble();

          // Access the nested "data" list
          final List? reviewList = dataWrapper["data"];
          if (reviewList != null) {
            myReviews.value = reviewList
                .map((e) => ReviewModel.fromJson(Map<String, dynamic>.from(e)))
                .toList();
          }
        }
        EasyLoading.dismiss();
      } else {
        errorMessage.value = response.errorMessage ?? "Failed to load reviews";
      }
    } catch (e) {
      errorMessage.value = "Error: $e";
    } finally {
      isLoading.value = false;
    }
  }
}
