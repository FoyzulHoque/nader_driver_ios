import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/signup_controller.dart';


class NidCardWidget extends StatelessWidget {
  NidCardWidget({super.key});

  // Use IdController instead of SignUpController
  final signUpController = Get.put(SignUpController());

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "ID",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF344054),
            ),
          ),
          const SizedBox(height: 10),

          // Dynamic NID Images
          Obx(() {
            return Row(
              children: [
                // Existing uploaded images
                ...List.generate(
                  signUpController.idImages.length,
                      (index) {
                    return Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 10),
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: FileImage(
                                signUpController.idImages[index],
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: GestureDetector(
                            onTap: () => signUpController.removeIdImage(index),
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(4),
                              child: const Icon(
                                Icons.delete,
                                color: Colors.red,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),

                // Add Button (Maximum 2 Image)
                if (signUpController.idImages.length < 2)
                  GestureDetector(
                    onTap: () => signUpController.addIdImage(),
                    child: Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.red, width: 1.5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Icon(Icons.add, color: Colors.red, size: 32),
                      ),
                    ),
                  ),
              ],
            );
          }),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
