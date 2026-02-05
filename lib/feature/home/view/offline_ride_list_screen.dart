import 'package:flutter/material.dart';

import '../controller/offline_ride_controller.dart';
import 'package:get/get.dart';

import '../widget/offline_ride_card.dart';

class OfflineRideListScreen extends StatelessWidget {
  const OfflineRideListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final OfflineRideController offlineRideController = Get.put(
      OfflineRideController(),
    );
    offlineRideController.fetchOfflineRidesData();
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Divider(thickness: 1.5,),
          ),
          /// Ride List
          Expanded(
            child: Obx(
              () => Scrollbar(
                thumbVisibility: true,
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: offlineRideController.rideHistory.length,
                  itemBuilder: (context, index) {
                    return OfflineRideCard(
                      ride: offlineRideController.rideHistory[index],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
