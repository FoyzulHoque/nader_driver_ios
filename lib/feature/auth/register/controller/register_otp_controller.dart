import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../../../core/network_caller/endpoints.dart';
import '../../../../core/network_caller/network_config.dart';
import '../../../../core/shared_preference/shared_preferences_helper.dart';
import '../../../location/view/location_screen.dart';

class RegisterOtpControllers extends GetxController {
  final TextEditingController otpController = TextEditingController();
  var otpError = false.obs;
  var otpErrorText = "".obs;

  var isLoading = false.obs;
  var otp = ''.obs;
  var message = ''.obs;

  Future<void> verifyLogin({
    required String phoneNumber,
    required int otp,
  }) async {
    EasyLoading.show(status: "Login verifying...");

    try {
      Map<String, dynamic> mapBody = {"phoneNumber": phoneNumber, "otp": otp};

      NetworkResponse response = await NetworkCall.postRequest(
        url: NetworkPath.verifyLogin,
        body: mapBody,
      );
      if (response.isSuccess) {
        var data = response.responseData!["data"];
        final token = data["token"];
        final id = data["id"];

        if (token != null) {
          await SharedPreferencesHelper.saveToken(token);
          await SharedPreferencesHelper.savePhoneNo(phoneNumber);
        }
        if (id != null) {
          await SharedPreferencesHelper.saveUserId(id);
        }

        final userId = await SharedPreferencesHelper.getUserId();
        print("================================ $userId");

        EasyLoading.showSuccess("Login verified successfully");

        Get.offAll(() => LocationScreen());
      } else {
        EasyLoading.showError(response.errorMessage ?? "Failed to resend OTP");
      }
    } catch (e) {
      EasyLoading.showError("Error: $e");
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<bool> resendOtp(String phoneNumber) async {
    try {
      isLoading(true);

      final headers = {'Content-Type': 'application/json'};

      final body = json.encode({"phoneNumber": phoneNumber});

      final response = await http.post(
        Uri.parse("${Urls.baseUrl}/auth/resend-otp"),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['success'] == true) {
          // Update controller state
          message.value = data['data']['message'] ?? '';
          otp.value = data['data']['otp'].toString();

          print('OTP resent successfully: ${otp.value}');
          Get.snackbar('Success', data['message'] ?? 'OTP sent successfully');
          return true;
        } else {
          print('API returned failure: ${data['message']}');
          Get.snackbar('Error', data['message'] ?? 'Failed to resend OTP');
          return false;
        }
      } else {
        print('HTTP Error: ${response.statusCode}');
        print('Response: ${response.body}');
        Get.snackbar('Error', 'Server error (${response.statusCode})');
        return false;
      }
    } catch (e) {
      print(' Exception: $e');
      Get.snackbar('Error', e.toString());
      return false;
    } finally {
      isLoading(false);
    }
  }
}
