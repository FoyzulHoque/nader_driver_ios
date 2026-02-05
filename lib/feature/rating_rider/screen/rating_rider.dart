import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/global_widegts/custom_button.dart';
import '../../../core/style/global_text_style.dart';
import '../controller/rating_rider_controller.dart';

class RatingScreen extends StatelessWidget {
  final RatingController controller = Get.put(
    RatingController(),
  ); // Initialize the controller

  @override
  Widget build(BuildContext context) {
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
              Spacer(),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return GestureDetector(
                        onTap: () => controller.setRating(
                          index + 1,
                        ), // Set rating when icon is tapped
                        child: Obx(() {
                          return Icon(
                            index < controller.rating.value
                                ? Icons.star
                                : Icons
                                      .star_border, // Filled or empty star based on the rating
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
                      color: Color(0xFF041023),
                    ),
                  ),
                  Text(
                    "We hope you enjoyed your ride",
                    style: globalTextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF777F8B),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),

              Obx(
                () => TextField(
                  onChanged:
                      controller.setDetails, // Update the details as user types
                  decoration: InputDecoration(
                    hintText: "Add review here... ",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  maxLines: 3,
                  controller: TextEditingController(
                    text: controller.details.value,
                  ), // Display current text
                ),
              ),
              Spacer(),
              CustomButton(
                title: "Submit",
                backgroundColor: Color(0xFFFFDC71),
                borderColor: Colors.transparent,
                onPress: () {
                  Get.to(() => RatingScreen());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
