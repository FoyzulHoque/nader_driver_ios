
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../../core/network_caller/network_config.dart';
import '../../../core/network_caller/endpoints.dart';
import '../../../core/shared_preference/shared_preferences_helper.dart';
import '../model/my_rides_cancelled_model.dart';


class MyRidesCancelledController extends GetxController {
  var isLoading = false.obs;
  var errorMessage = "".obs;
  var rideHistory = <MyRidesHistoryModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchMyCanceledRides();

  }

  void fetchMyCanceledRidesData() {
    fetchMyCanceledRides();
  }

  Future<void> fetchMyCanceledRides() async {
    isLoading.value = true;
    errorMessage.value = "";
    EasyLoading.show(status: "Fetching ride history...");

    try {
      final token = await SharedPreferencesHelper.getAccessToken();
      if (token == null || token.isEmpty) {
        errorMessage.value = "Access token not found. Please login.";
        EasyLoading.showError(errorMessage.value);
        return;
      }

      final response = await NetworkCall.getRequest(
        url: NetworkPath.myRidesHistory,
      );

      if (response.isSuccess) {
        final data = response.responseData?["data"];
        if (data != null && data is List) {
          rideHistory.value = data
              .map((e) =>
              MyRidesHistoryModel.fromJson(Map<String, dynamic>.from(e)))
              .toList();
        } else {
          rideHistory.clear();
        }
      } else {
        errorMessage.value = response.errorMessage ?? "Failed to load history";
        EasyLoading.showError(errorMessage.value);
      }
    } catch (e) {
      errorMessage.value = "Error: $e";
      EasyLoading.showError(errorMessage.value);
    } finally {
      isLoading.value = false;
      if (EasyLoading.isShow) EasyLoading.dismiss();
    }
  }
}
