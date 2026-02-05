import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/my_rides_cancelled_controller.dart';
import '../widget/task_cancelled_card_widget.dart';


class MyRideCancelledScreen extends StatelessWidget {
  MyRideCancelledScreen({super.key});


  final MyRidesCancelledController myRidesHistoryController = Get.put(MyRidesCancelledController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Obx(
            () => ListView.builder(
          itemCount: myRidesHistoryController.rideHistory.length,
          itemBuilder: (context, index) {
            final task = myRidesHistoryController.rideHistory[index];
            return TaskCancelledCardWidget(taskCancel: task);
          },
        ),
      ),
    );
  }
}

