import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../review/view/review_submitted_screen.dart';
import '../controller/passenger_rating_controller.dart';

class PassengerRatingScreen extends StatelessWidget {
  final String reviewId;
  PassengerRatingScreen(this.reviewId, {super.key});

  // Initialize controller
  final PassengerRatingController controller = Get.put(PassengerRatingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Review ID: $reviewId"), // For debugging
              /// Close Button
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(Icons.close, size: 28),
                  onPressed: () => Get.back(),
                ),
              ),

              const SizedBox(height: 20),

              /// Rating Stars
              Obx(
                    () => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return IconButton(
                      onPressed: () => controller.setRating(index + 1),
                      icon: Icon(
                        Icons.star,
                        size: 40,
                        color: index < controller.rating.value
                            ? Colors.amber
                            : Colors.grey.shade300,
                      ),
                    );
                  }),
                ),
              ),

              const SizedBox(height: 20),

              /// Question Text
              const Text(
                "How was the passenger behavior?",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5),
              const Text(
                "Your overall rating",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),

              const SizedBox(height: 25),

              /// Review Input
              TextField(
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: "Write your review here...",
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) => controller.setReview(value),
              ),

              const Spacer(),

              /// Submit Button
              Obx(() {
                return SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : () async {
                      final success = await controller.submitReview(reviewId);
                      if (success) {
                        Get.off(() => ReviewSubmittedScreen());
                      }
                    },
                    child: controller.isLoading.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                      "Submit Review",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              }),


              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
