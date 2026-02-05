
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../../../core/network_caller/network_config.dart';
import '../../../core/network_caller/endpoints.dart';
import '../../../core/shared_preference/shared_preferences_helper.dart';
import '../model/online_ride_model.dart';
import '../view/driver_confirmation_screen.dart';

class OnlineRideController extends GetxController {
  var isLoading = false.obs;
  var errorMessage = "".obs;
  var pendingRides = <OnlineRideModel>[].obs;
  var selectedRide = Rxn<OnlineRideModel>();

  // Total amount calculation - সব ride-এর totalAmount যোগ করবে
  double get totalValue {
    if (pendingRides.isEmpty) return 0.0;

    double total = 0.0;
    for (var ride in pendingRides) {
      total += ride.totalAmount ?? 0.0;
    }
    return total;
  }

  @override
  void onInit() {
    super.onInit();
    fetchPendingRides();
  }

  Future<void> fetchPendingRides() async {
    isLoading.value = true;
    errorMessage.value = "";
    EasyLoading.show(status: "Fetching pending rides...");

    print("🔹 fetchPendingRides started");

    try {
      final token = await SharedPreferencesHelper.getAccessToken();
      print("🔹 Access token: $token");

      if (token == null || token.isEmpty) {
        errorMessage.value = "Access token not found. Please login.";
        print("❌ Error: ${errorMessage.value}");
        EasyLoading.showError(errorMessage.value);
        return;
      }

      print("🔹 Sending GET request to: ${NetworkPath.onlineRidersList}");
      final response = await NetworkCall.getRequest(
        url: NetworkPath.onlineRidersList,
      );

      print("🔹 Response status: ${response.statusCode}");
      print("🔹 Response success: ${response.isSuccess}");
      print("🔹 Response body: ${response.responseData}");

      if (response.isSuccess) {
        final data = response.responseData?["data"];
        print("🔹 Data received: $data");

        if (data != null && data is List) {
          pendingRides.value = data
              .map((e) => OnlineRideModel.fromJson(Map<String, dynamic>.from(e)))
              .toList();

          print("✅ Pending Rides Loaded: ${pendingRides.length}");
          print("💰 Total Value: \$${totalValue.toStringAsFixed(2)}");
          Logger().i("✅ Pending Rides Loaded: ${pendingRides.length}");
        } else {
          print("⚠️ Data is null or not a List");
          pendingRides.clear();
        }
      } else {
        errorMessage.value = response.errorMessage ?? "Failed to load rides";
        print("❌ Error: ${errorMessage.value}");
        EasyLoading.showError(errorMessage.value);
      }
    } catch (e) {
      errorMessage.value = "Error: $e";
      print("❌ Exception: $e");
      EasyLoading.showError(errorMessage.value);
    } finally {
      isLoading.value = false;
      if (EasyLoading.isShow) EasyLoading.dismiss();
      print("🔹 fetchPendingRides finished");
    }
  }

  // Method to select a ride and open the confirmation screen
  void selectAndOpenRide(OnlineRideModel ride) {
    selectedRide.value = ride;
    Get.to(() => const DriverConfirmationScreen());
  }
}