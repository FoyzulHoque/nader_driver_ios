import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nader_driver/feature/profile/screen/privacy_policy_screen.dart';
import 'package:nader_driver/feature/profile/screen/profile_edit_screen.dart';
import 'package:nader_driver/feature/profile/screen/review_screen.dart';
import 'package:nader_driver/feature/profile/screen/wallet_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/shared_preference/shared_preferences_helper.dart';
import '../../../core/style/global_text_style.dart';
import '../../auth/register/screen/register_screen.dart';
import '../../bottom_navbar/screen/bottom_nav_user.dart';
import '../controller/account_delete_api_controller.dart';
import '../controller/notification_controller.dart';
import '../controller/profile_controller.dart';
import '../widget/notification_widget.dart';
import '../widget/profile_action_widgets.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileController profileController = Get.put(ProfileController());
  final DeleteApiController deleteApiController = Get.put(
    DeleteApiController(),
  );
  final NotificationController notificationController = Get.put(
    NotificationController(),
    tag: "Notification",
  );
  bool _isNotificationInitialized = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        final profile = profileController.driverProfile.value;

        if (profile != null && !_isNotificationInitialized) {
          notificationController.init(profile.isNotificationOn ?? false);
          _isNotificationInitialized = true;
        }

        return SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    "Profile",
                    style: globalTextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(width: 1, color: Colors.black12),
                    ),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: GestureDetector(
                            onTap: () {
                              Get.to(() => ProfileEditScreen());
                            },

                            child: Image.asset(
                              "assets/images/edit.png",
                              width: 24,
                              height: 24,
                            ),
                          ),
                        ),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: 62,
                              width: 62,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Obx(() {
                                  // Check if there's a local selected image first
                                  if (profileController
                                      .profileImage
                                      .isNotEmpty) {
                                    return Image.file(
                                      profileController.profileImage.first,
                                      fit: BoxFit.cover,
                                      width: 62,
                                      height: 62,
                                    );
                                  }
                                  // Fallback to network image if available
                                  else if (profileController
                                              .driverProfile
                                              .value
                                              ?.profileImage !=
                                          null &&
                                      profileController
                                          .driverProfile
                                          .value!
                                          .profileImage!
                                          .isNotEmpty) {
                                    return Image.network(
                                      profileController
                                          .driverProfile
                                          .value!
                                          .profileImage!,
                                      fit: BoxFit.cover,
                                      width: 62,
                                      height: 62,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return Image.asset(
                                              "assets/images/profile.png",
                                              fit: BoxFit.cover,
                                              width: 62,
                                              height: 62,
                                            );
                                          },
                                    );
                                  }
                                  // Default fallback image
                                  else {
                                    return Image.asset(
                                      "assets/images/profile.png",
                                      fit: BoxFit.cover,
                                      width: 62,
                                      height: 62,
                                    );
                                  }
                                }),
                              ),
                            ),

                            const SizedBox(height: 8),
                            Text(
                              profile?.fullName.isNotEmpty == true
                                  ? profile!.fullName
                                  : "",
                              style: globalTextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF041023),
                              ),
                            ),
                            Text(
                              profile?.email ?? "No Email",
                              // style: h74TextStyle(darkNavyBlue),
                            ),
                            Divider(),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                          size: 20,
                                        ),
                                        Text(
                                          "My Rating",
                                          style: globalTextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF777F8B),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Obx(
                                      () => Text(
                                        profileController.averageRating.value,
                                        style: globalTextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.location_on,
                                          color: Colors.amber,
                                          size: 20,
                                        ),
                                        Text(
                                          "Total Distance ",
                                          style: globalTextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF777F8B),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      profile?.totalDistance.toString() ??
                                          "0.0KM",
                                      style: globalTextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),

                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.electric_bike,
                                          color: Colors.amber,
                                          size: 20,
                                        ),
                                        Text(
                                          " Total trip",
                                          style: globalTextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF777F8B),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      profile?.totalTrips.toString() ?? "",
                                      style: globalTextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 21),

                  const SizedBox(height: 21),

                  // Notification Widget
                  Obx(() {
                    return NotificationWidget(
                      tagId: "Notification",
                      image: "assets/icons/notification.png",
                      actionName: "Notification",
                      style: globalTextStyle(),
                      voidCallback: () {
                        final newValue =
                            !notificationController.isSwitchOn.value;
                        notificationController.toggleNotificationStatus(
                          newValue,
                        );
                      },
                      isSwitched: notificationController.isSwitchOn.value,
                      controller: notificationController, // pass it directly
                    );
                  }),
                  const SizedBox(height: 21),
                  ProfileActionWidgets(
                    image: "assets/icons/car.png",
                    actionName: "My rides",
                    style: globalTextStyle(),
                    voidCallback: () {
                      Get.offAll(() => BottomNavbarUser(initialIndex: 1));
                    },
                    iconData: (Icons.arrow_forward_ios),
                    size: 18,
                  ),
                  const SizedBox(height: 21),

                  ProfileActionWidgets(
                    image: "assets/icons/wallet.png",
                    actionName: "My Wallet",
                    style: globalTextStyle(),
                    voidCallback: () {
                      Get.to(() => WalletScreen());
                    },
                    iconData: (Icons.arrow_forward_ios),
                    size: 18,
                  ),
                  const SizedBox(height: 21),

                  ProfileActionWidgets(
                    image: "assets/icons/review.png",
                    actionName: "Review & Rating",
                    style: globalTextStyle(),
                    voidCallback: () {
                      Get.to(() => ReviewScreen());
                    },
                    iconData: (Icons.arrow_forward_ios),
                    size: 18,
                  ),
                  const SizedBox(height: 21),

                  ProfileActionWidgets(
                    image: "assets/icons/support.png",
                    actionName: "Customer Support",
                    style: globalTextStyle(),
                    voidCallback: () async {
                      final Uri phoneUri = Uri(
                        scheme: 'tel',
                        path: '+8801753601584',
                        // path: '${profile!.phoneNumber}',
                      );

                      if (await canLaunchUrl(phoneUri)) {
                        await launchUrl(phoneUri);
                      } else {
                        // Handle error
                        print('Could not launch $phoneUri');
                      }
                    },
                    iconData: Icons.arrow_forward_ios,
                    size: 18,
                  ),

                  const SizedBox(height: 21),

                  ProfileActionWidgets(
                    image: "assets/icons/terms.png",
                    actionName: "Privacy policy",
                    style: globalTextStyle(),
                    voidCallback: () {
                      Get.to(() => PrivacyPolicyScreen());
                    },
                    iconData: (Icons.arrow_forward_ios),
                    size: 18,
                  ),
                  const SizedBox(height: 21),
                  ProfileActionWidgets(
                    image: "assets/icons/logout.png",
                    actionName: "Log out",
                    style: globalTextStyle(),
                    voidCallback: () {
                      profileController.logoutDriver();
                    },
                    iconData: (Icons.arrow_forward_ios),
                    size: 18,
                  ),
                  const SizedBox(height: 21),
                  ProfileActionWidgets(
                    image: "assets/icons/delete.png",
                    actionName: "Account Delete",
                    style: globalTextStyle(),
                    voidCallback: () async {
                      Get.defaultDialog(
                        title: "Confirm Delete",
                        middleText:
                            "Are you sure you want to delete your account?",
                        textCancel: "No",
                        textConfirm: "Yes",
                        confirmTextColor: Colors.white,
                        buttonColor: Colors.red,
                        cancelTextColor: Colors.black,
                        barrierDismissible: false,
                        onConfirm: () async {
                          Get.back(); // Close dialog first
                          final id = await SharedPreferencesHelper.getUserId();
                          if (id == null) {
                            Get.snackbar("Error", "User ID not found");
                            return;
                          }

                          bool isSuccess = await deleteApiController
                              .deleteApiMethod(id);
                          if (isSuccess) {
                            await SharedPreferencesHelper.dataClear();
                            Get.offAll(() => RegisterScreen());
                            Get.snackbar(
                              "Success",
                              "Your account has been deleted",
                            );
                          } else {
                            Get.snackbar("Error", "Something went wrong");
                          }
                        },
                        onCancel: () {
                          Get.back(); // Close dialog when user presses "No"
                        },
                      );
                    },
                    iconData: Icons.arrow_forward_ios,
                    size: 18,
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
