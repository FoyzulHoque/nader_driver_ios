import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import '../controller/online_ride_controller.dart';
import '../widget/no_data.dart';
import '../widget/online_ride_card.dart';

class OnlineRideListSection extends StatefulWidget {
  const OnlineRideListSection({super.key});

  @override
  State<OnlineRideListSection> createState() => _OnlineRideListSectionState();
}

class _OnlineRideListSectionState extends State<OnlineRideListSection> {

  @override
  initState(){
    super.initState();
    rideOnlineController.fetchPendingRides();
  }

  final OnlineRideController rideOnlineController = Get.put(OnlineRideController());

  @override
  Widget build(BuildContext context) {

    // Reactive current month text
    final currentMonth = DateFormat('MMMM').format(DateTime.now()).obs;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      rideOnlineController.fetchPendingRides();
    });

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Divider(thickness: 1.5),
          ),
          // 🚘 Ride list with pull-to-refresh
          Expanded(
            child: Obx(() {
              if (rideOnlineController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              final rides = rideOnlineController.pendingRides;

              return RefreshIndicator(
                onRefresh: () async {
                  await rideOnlineController.fetchPendingRides();
                },
                child: Scrollbar(
                  thumbVisibility: true,
                  child: rides.isEmpty
                      ? const NoData()
                      : ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    itemCount: rides.length,
                    itemBuilder: (context, index) {
                      final ride = rides[index];
                      return OnlineRideCard(ride: ride);
                    },
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
