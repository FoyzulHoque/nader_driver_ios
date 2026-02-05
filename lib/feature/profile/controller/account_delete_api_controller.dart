import 'package:get/get.dart';
import 'package:nader_driver/core/network_caller/endpoints.dart';
import 'package:nader_driver/core/network_caller/network_config.dart';
import '../../../core/shared_preference/shared_preferences_helper.dart';

class DeleteApiController extends GetxController {
  Future<bool> deleteApiMethod(String id) async {
    bool isSuccess = false;
    try {
      print("🔹 Delete API called for ID: $id");

      NetworkResponse response = await NetworkCall.deleteRequest(
        url: NetworkPath.usersDeleteAccount(id),
      );

      print("🔹 Response Status: ${response.statusCode}");
      print("🔹 Response Body: ${response.responseData}");

      if (response.isSuccess) {
        isSuccess = true;
        await SharedPreferencesHelper.getAccessToken();
      } else {
        print("❌ Delete failed: ${response.errorMessage}");
      }
    } catch (e) {
      print("⚠ Delete API error: $e");
    }
    return isSuccess;
  }
}
