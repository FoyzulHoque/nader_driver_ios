import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/review_controller.dart';

class ReviewScreen extends StatelessWidget {
  ReviewScreen({super.key});

  final ReviewController controller = Get.put(ReviewController());

  @override
  Widget build(BuildContext context) {
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
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
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

          /// 🔹 4. Show reviews list with Header
          return Column(
            children: [
              /// ⭐ Overall Rating Header
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: [
                    Text(
                      controller.avgRating.value.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (starIndex) {
                        return Icon(
                          starIndex < controller.avgRating.value.floor()
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.amber,
                          size: 24,
                        );
                      }),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Based on ${controller.myReviews.length} reviews",
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const Divider(),

              /// 🔹 Scrollable Reviews List
              Expanded(
                child: ListView.separated(
                  itemCount: controller.myReviews.length,
                  padding: const EdgeInsets.only(top: 10, bottom: 20),
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = controller.myReviews[index];
                    return Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade100),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundImage: NetworkImage(
                              item.reviewer.profileImage,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      item.reviewer.fullName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.amber.shade100,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.star,
                                            size: 12,
                                            color: Colors.amber,
                                          ),
                                          Text(
                                            " ${item.rating}",
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  item.comment.isEmpty
                                      ? "No comment provided"
                                      : item.comment,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black87,
                                  ),
                                ),
                                if (item.isFlagged) ...[
                                  const SizedBox(height: 4),
                                  const Text(
                                    "Reported by system",
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
