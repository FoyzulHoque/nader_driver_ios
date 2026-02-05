import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/global_widegts/custom_button.dart';
import '../controller/profile_controller.dart';
import '../widget/profile_edit_image.dart';
import '../widget/license_image_widget.dart';

// class ProfileEditScreen extends StatelessWidget {
//   ProfileEditScreen({super.key});

//   final ProfileController profileController = Get.put(ProfileController());

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           onPressed: () => Get.back(),
//           icon: const Icon(Icons.arrow_back_ios),
//         ),
//         title: const Text('Update Profile'),
//         centerTitle: true,
//         elevation: 0,
//       ),
//       body: Obx(() {
//         final profile = profileController.driverProfile.value;

//         if (profile != null) {
//           profileController.nameController.text = profile.fullName ?? '';
//           profileController.cityController.text = profile.address ?? '';
//           profileController.emailController.text = profile.email ?? '';
//           profileController.phoneNumberController.text =
//               profile.phoneNumber ?? ''; // ✅ Added line
//         }

//         return Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 const SizedBox(height: 16),
//                 ProfileEditImage(),
//                 const SizedBox(height: 24),

//                 // ✅ Name
//                 TextFormField(
//                   enabled: false,
//                   controller: profileController.nameController,
//                   style: const TextStyle(
//                     color: Colors.black,
//                     fontSize: 16,
//                   ),
//                   decoration: InputDecoration(
//                     filled: true,
//                     fillColor:  Color(0xFFEFEEEE),
//                     disabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide: BorderSide(color:  Color(0xFFEFEEEE)),
//                     ),
//                     hintText: "Phone Number",
//                     hintStyle: const TextStyle(
//                       fontSize: 16,
//                       color: Color(0xFFEFEEEE),
//                     ),
//                   ),
//                 )
//                 ,
//                 const SizedBox(height: 12),

//                 // ✅ Phone Number (now visible)
//                 TextFormField(
//                   enabled: false,
//                   controller: profileController.phoneNumberController,
//                   style: const TextStyle(
//                     color: Colors.black,
//                     fontSize: 16,
//                   ),
//                   decoration: InputDecoration(
//                     filled: true,
//                     fillColor:  Color(0xFFEFEEEE),
//                     disabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide: BorderSide(color:  Color(0xFFEFEEEE)),
//                     ),
//                     hintText: "Phone Number",
//                     hintStyle: const TextStyle(
//                       fontSize: 16,
//                       color: Color(0xFFEFEEEE),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 12),

//                 // ✅ Email
//                 TextFormField(
//                   controller: profileController.emailController,
//                   decoration: InputDecoration(
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     hintText: "Email address",
//                     hintStyle: const TextStyle(
//                       fontSize: 16,
//                       color: Colors.grey,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 12),

//                 // ✅ City
//                 TextFormField(
//                   controller: profileController.cityController,
//                   decoration: InputDecoration(
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     hintText: "City you drive in",
//                     hintStyle: const TextStyle(
//                       fontSize: 16,
//                       color: Colors.grey,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 12),

//                 // ✅ Driving License Front Image
//                 LicenseImageWidget(
//                   title: "Driving License Front Page",
//                   hintText: "Tap to add front page image",
//                   imageList: profileController.drivingLicenseFrontImage,
//                   existingImageUrl: profileController.existingLicenseFrontUrl,
//                   onAddImage: () =>
//                       profileController.addDrivingLicenseFrontImage(),
//                   onRemoveImage: () =>
//                       profileController.removeDrivingLicenseFrontImage(),
//                 ),

//                 // ✅ Driving License Back Image
//                 LicenseImageWidget(
//                   title: "Driving License Back Page",
//                   hintText: "Tap to add back page image",
//                   imageList: profileController.drivingLicenseBackImage,
//                   existingImageUrl: profileController.existingLicenseBackUrl,
//                   onAddImage: () =>
//                       profileController.addDrivingLicenseBackImage(),
//                   onRemoveImage: () =>
//                       profileController.removeDrivingLicenseBackImage(),
//                 ),

//                 const SizedBox(height: 150),

