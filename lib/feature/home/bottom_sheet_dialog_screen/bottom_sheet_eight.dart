import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/global_widegts/currency_formatter.dart';
import '../controller/driver_confirmation_controller.dart';
import '../controller/endTripController.dart';
import '../model/online_ride_model.dart';

class BottomSheetEight extends StatelessWidget {
  late final OnlineRideModel data;
  BottomSheetEight({super.key, required this.data});

  final DriverConfirmationController controller = Get.put(
    DriverConfirmationController(),
  );
  final EndTripController endTripController = Get.put(EndTripController());

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.47,
      minChildSize: 0.1,
      maxChildSize: 0.5,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            boxShadow: [
              BoxShadow(color: Colors.black26, blurRadius: 10, spreadRadius: 1),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle bar
                const SizedBox(height: 15),
                Center(
                  child: Container(
                    height: 5,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                Center(
                  child: const Text(
                    "Your request has been complete?",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF777F8B),
                    ),
                  ),
                ),
                SizedBox(height: 5),

                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade200),
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Image.asset("assets/icons/user.png", height: 20, width: 20),
                          SizedBox(width: 12),
                          Text("${data.user?.fullName ?? "Unknown User"}",),
                          Spacer(),

                          Text(
                            "Cash",
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset(
                            "assets/icons/location.png",
                            height: 20,
                            width: 20,
                          ),

                          SizedBox(width: 12),
                          Text(
                            "${data.pickupLocation?.isNotEmpty == true ? data.dropOffLocation : "Unknown dropoffLocation Address"}", // Handle nullable pickupLocation
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF000000),
                            ),
                          ),
                          Spacer(),

                          Text(CurrencyFormatter.format(data.totalAmount ?? 0.0)) // Handle nullable totalAmount
                        ],
                      ),
                      const SizedBox(height: 15),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,

                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0XFFFFDC71),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () {
                      endTripController.endTrip(carTransportId: data.id ?? 'unknown'); // Handle nullable id
                      controller.changeSheet(9);
                    },
                    child: const Text(
                      "Yes",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0XFFF1F1F1),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      // controller.changeSheet(8);
                    },
                    child: const Text(
                      "No",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}