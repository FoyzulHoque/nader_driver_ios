// rider_info_api_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/network_caller/endpoints.dart';
import '../../../../core/network_caller/network_config.dart';
import '../model/online_ride_model.dart';

class RiderInfoApiController extends GetxController {
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var rideData = Rx<OnlineRideModel?>(null);

  // Add these missing properties
  var selectedRide = Rx<OnlineRideModel?>(null);
  var pendingRides = <OnlineRideModel>[].obs;

  Future<OnlineRideModel?> riderInfoApiMethod(String id) async {
    print("🚀 [RiderInfoApiController] Starting riderInfoApiMethod with ID: $id");

    if (id.isEmpty) {
      errorMessage.value = 'Transport ID is empty. Please provide a valid ID.';
      print("⚠️ [Error] Transport ID is empty");
      Get.snackbar('Error', errorMessage.value, backgroundColor: Colors.red, colorText: Colors.white);
      return null;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final url = NetworkPath.carTransportsSingle(id);
      print("🌍 [Request] GET => $url");

      NetworkResponse response = await NetworkCall.getRequest(url: url);
      print("📥 [Response] Status: ${response.statusCode}, Success: ${response.isSuccess}");

      if (!response.isSuccess || response.statusCode != 200) {
        errorMessage.value = response.errorMessage ??
            'Request failed with status code: ${response.statusCode}';
        rideData.value = null;
        print("❌ [Error] ${errorMessage.value}");
        Get.snackbar('Error', errorMessage.value, backgroundColor: Colors.red, colorText: Colors.white);
        return null;
      }

      final responseData = response.responseData;
      if (responseData == null || responseData['data'] == null) {
        errorMessage.value = 'No data field found in API response.';
        rideData.value = null;
        print("⚠️ [Warning] Missing data in response.");
        Get.snackbar('Error', errorMessage.value, backgroundColor: Colors.red, colorText: Colors.white);
        return null;
      }

      final data = responseData['data'];
      Map<String, dynamic>? rideJson;

      if (data is Map<String, dynamic>) {
        rideJson = data;
      } else if (data is List && data.isNotEmpty && data[0] is Map<String, dynamic>) {
        rideJson = data[0];
      }

      if (rideJson == null) {
        errorMessage.value = 'Invalid ride data format received.';
        rideData.value = null;
        print("⚠️ [Warning] Invalid ride data format.");
        Get.snackbar('Error', errorMessage.value, backgroundColor: Colors.red, colorText: Colors.white);
        return null;
      }

      // Debug API response for driver position
      print("🔍 [Debug] Full API Response: $rideJson");
      print("🔍 [Debug] Driver Lat from API: ${rideJson['driverLat']}");
      print("🔍 [Debug] Driver Lng from API: ${rideJson['driverLng']}");
      print("🔍 [Debug] Vehicle data: ${rideJson['vehicle']}");
      if (rideJson['vehicle'] != null && rideJson['vehicle']['driver'] != null) {
        print("🔍 [Debug] Driver from vehicle: ${rideJson['vehicle']['driver']}");
        print("🔍 [Debug] Driver lat from vehicle: ${rideJson['vehicle']['driver']['lat']}");
        print("🔍 [Debug] Driver lng from vehicle: ${rideJson['vehicle']['driver']['lng']}");
      }

      rideData.value = OnlineRideModel.fromJson(rideJson);
      selectedRide.value = rideData.value; // Also set selectedRide

      final driver = rideData.value?.vehicle?.driver;
      if (driver == null) {
        errorMessage.value = 'Driver information missing from the response.';
        print("⚠️ [Warning] Driver info missing.");
        Get.snackbar('Error', errorMessage.value, backgroundColor: Colors.red, colorText: Colors.white);
      } else {
        print("✅ [Success] Ride Loaded: ID=${rideData.value?.id}, Driver=${driver.fullName}");
      }

      return rideData.value;
    } catch (e, stack) {
      errorMessage.value = 'Unexpected error: ${e.toString()}. Please try again.';
      rideData.value = null;
      print("💥 [Exception] $e");
      print("📜 [StackTrace] $stack");
      Get.snackbar('Error', errorMessage.value, backgroundColor: Colors.red, colorText: Colors.white);
      return null;
    } finally {
      isLoading.value = false;
      print("🏁 [RiderInfoApiController] API call completed. Loading: ${isLoading.value}");
    }
  }
}