import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/review_controller.dart';

class ReviewScreen extends StatelessWidget {
  ReviewScreen({super.key});

  final ReviewController controller = Get.put(ReviewController());

  @override
  Widget build(BuildContext context) {
    //  Fetch reviews when screen loads
    controller.fetchMyReviews();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 22),
        ),
        title: const Text(
          "Review",
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          /// 🔹 1. Show loading spinner
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          /// 🔹 2. Show error message
          if (controller.errorMessage.value.isNotEmpty) {
            return Center(child: Text(controller.errorMessage.value));
          }

          /// 🔹 3. Show empty state
          if (controller.myReviews.isEmpty) {
            return const Center(child: Text("No reviews found"));
          }

          /// 🔹 4. Show reviews list
          return ListView.separated(
            itemCount: controller.myReviews.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = controller.myReviews[index];
              return Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade200,
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    )
                  ],
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundImage: NetworkImage(item.reviewer.profileImage),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.reviewer.fullName,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 15)),
                          const SizedBox(height: 6),

                          /// ⭐ Rating Stars
                          Row(
                            children: List.generate(5, (starIndex) {
                              double rating = item.rating.toDouble();
                              if (starIndex < rating.floor()) {
                                return const Icon(Icons.star,
                                    color: Colors.amber, size: 18);
                              } else if (starIndex < rating) {
                                return const Icon(Icons.star_half,
                                    color: Colors.amber, size: 18);
                              } else {
                                return const Icon(Icons.star_border,
                                    color: Colors.amber, size: 18);
                              }
                            }),
                          ),
                          const SizedBox(height: 6),

                          /// Comment
                          Text(item.comment,
                              style: const TextStyle(
                                  fontSize: 13, color: Colors.black54)),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text("Rating",
                            style: TextStyle(
                                fontSize: 13, color: Colors.grey)),
                        const SizedBox(height: 4),
                        Text(
                          item.rating.toString(),
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
