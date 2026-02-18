import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // ✅ Needed for DateFormat
import '../../../core/global_widegts/currency_formatter.dart';
import '../controller/AcceptAndDeclineController.dart';
import '../controller/driver_confirmation_controller.dart';
import '../model/online_ride_model.dart';

class BottomSheetOne extends StatelessWidget {
  final OnlineRideModel data;
  BottomSheetOne({super.key, required this.data});

  final DriverConfirmationController controller = Get.put(
    DriverConfirmationController(),
  );
  final AcceptAndDeclineController acceptAndDeclineController = Get.put(
    AcceptAndDeclineController(),
  );

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.55,
      minChildSize: 0.1,
      maxChildSize: 0.6,
      builder: (context, scrollController) {
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
                const SizedBox(height: 15),

                // Top drag handle
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

                const Center(
                  child: Text(
                    "Confirm your arrival",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 5),
                const Center(
                  child: Text(
                    "Confirm that you have reached your\n current location",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 20),

                // Ride Info Container
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade200),
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Hey Ahmed wants to ride with you",
                            style: TextStyle(fontSize: 14),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.yellow,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              "New",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Rider Info
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundImage: NetworkImage(
                              "${data.user?.profileImage}",
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${data.user?.fullName}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),

                                Text(
                                  "${_formatTime(data.pickupTime ?? '')} • ${(data.distance ?? 0.0).toStringAsFixed(2)} Km", // Handle nullable pickupTime
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Text(
                            "Cash",
                            style: TextStyle(fontSize: 13, color: Colors.grey),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            CurrencyFormatter.format(
                              data.totalAmount ?? 0.0,
                            ), // Handle nullable totalAmount
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),

                      Row(
                        children: [
                          const Icon(Icons.person, size: 20),
                          const SizedBox(width: 8),
                          Expanded(child: Text(data.user?.fullName ?? "N/A")),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              data.pickupLocation?.isNotEmpty == true
                                  ? data.pickupLocation!
                                  : "Unknown Pickup Address",
                            ),
                          ), // Handle nullable pickupLocation
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[300],
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          acceptAndDeclineController.respondToRequest(
                            carTransportId:
                                data.id ?? 'unknown', // Handle nullable id
                            responseStatus: "DECLINED",
                          );
                          Get.back();
                        },
                        child: const Text("Decline"),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.yellow[700],
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          acceptAndDeclineController.respondToRequest(
                            carTransportId:
                                data.id ?? 'unknown', // Handle nullable id
                            responseStatus: "ACCEPTED",
                          );
                          controller.changeSheet(2);
                          print("+++++++++++++++++${data.id}");
                        },
                        child: const Text("Accept"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Helper function for formatting "14:45" → "02:45 PM"
  String _formatTime(String timeString) {
    try {
      final parts = timeString.split(':');
      if (parts.length >= 2) {
        final hour = int.parse(parts[0]);
        final minute = int.parse(parts[1]);
        final now = DateTime.now();
        final time = DateTime(now.year, now.month, now.day, hour, minute);
        return DateFormat('hh:mm a').format(time); // 02:45 PM
      }
      return timeString;
    } catch (e) {
      return timeString;
    }
  }
}
