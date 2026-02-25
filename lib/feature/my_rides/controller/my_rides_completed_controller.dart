import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../../../core/network_caller/endpoints.dart';
import '../../../core/network_caller/network_config.dart';
import '../../../core/shared_preference/shared_preferences_helper.dart';
import '../model/my_rides_completed_model.dart';

class MyRidesCompletedController extends GetxController {
  var isLoading = false.obs;
  var errorMessage = "".obs;
  var myRides = <MyRideModel>[].obs;
  var currentTabIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();

    // Tab listener
    ever(currentTabIndex, (index) {
      Logger().e("===----> $index=====Current Tab $currentTabIndex");
    });

    // Fetch rides initially
    fetchMyCompletedRides();
  }

  void fetchMyCompletedRidesData() {
    Logger().e("fetchMyCompletedRides called");
    fetchMyCompletedRides();
  }

  /// Fetch My Rides
  Future<void> fetchMyCompletedRides() async {
    Logger().e("===> ==Current Tab ");
    isLoading.value = true;
    errorMessage.value = "";
    EasyLoading.show(status: "Fetching rides...");

    try {
      final token = await SharedPreferencesHelper.getAccessToken();
      if (token == null || token.isEmpty) {
        errorMessage.value = "Access token not found. Please login.";
        EasyLoading.showError(errorMessage.value);
        return;
      }

      final response = await NetworkCall.getRequest(url: NetworkPath.myRides);

      if (response.isSuccess) {
        final data = response.responseData?["data"];
        if (data != null && data is List) {
          myRides.value = data
              .map((e) => MyRideModel.fromJson(Map<String, dynamic>.from(e)))
              .toList();
        } else {
          myRides.clear();
        }
      } else {
        errorMessage.value = response.errorMessage ?? "Failed to load rides";
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
