import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../../core/network_caller/endpoints.dart';
import '../../../core/shared_preference/shared_preferences_helper.dart';

class EndTripController extends GetxController {
  var isLoading = false.obs;

  Future<void> endTrip({
    required String carTransportId, // ACCEPTED or DECLINED
  }) async {
    isLoading.value = true;

    try {
      String? token = await SharedPreferencesHelper.getAccessToken(); // Token fetch

      final url = Uri.parse("${Urls.baseUrl}/carTransports/complete-ride");

      Map<String, dynamic> body = {
        "carTransportId": carTransportId,
      };

      final res = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token ?? "",
        },
        body: json.encode(body),
      );

      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        if (data['success'] == true) {
          Get.snackbar("Success", data['message'] ?? "Response sent successfully");
          print("✅ Response success: ${data['message']}");
        } else {
          Get.snackbar("Error", data['message'] ?? "Something went wrong");
          print("❌ API returned failure: ${data['message']}");
        }
      } else {
        Get.snackbar("Error", "Status code: ${res.statusCode}");
        print("❌ Error: Status ${res.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Error", "Exception occurred");
      print("❌ Exception sending response: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
