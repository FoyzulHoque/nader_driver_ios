import 'dart:async';
import 'package:get/get.dart';

import '../../../core/shared_preference/shared_preferences_helper.dart';
import '../../../route/route.dart';

class SplashScreenController extends GetxController {
  void checkIsLogin() async {
    Timer(const Duration(seconds: 3), () async {
      final showOnboard = await SharedPreferencesHelper.getShowOnboard();
      final token = await SharedPreferencesHelper.getAccessToken();

      if (!showOnboard) {
        await SharedPreferencesHelper.setShowOnboard(true);
        Get.offAllNamed(AppRoute.onboardingScreen);
      } else if (token != null && token.isNotEmpty) {
        Get.offAllNamed(AppRoute.bottomNavbarUser);
      } else {
        Get.offAllNamed(AppRoute.registerScreen);
      }
    });
  }

  @override
  void onInit() {
    super.onInit();
    checkIsLogin();
  }
}
