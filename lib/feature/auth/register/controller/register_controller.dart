/*
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:nader_driver/core/network_caller/endpoints.dart';
import 'package:nader_driver/core/network_caller/network_config.dart';
import 'package:nader_driver/core/shared_preference/shared_preferences_helper.dart';
import 'package:nader_driver/feature/auth/register/model/register_model.dart';
import 'package:nader_driver/feature/auth/register/screen/register_otp_verify.dart';

class RegisterController extends GetxController {
  var countryCode = '+44'.obs;
  var phoneNumber = ''.obs;

  void setPhoneNumber(String number) {
    phoneNumber.value = number;
  }

  void setCountryCode(String code) {
    countryCode.value = code;
  }



  Future<void> registerUser({
    required String phoneNumber,
    required String role,
  }) async {
    EasyLoading.show(status: "Registering...");

    try {
      Map<String, dynamic> mapBody = {
        "phoneNumber": phoneNumber,
        "role": role,
      };

      NetworkResponse response = await NetworkCall.postRequest(
        url: NetworkPath.registration,
        body: mapBody,
      );
      if (response.isSuccess) {
        var registerResponse = RegisterModel.fromJson(response.responseData!["data"]);

        // Save isExist flag
        await SharedPreferencesHelper.saveIsExist(registerResponse.isExist ?? false);

        Get.to(() => RegisterOtpVerify(driverPhoneNo: phoneNumber));

        EasyLoading.showSuccess(
          "Registration successful, OTP: ${registerResponse.otp}",
        );
      }
      else{
        EasyLoading.showError(
          response.errorMessage?? "Registration failed.",
        );
      }

    } catch (e) {
      EasyLoading.showError("Error: $e");
    } finally {
      EasyLoading.dismiss();
    }
  }
}
*/
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../../../core/network_caller/endpoints.dart';
import '../../../../core/network_caller/network_config.dart';
import '../../../../core/shared_preference/shared_preferences_helper.dart';
import '../model/register_model.dart';

class RegisterController extends GetxController {
  var countryCode = '+961'.obs;
  var phoneNumber = ''.obs;

  void setPhoneNumber(String number) {
    phoneNumber.value = number;
  }

  void setCountryCode(String code) {
    countryCode.value = code;
  }

  Future<bool> registerUser({
    required String phoneNumber, // Or use this.phoneNumber.value if preferred
    required String role,
  }) async {
    EasyLoading.show(status: "Registering...");

    try {
      // Get FCM token
      String? fcmToken = await FirebaseMessaging.instance.getToken();
      String? apnsToken = await FirebaseMessaging.instance.getAPNSToken();
      String? fToken = fcmToken ?? apnsToken;
      if (fToken != null) {
        debugPrint("✅ FCM/APNS Token: $fToken");
      } else {
        debugPrint("⚠️ Token is null");
      }
      Map<String, dynamic> mapBody = {
        "phoneNumber": phoneNumber,
        "role": role,
        "fcmToken": fToken ?? "",
      };

      NetworkResponse response = await NetworkCall.postRequest(
        url: NetworkPath.registration,
        body: mapBody,
      );

      if (response.isSuccess) {
        var registerResponse = RegisterModel.fromJson(
          response.responseData!["data"],
        );

        // Save isExist flag
        await SharedPreferencesHelper.saveIsExist(
          registerResponse.isExist ?? false,
        );

        // Navigate to OTP screen
        //Get.to(() => RegisterOtpVerify(driverPhoneNo: phoneNumber));

        // Success message WITHOUT exposing OTP
        EasyLoading.showSuccess(
          "Registration successful. Please check your phone for OTP.",
        );

        return true; // Success!
      } else {
        EasyLoading.showError(response.errorMessage ?? "Registration failed.");
        return false;
      }
    } catch (e) {
      EasyLoading.showError("Error: $e");
      return false;
    } finally {
      EasyLoading.dismiss();
    }
  }
}
