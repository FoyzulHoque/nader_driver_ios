import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/style/global_text_style.dart';
import '../controller/my_rides_controller.dart';
import 'my_ride_cancelled_screen.dart';
import 'my_ride_completed_screen.dart';

class MyRidesScreen extends StatefulWidget {
  const MyRidesScreen({super.key});

  @override
  State<MyRidesScreen> createState() => _MyRidesScreenState();
}

class _MyRidesScreenState extends State<MyRidesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final MyRidesController myRidesController = Get.put(MyRidesController());

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: myRidesController.currentTabIndex.value,
    );

    // Listen to UI tab changes
    _tabController.addListener(() {
      if (_tabController.index != myRidesController.currentTabIndex.value) {
        myRidesController.changeTab(_tabController.index);
      }
    });

  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "My rides",
                  style: globalTextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF212529),
                  ),
                ),
              ),
              SizedBox(height: 30),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Color(0xFFF2F2F2),
                ),
                child: ButtonsTabBar(
                  controller: _tabController, // MUST pass controller
                  backgroundColor: Color(0xFFFFDC71),
                  unselectedBackgroundColor: Colors.white,
                  unselectedLabelStyle: TextStyle(color: Color(0xFF4D5154)),
                  contentPadding: EdgeInsets.symmetric(horizontal: 53, vertical: 0),
                  buttonMargin: EdgeInsets.symmetric(horizontal: 10),
                  radius: 30,
                  labelStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  tabs: [
                    Tab(text: "Completed"),
                    Tab(text: "Cancelled"),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    MyRideCompletedScreen(),
                    MyRideCancelledScreen(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
