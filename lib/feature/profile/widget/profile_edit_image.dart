import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/profile_controller.dart';

class ProfileEditImage extends StatelessWidget {
  ProfileEditImage({super.key});

  // final ProfileImageController controller = Get.put(ProfileImageController());

  final uploadProfileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Obx(() {
            return Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: uploadProfileController.profileImage.isNotEmpty
                    ? Image.file(
                        uploadProfileController.profileImage.first,
                        fit: BoxFit.cover,
                        width: 100,
                        height: 100,
                      )
                    : (uploadProfileController.driverProfile.value?.profileImage != null && 
                        uploadProfileController.driverProfile.value!.profileImage!.isNotEmpty)
                        ? Image.network(
                            uploadProfileController.driverProfile.value!.profileImage!,
                            fit: BoxFit.cover,
                            width: 100,
                            height: 100,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                "assets/images/profile.png",
                                fit: BoxFit.cover,
                                width: 100,
                                height: 100,
                              );
                            },
                          )
                        : Image.asset(
                            "assets/images/profile.png",
                            fit: BoxFit.cover,
                            width: 100,
                            height: 100,
                          ),
              ),
            );
          }),

          // Positioned(
          //   bottom: -10,
          //   right: -10,
          //   child: GestureDetector(
          //     onTap: () async {
          //       await uploadProfileController.addProfileImage();
          //     },
          //     child: Container(
          //       width: 43,
          //       height: 44,
          //       decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(14),
          //         // color: boldVividRed,
          //       ),
          //       child: Center(
          //         child: SizedBox(
          //           height: 30,
          //           width: 30,
          //           child: Image.asset(
          //             "assets/images/camera.png",
          //             fit: BoxFit.contain,
          //           ),
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
