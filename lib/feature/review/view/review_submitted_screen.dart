import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../bottom_navbar/screen/bottom_nav_user.dart';


class ReviewSubmittedScreen extends StatefulWidget {
  const ReviewSubmittedScreen({super.key});

  @override
  State<ReviewSubmittedScreen> createState() => _ReviewSubmittedScreenState();
}

class _ReviewSubmittedScreenState extends State<ReviewSubmittedScreen> {
  @override
  void initState() {
    super.initState();


    Future.delayed(const Duration(seconds: 1), () {
      Get.offAll(() => BottomNavbarUser());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/ride_success.png"),
            const SizedBox(height: 20),
            const Text(
              "Review Submitted Successfully!",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
