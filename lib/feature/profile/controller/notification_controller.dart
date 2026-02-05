import 'dart:convert';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../core/network_caller/endpoints.dart';
import '../../../core/shared_preference/shared_preferences_helper.dart';

class NotificationController extends GetxController {
  RxBool isSwitchOn = false.obs;
  RxBool isLoading = false.obs;
  RxString responseMessage = "".obs;
  var errorMessage = "".obs;

  void init(bool status) {
    isSwitchOn.value = status;
  }

  void toggleSwitch() {
    isSwitchOn.value = !isSwitchOn.value;
  }

  Future<void> toggleNotificationStatus(bool status) async {
    isLoading.value = true;

    final token = await SharedPreferencesHelper.getAccessToken();

    if (token == null || token.isEmpty) {
      errorMessage.value = "Access token not found. Please login.";
      print("Error: ${errorMessage.value}");
      EasyLoading.showError(errorMessage.value);
      isLoading.value = false; // ensure loading resets on early return
      return;
    }

    var headers = {
      'Authorization': token,
      'Content-Type': 'application/json'
    };

    var body = json.encode({"isNotificationOn": status});

    var request = http.Request(
      'PATCH',
      Uri.parse('${Urls.baseUrl}/users/toggle-notification-status'),
    );

    request.body = body;
    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var respString = await response.stream.bytesToString();
        responseMessage.value = respString;
        isSwitchOn.value = status;
        print("Success: $respString");
      } else {
        var error = await response.stream.bytesToString();
        responseMessage.value = error.isNotEmpty ? error : "Unknown error";
        print("Error: ${response.statusCode} - ${responseMessage.value}");
      }
    } catch (e) {
      responseMessage.value = e.toString();
      print("Exception: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
