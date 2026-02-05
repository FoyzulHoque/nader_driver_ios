import 'package:get/get.dart';
import 'my_rides_cancelled_controller.dart';
import 'my_rides_completed_controller.dart';

class MyRidesController extends GetxController {
  final MyRidesCancelledController myRidesHistoryController = Get.put(MyRidesCancelledController());
  final MyRidesCompletedController myRidesCompletedController = Get.put(MyRidesCompletedController());


  var currentTabIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();

    ever(currentTabIndex, (index) {
      if (index == 0) {
      myRidesCompletedController.fetchMyCompletedRidesData();
      }
      if (index == 1) {
        myRidesHistoryController.fetchMyCanceledRidesData();
      }
    });
  }
  /// Change tab index
  void changeTab(int index) {
    currentTabIndex.value = index;
  }
}
