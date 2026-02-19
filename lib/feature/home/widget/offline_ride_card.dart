import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/offline_ride_model.dart';

class OfflineRideCard extends StatelessWidget {
  final OfflineRideModel ride;
  const OfflineRideCard({super.key, required this.ride});

  @override
  Widget build(BuildContext context) {
    String formattedTime = "";
    try {
      DateTime pickupDateTime = DateTime.parse(ride.pickupTime);
      formattedTime = DateFormat("hh:mm a").format(pickupDateTime);
    } catch (e) {
      formattedTime =
          ride.pickupTime; // Use the original pickup time if parsing fails
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Status & Time
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                ride.status,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
              Text(
                _formatTime(ride.pickupTime),
                style: const TextStyle(color: Colors.black54, fontSize: 18),
              ),
            ],
          ),
          const SizedBox(height: 12),

          /// Pickup Name
          Row(
            children: [
              Image.asset("assets/icons/user.png", height: 16),
              const SizedBox(width: 8),
              Text(
                "${ride.user?.fullName}",
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          /// Destination
          Row(
            children: [
              Image.asset("assets/icons/location.png", height: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  ride.pickupLocation,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          /// Payment & Amount
          Row(
            children: [
              Image.asset("assets/icons/cash.png", height: 16),
              const SizedBox(width: 8),
              Text(
                "${ride.totalAmount} LBP",
                style: const TextStyle(
                  color: Color(0xFFFFDC71),
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper function for formatting "14:45" → "02:45 PM"
  String _formatTime(String timeString) {
    try {
      final parts = timeString.split(':'); // ["14", "45"]
      if (parts.length >= 2) {
        final hour = int.parse(parts[0]);
        final minute = int.parse(parts[1]);
        final now = DateTime.now();
        final time = DateTime(now.year, now.month, now.day, hour, minute);
        return DateFormat('hh:mm a').format(time); // output: 02:45 PM
      }
      return timeString;
    } catch (e) {
      return timeString;
    }
  }
}
