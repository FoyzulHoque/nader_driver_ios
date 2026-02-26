import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/global_widegts/currency_formatter.dart';
import '../controller/online_ride_controller.dart';
import '../model/online_ride_model.dart';

class OnlineRideCard extends StatelessWidget {
  final OnlineRideModel ride;

  const OnlineRideCard({super.key, required this.ride});

  @override
  Widget build(BuildContext context) {
    // Getting current driver name from the model if available, else 'Driver'
    final driverName = ride.vehicle?.driver?.fullName ?? "Driver";
    final riderName = ride.user?.fullName ?? "Someone";

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          Get.find<OnlineRideController>().selectAndOpenRide(ride);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header - Personalized Greeting
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Hey $driverName,\n$riderName wants to ride with you",
                  style: const TextStyle(fontSize: 14),
                ),
                const Text(
                  "New",
                  style: TextStyle(
                    color: Color(0xFFFFDC71),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Profile & Pickup Time
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage:
                      (ride.user?.profileImage != null &&
                          ride.user!.profileImage!.isNotEmpty)
                      ? NetworkImage(ride.user!.profileImage!)
                      : const AssetImage("assets/icons/profile_pas.png")
                            as ImageProvider,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    riderName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      "Pickup Time",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    Text(
                      _formatTime(ride.pickupTime ?? ""),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const Divider(height: 32),

            // Pickup Field
            Row(
              children: [
                Image.asset("assets/icons/location.png", height: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Pick up: ${ride.pickupLocation ?? 'Not specified'}",
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Drop off Field
            Row(
              children: [
                Image.asset("assets/icons/location.png", height: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Drop off: ${ride.dropOffLocation ?? 'Not specified'}",
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Distance: ${(ride.distance ?? 0).toStringAsFixed(2)} km"),
                Text(
                  CurrencyFormatter.format(ride.totalAmount ?? 0),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(String timeString) {
    try {
      final parts = timeString.split(':');
      if (parts.length >= 2) {
        final hour = int.parse(parts[0]);
        final minute = int.parse(parts[1]);
        final time = DateTime(0, 0, 0, hour, minute);
        return DateFormat('hh:mm a').format(time);
      }
      return timeString;
    } catch (e) {
      return timeString;
    }
  }
}
