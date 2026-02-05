import 'dart:convert';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../../../core/shared_preference/shared_preferences_helper.dart';
import '../../../../core/network_caller/endpoints.dart';
import '../../../location/view/location_screen.dart';

class GoogleSignInController extends GetxController {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  var isLoading = false.obs;

  /// Google Sign-In using FirebaseAuth + send idToken to backend
  Future<void> signInWithGoogle() async {
    try {
      isLoading.value = true;

      final GoogleSignInAccount? gUser = await _googleSignIn.signIn();
      if (gUser == null) {
        EasyLoading.showInfo("Google sign-in cancelled");
        return;
      }

      final GoogleSignInAuthentication gAuth = await gUser.authentication;

      final url = Uri.parse("${Urls.baseUrl}/auth/google-login-driver");
      final body = {
        "accessToken": gAuth.accessToken, // ← Correct token type
        "role": "DRIVER",
      };

      final res = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(body),
      );

      print("🔹 Google Login API Response: ${res.body}");

      if (res.statusCode == 200) {
        final data = json.decode(res.body);

        if (data["success"] == true) {
          final token = data["data"]["token"] ?? "";
          final user = data["data"]["user"] ?? {};

          if (token.isEmpty) {
            EasyLoading.showError("Token not found in response");
            return;
          }

          await SharedPreferencesHelper.saveToken(token);
          await SharedPreferencesHelper.saveSelectedRole(user["role"] ?? "");
          await SharedPreferencesHelper.saveUserId(user["id"] ?? "");

          EasyLoading.showSuccess("Logged in successfully ✅");

          Get.offAll(() => LocationScreen());
        } else {
          EasyLoading.showError(data["message"] ?? "Failed to login");
        }
      } else {
        EasyLoading.showError("Server Error: ${res.statusCode}");
      }
    } catch (e) {
      print("❌ Exception in Google login: $e");
      EasyLoading.showError("Something went wrong: $e");
    } finally {
      isLoading.value = false;
    }
  }

}
