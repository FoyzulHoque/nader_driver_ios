import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/const/nav_bar_images.dart';
import '../../home/view/rider_searching_screen.dart';

import '../../my_rides/screen/my_rides_screen.dart';
import '../../profile/screen/profile_screen.dart';
import '../controller/bottom_nav_user_controller.dart';

class BottomNavbarUser extends StatelessWidget {
  final int initialIndex;

  BottomNavbarUser({super.key, this.initialIndex = 0});

  final BottomNavUserController controller = Get.put(BottomNavUserController());

  final List<Widget> pages = [
    RiderSearchingScreen(),
    MyRidesScreen(),
    ProfileScreen(),
  ];

  Future<bool> _onWillPop(BuildContext context) async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Exit App'),
            content: Text('Do you really want to exit the app?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text('No'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.changeIndex(initialIndex);
    });
    return WillPopScope(
      onWillPop: () async {
        return await _onWillPop(context);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Obx(() => pages[controller.currentIndex.value]),

        bottomNavigationBar: BottomAppBar(
          elevation: 10,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildNavItem(
                  index: 0,
                  activeImage: NavBarImages.acthome,
                  passiveImage: NavBarImages.passhome,
                ),
                _buildNavItem(
                  index: 1,
                  activeImage: NavBarImages.actCalculate,
                  passiveImage: NavBarImages.passCalculate,
                ),
                /*_buildNavItem(
                  index: 2,
                  activeImage: NavBarImages.actChat,
                  passiveImage: NavBarImages.passChat,
                ),*/
                _buildNavItem(
                  index: 2,
                  activeImage: NavBarImages.actprofile,
                  passiveImage: NavBarImages.passprofile,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required String activeImage,
    required String passiveImage,
  }) {
    return GestureDetector(
      onTap: () => controller.changeIndex(index),
      child: Obx(() {
        final isSelected = controller.currentIndex.value == index;
        return Image.asset(
          isSelected ? activeImage : passiveImage,
          height: 45,
          fit: BoxFit.contain,
        );
      }),
    );
  }
}

