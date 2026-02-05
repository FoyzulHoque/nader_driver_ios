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
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Hey ${ride.vehicle?.driver?.fullName ?? 'Someone'} wants to ride with you",
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

            const SizedBox(height: 24),

            // Profile & Ride Info
            Row(
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundImage: (ride.user?.profileImage != null &&
                      ride.user!.profileImage!.isNotEmpty)
                      ? NetworkImage(ride.user!.profileImage!)
                      : const AssetImage("assets/icons/profile_pas.png")
                  as ImageProvider,
                ),
                const SizedBox(width: 12),
                Text(
                  ride.user?.fullName ?? "Unknown User",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _formatTime(ride.pickupTime ?? ""),
                      style: const TextStyle(color: Color(0xff000000)),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${(ride.distance ?? 0).toStringAsFixed(2)} km",
                      style: TextStyle(
                        color: const Color(0xff000000).withOpacity(0.3),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Route Info
            Row(
              children: [
                Image.asset("assets/icons/icon7.png", height: 20, width: 20),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    "Your Route",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                ),
                Text(
                  "Cash",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff777F8B),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // User and Price
            Row(
              children: [
                Image.asset("assets/icons/user.png", height: 20, width: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    ride.user?.fullName ?? "Unknown User",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                ),
                Text(CurrencyFormatter.format(ride.totalAmount ?? 0)),
              ],
            ),

            const SizedBox(height: 8),

            // Pickup Location
            Row(
              children: [
                Image.asset(
                  "assets/icons/location.png",
                  height: 20,
                  width: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    (ride.pickupLocation ?? "").isNotEmpty
                        ? ride.pickupLocation!
                        : "Unknown Pickup Address",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Helper function to format time string (e.g., "14:45") to "02:45 PM"
  String _formatTime(String timeString) {
    try {
      final parts = timeString.split(':'); // ["14", "45"]
      if (parts.length >= 2) {
        final hour = int.parse(parts[0]);
        final minute = int.parse(parts[1]);
        final now = DateTime.now();
        final time = DateTime(now.year, now.month, now.day, hour, minute);
        return DateFormat('hh:mm a').format(time); // e.g., 02:45 PM
      }
      return timeString;
    } catch (e) {
      return timeString;
    }
  }
}