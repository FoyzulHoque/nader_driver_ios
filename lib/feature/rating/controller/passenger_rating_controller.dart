import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../core/network_caller/endpoints.dart';
import '../../../core/shared_preference/shared_preferences_helper.dart';

class PassengerRatingController extends GetxController {
  /// Reactive variables
  var rating = 0.obs;
  var reviewText = ''.obs;
  var isLoading = false.obs;

  /// Token
  String _token = '';

  /// API URL
  final String _url = '${Urls.baseUrl}/reviews/create';

  @override
  void onInit() {
    super.onInit();
    loadToken();
  }

  /// Load token asynchronously from SharedPreferences
  Future<void> loadToken() async {
    _token = await SharedPreferencesHelper.getAccessToken() ?? '';
    print('Loaded token: $_token');
  }

  /// Setters
  void setRating(int value) => rating.value = value;
  void setReview(String value) => reviewText.value = value;

  /// Create Review API
  Future<bool> submitReview(String carTransportId) async {
    if (_token.isEmpty) {
      await loadToken();
    }

    try {
      isLoading(true);

      final headers = {
        'Authorization': _token, // Ensure token is a string
        'Content-Type': 'application/json',
      };

      final body = json.encode({
        "carTransportId": carTransportId,
        "rating": rating.value,
        "comment": reviewText.value,
      });

      final response = await http.post(
        Uri.parse(_url),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 201) {
        print('Review submitted: ${response.body}');
        Get.snackbar('Success', 'Review submitted successfully!');
        return true;
      } else {
        print('Error: ${response.statusCode}');
        print('Response: ${response.body}');
        Get.snackbar('Error', 'Failed to submit review');
        return false;
      }
    } catch (e) {
      print('Exception: $e');
      Get.snackbar('Error', e.toString());
      return false;
    } finally {
      isLoading(false);
    }
  }
}
