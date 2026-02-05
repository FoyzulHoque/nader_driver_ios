/*
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/const/image_path.dart';
import '../../../core/global_widegts/custom_button.dart';
import '../../../core/shared_preference/shared_preferences_helper.dart';
import '../../bottom_navbar/screen/bottom_nav_user.dart';
import '../../location/controller/location_controller.dart';
import '../../signup/view/signup_screen.dart';

class LocationScreen extends StatelessWidget {
  const LocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final LocationController locationController = Get.put(LocationController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              Image.asset(
                ImagePath.map,
                width: 279,
                height: 258,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 50),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "We need to know your
location in order to
suggest nearby stations",
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: 29,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                ),
              ),
              const Spacer(),

            CustomButton(
              borderColor: Color(0xFF777F8B),
              title: "Use Current Location",
              onPress: () async {
                await locationController.requestLocationPermission();

                if (locationController.isLocationAllowed.value &&
                    locationController.currentLocation.value != null) {
                  final loc = locationController.currentLocation.value!;

                  // 🔹 Shared Pref check
                  final bool isExist = await SharedPreferencesHelper.getIsExist() ?? false;


                  if (isExist==true) {
                    print("----isExist----------$isExist");
                    // ✅ Already exists → go to BottomNavbarUser
                    Get.offAll(() => BottomNavbarUser());
                  } else {
                    // ❌ Not exist → go to SignUpScreen
                    Get.to(() => SignUpScreen(
                      latitude: loc.latitude!,
                      longitude: loc.longitude!,
                    ));
                  }
                } else {
                  Get.snackbar("Error", "Location permission denied");
                }
              },
            ),
            const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
*/
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/const/image_path.dart';
import '../../../core/global_widegts/custom_button.dart';
import '../../../core/shared_preference/shared_preferences_helper.dart';
import '../../bottom_navbar/screen/bottom_nav_user.dart';
import '../../location/controller/location_controller.dart';
import '../../signup/view/signup_screen.dart';

class LocationScreen extends StatelessWidget {
  const LocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final LocationController controller = Get.put(LocationController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50),

              // Map illustration
              Image.asset(
                ImagePath.map,
                width: 279,
                height: 258,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 50),

              // Main text
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '''We need to know your
location in order to
suggest nearby stations''',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: 29,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                ),
              ),

              const Spacer(),

              // Button + loading & error handling
              Obx(() => Column(
                    children: [
                      CustomButton(
                        borderColor: const Color(0xFF777F8B),
                        title: controller.isLoading.value
                            ? "Fetching location..."
                            : "Use Current Location",
                        backgroundColor: controller.isLoading.value
                            ? Colors.grey
                            : Colors.transparent,
                        textStyle: TextStyle(
                          color: controller.isLoading.value
                              ? Colors.white
                              : const Color(0xff2D2D2D),
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                        onPress: controller.isLoading.value
                            ? () {}
                            : () async {
                                final success =
                                    await controller.requestAndFetchLocation();

                                if (!success) {
                                  Get.snackbar(
                                    "Error",
                                    controller.errorMessage.value ??
                                        "Could not get your location",
                                    snackPosition: SnackPosition.BOTTOM,
                                    duration: const Duration(seconds: 4),
                                  );
                                  return;
                                }

                                // Safe access (we already checked null in controller)
                                final loc = controller.currentLocation.value!;
                                final latitude = loc.latitude!;
                                final longitude = loc.longitude!;

                                final bool isExist =
                                    await SharedPreferencesHelper.getIsExist() ??
                                        false;

                                if (isExist) {
                                  print("----isExist----------$isExist");
                                  Get.offAll(() => BottomNavbarUser());
                                } else {
                                  Get.to(() => SignUpScreen(
                                        latitude: latitude,
                                        longitude: longitude,
                                      ));
                                }
                              },
                      ),
                      const SizedBox(height: 20),

                      // Show error message if any
                      if (controller.errorMessage.value != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            controller.errorMessage.value!,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                    ],
                  )),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
