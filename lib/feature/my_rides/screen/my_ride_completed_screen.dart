import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/my_rides_completed_controller.dart';
import '../widget/task_card_widget.dart';

class MyRideCompletedScreen extends StatelessWidget {
  MyRideCompletedScreen({super.key});

  final MyRidesCompletedController myRidesCompletedController = Get.put(MyRidesCompletedController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Obx(() {
        if (myRidesCompletedController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (myRidesCompletedController.myRides.isEmpty) {
          return const Center(child: Text("No rides found"));
        }

        return ListView.builder(
          itemCount: myRidesCompletedController.myRides.length,
          itemBuilder: (context, index) {
            final ride = myRidesCompletedController.myRides[index];

            return TaskCardWidget(task: ride);
          },
        );
      }),
    );
  }
}
