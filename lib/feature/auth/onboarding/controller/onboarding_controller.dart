import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../register/screen/register_screen.dart';

class OnboardingControllers extends GetxController {
  var currentPage = 0.obs;
  final PageController pageController = PageController();

  void onNextPage() {
    if (currentPage.value < 2) {
      pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    } else {
      Get.to(() => RegisterScreen());
    }
  }

  void onPageChanged(int index) {
    currentPage.value = index;
  }
}
