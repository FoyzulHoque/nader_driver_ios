import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/rider_searching_controller.dart';
import '../widget/no_data.dart';
import 'offline_ride_list_screen.dart';
import 'online_ride_list_section.dart';

class RiderSearchingScreen extends StatelessWidget {
  RiderSearchingScreen({super.key});

  final RiderSearchingController riderSearchingController = Get.put(
    RiderSearchingController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Toggle Button
            Padding(
              padding: const EdgeInsets.all(16),
              child: Obx(
                () => Container(
                  height: 53,
                  decoration: BoxDecoration(
                    color: const Color(0xffF5F5F5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () =>
                              riderSearchingController.toggleStatus(true),
                          child: Container(
                            decoration: BoxDecoration(
                              color:
                                  riderSearchingController.isOnline.value ==
                                      true
                                  ? Colors.yellow[600]
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              "Online",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color:
                                    riderSearchingController.isOnline.value ==
                                        true
                                    ? Colors.black
                                    : Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () =>
                              riderSearchingController.toggleStatus(false),
                          child: Container(
                            decoration: BoxDecoration(
                              color:
                                  riderSearchingController.isOnline.value ==
                                      false
                                  ? Colors.yellow[600]
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              "Offlines",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color:
                                    riderSearchingController.isOnline.value ==
                                        false
                                    ? Colors.black
                                    : Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Show sections dynamically
            Expanded(
              child: Obx(() {
                if (riderSearchingController.isOnline.value == true) {
                  return OnlineRideListSection();
                } else if (riderSearchingController.isOnline.value == false) {
                  return OfflineRideListScreen();
                } else {
                  return const NoData();
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}