//                 // ✅ Update Button
//                 CustomButton(
//                   title: "Update",
//                   backgroundColor: const Color(0xFfFFDC71),
//                   borderColor: Colors.transparent,
//                   onPress: () {
//                     profileController.updateProfile();
//                   },
//                 ),

//                 const SizedBox(height: 40),
//               ],
//             ),
//           ),
//         );
//       }),
//     );
//   }
// }
class ProfileEditScreen extends StatelessWidget {
  ProfileEditScreen({super.key});

  final ProfileController profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: const Text('Update Profile'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Obx(() {
        final profile = profileController.driverProfile.value;

        if (profile != null) {
          // Auto-fill controllers only if not already set (to avoid overwriting user edits)
          if (profileController.nameController.text.isEmpty) {
            profileController.nameController.text = profile.fullName ?? '';
          }
          if (profileController.cityController.text.isEmpty) {
            profileController.cityController.text = profile.address ?? '';
          }
          if (profileController.emailController.text.isEmpty) {
            profileController.emailController.text = profile.email ?? '';
          }
          if (profileController.phoneNumberController.text.isEmpty) {
            profileController.phoneNumberController.text =
                profile.phoneNumber ?? '';
          }
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),

                // Profile Image Section (added - তোমার controller-এ আছে, এখন UI add করলাম)
                GestureDetector(
                  onTap: () => profileController.addProfileImage(),
                  child: Obx(
                    () => Center(
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.grey[300],
                            backgroundImage:
                                profileController.profileImage.isNotEmpty
                                ? FileImage(profileController.profileImage[0])
                                : (profile?.profileImage != null &&
                                          profile!.profileImage!.isNotEmpty
                                      ? NetworkImage(profile.profileImage!)
                                            as ImageProvider
                                      : null),
                            child:
                                profileController.profileImage.isEmpty &&
                                    (profile?.profileImage == null ||
                                        profile!.profileImage!.isEmpty)
                                ? const Icon(
                                    Icons.person,
                                    size: 60,
                                    color: Colors.grey,
                                  )
                                : null,
                          ),
                          if (profileController.profileImage.isNotEmpty ||
                              (profile?.profileImage != null))
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: CircleAvatar(
                                radius: 18,
                                backgroundColor: Colors.blue,
                                child: Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Center(
                  child: Text(
                    "Tap to change profile picture",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 32),

                // Name - এখন editable
                TextFormField(
                  controller: profileController.nameController,
                  decoration: InputDecoration(
                    labelText: "Full Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                ),
                const SizedBox(height: 16),

                // Phone Number - disabled রাখলাম (যদি editable চাও তাহলে enabled: true করো)
                TextFormField(
                  enabled: false, // ← চাইলে true করো
                  controller: profileController.phoneNumberController,
                  decoration: InputDecoration(
                    labelText: "Phone Number",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                ),
                const SizedBox(height: 16),

                // Email
                TextFormField(
                  controller: profileController.emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: "Email address",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // City
                TextFormField(
                  controller: profileController.cityController,
                  decoration: InputDecoration(
                    labelText: "City you drive in",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Driving License Front
                LicenseImageWidget(
                  title: "Driving License Front Page",
                  hintText: "Tap to add front page image",
                  imageList: profileController.drivingLicenseFrontImage,
                  existingImageUrl: profileController.existingLicenseFrontUrl,
                  onAddImage: profileController.addDrivingLicenseFrontImage,
                  onRemoveImage:
                      profileController.removeDrivingLicenseFrontImage,
                ),
                const SizedBox(height: 16),

                // Driving License Back
                LicenseImageWidget(
                  title: "Driving License Back Page",
                  hintText: "Tap to add back page image",
                  imageList: profileController.drivingLicenseBackImage,
                  existingImageUrl: profileController.existingLicenseBackUrl,
                  onAddImage: profileController.addDrivingLicenseBackImage,
                  onRemoveImage:
                      profileController.removeDrivingLicenseBackImage,
                ),

                const SizedBox(height: 40),

                // Update Button
                CustomButton(
                  title: "Update Profile",
                  backgroundColor: const Color(0xFFFFDC71),
                  borderColor: Colors.transparent,
                  onPress: profileController.updateProfile,
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      }),
    );
  }
}
