import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:nader_driver/core/network_caller/endpoints.dart';
import 'package:nader_driver/core/network_caller/network_config.dart';
import '../model/onboarding_model.dart';

class OnboardingController extends GetxController {
  var isLoading = false.obs;
  OnboardingModel? onboardingData;

  @override
  void onInit() {
    // Pass empty/default data initially
    fetchOnboardingData(
      profileData: {},
      vehicleData: {},
      profileImage: null,
      licenseFrontSide: null,
      licenseBackSide: null,
      vehicleImage: null,
    );
    super.onInit();
  }

  Future<void> fetchOnboardingData({
    required Map<String, dynamic> profileData,
    required Map<String, dynamic> vehicleData,
    File? profileImage,
    File? licenseFrontSide,
    File? licenseBackSide,
    File? vehicleImage,
  }) async {
    try {
      isLoading.value = true;
      EasyLoading.show(status: "Loading...");

      Map<String, dynamic> formData = {
        "data": jsonEncode({"profile": profileData, "vehicle": vehicleData}),
        if (profileImage != null) "profileImage": profileImage,
        if (licenseFrontSide != null) "licenseFrontSide": licenseFrontSide,
        if (licenseBackSide != null) "licenseBackSide": licenseBackSide,
        if (vehicleImage != null) "vehicleImage": vehicleImage,
      };

      NetworkResponse response = await NetworkCall.multipartRequestForData(
        url: NetworkPath.onboarding,
        formData: formData,
        methodType: "GET", // cURL example uses GET
      );

      if (response.isSuccess) {
        final body = response.responseData is String
            ? jsonDecode(response.responseData as String)
            : response.responseData;

        onboardingData = OnboardingModel.fromJson(body);

        EasyLoading.dismiss();
      } else {
        EasyLoading.showError("Failed: ${response.errorMessage}");
      }
    } catch (e) {
      EasyLoading.showError("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
