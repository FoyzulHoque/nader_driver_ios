import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nader_driver/feature/review/view/review_submitted_screen.dart';

import '../../../core/global_widegts/custom_button.dart';
import '../../../core/style/global_text_style.dart';
import '../controller/rating_rider_controller.dart';

class RatingScreen extends StatelessWidget {
  final RatingController controller = Get.put(RatingController());

  RatingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Use a persistent TextEditingController to avoid cursor-reset bug
    final TextEditingController textController = TextEditingController();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Image.asset(
                  "assets/images/cross.png",
                  width: 50,
                  height: 50,
                ),
              ),
              const Spacer(),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return GestureDetector(
                        onTap: () => controller.setRating(index + 1),
                        child: Obx(() {
                          return Icon(
                            index < controller.rating.value
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.amber,
                            size: 40,
                          );
                        }),
                      );
                    }),
                  ),
                  Text(
                    "How was your Trip",
                    style: globalTextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF041023),
                    ),
                  ),
                  Text(
                    "We hope you enjoyed your ride",
                    style: globalTextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF777F8B),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // ✅ Removed Obx wrapper — TextField doesn't need it
              TextField(
                controller: textController,
                onChanged: controller.setDetails,
                decoration: InputDecoration(
                  hintText: "Add review here...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                maxLines: 3,
              ),

              const Spacer(),

              CustomButton(
                title: "Submit",
                backgroundColor: const Color(0xFFFFDC71),
                borderColor: Colors.transparent,
                onPress: () {
                  // ✅ Validate before navigating
                  if (controller.isValid()) {
                    Get.to(() => ReviewSubmittedScreen());
                  } else {
                    Get.snackbar(
                      'Review Required',
                      'Please select a star rating or write a comment before submitting.',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red.shade100,
                      colorText: Colors.red.shade900,
                      margin: const EdgeInsets.all(16),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
