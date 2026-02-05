import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';

import '../../../core/network_caller/endpoints.dart';
import '../../../core/network_caller/network_config.dart';
import '../../../core/shared_preference/shared_preferences_helper.dart';
import '../../auth/register/screen/register_screen.dart';
import '../model/driver_profile.dart';

class ProfileController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController imageController = TextEditingController();

  // Observable profile data
  var driverProfile = Rxn<DriverProfile>();
  var profileImage = <File>[].obs;
  var drivingLicenseFrontImage = <File>[].obs;
  var drivingLicenseBackImage = <File>[].obs;

  // Store existing license image URLs
  String? existingLicenseFrontUrl;
  String? existingLicenseBackUrl;
  // / Profile image from gallery
  Future<void> addProfileImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      profileImage.add(File(pickedFile.path));
    }
  }

  /// Remove image
  void removeProfileImage(int index) {
    if (index >= 0 && index < profileImage.length) {
      profileImage.removeAt(index);
    }
  }

  // Driving License Front Image
  Future<void> addDrivingLicenseFrontImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      drivingLicenseFrontImage.clear();
      drivingLicenseFrontImage.add(File(pickedFile.path));
    }
  }

  void removeDrivingLicenseFrontImage() {
    drivingLicenseFrontImage.clear();
  }

  // Driving License Back Image
  Future<void> addDrivingLicenseBackImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      drivingLicenseBackImage.clear();
      drivingLicenseBackImage.add(File(pickedFile.path));
    }
  }

  void removeDrivingLicenseBackImage() {
    drivingLicenseBackImage.clear();
  }

  // Check if license images exist (either local files or existing URLs)
  bool get hasLicenseFrontImage =>
      drivingLicenseFrontImage.isNotEmpty ||
      (existingLicenseFrontUrl != null && existingLicenseFrontUrl!.isNotEmpty);

  bool get hasLicenseBackImage =>
      drivingLicenseBackImage.isNotEmpty ||
      (existingLicenseBackUrl != null && existingLicenseBackUrl!.isNotEmpty);

  Future<void> fetchDriverProfile() async {
    try {
      NetworkResponse response = await NetworkCall.getRequest(
        url: NetworkPath.getDriverProfile,
      );
      if (response.isSuccess) {
        final responseData = response.responseData!["data"];
        driverProfile.value = DriverProfile.fromJson(responseData);

        // Store existing license image URLs
        existingLicenseFrontUrl = driverProfile.value?.licenseFrontSide;
        existingLicenseBackUrl = driverProfile.value?.licenseBackSide;
      } else {
        EasyLoading.showError(
          response.errorMessage ?? "Failed to retrieve profile",
        );
      }
    } catch (e) {
      EasyLoading.showError("Error: $e");
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> logoutDriver() async {
    try {
      EasyLoading.show(status: "Please wait...");
      NetworkResponse response = await NetworkCall.postRequest(
        url: NetworkPath.logout,
      );
      if (response.isSuccess) {
        final responseData = response.responseData!["data"];
        EasyLoading.showSuccess("Logout successful");
        // Optionally clear token from SharedPreferences
        await SharedPreferencesHelper.clearAllData();
        Get.offAll((RegisterScreen()));
      } else {
        EasyLoading.showError(
          response.errorMessage ?? "Failed to retrieve profile",
        );
      }
    } catch (e) {
      EasyLoading.showError("Error: $e");
    } finally {
      EasyLoading.dismiss();
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchDriverProfile();
  }

  // Clear user profile (e.g. on logout)
  void clearProfile() {
    driverProfile.value = null;
  }

  Future<void> updateProfile() async {
    EasyLoading.show(status: "Updating...");

    try {
      String fullName = nameController.text.trim();
      String email = emailController.text.trim();
      String address = cityController.text.trim();

      if (fullName.isEmpty) {
        EasyLoading.showError("Name is required");
        return;
      }

      Map<String, dynamic> profileData = {
        "fullName": fullName,
        "email": email,
        "address": address,
      };

      // Multipart form data
      var formData = {
        "data": jsonEncode(profileData),
        if (profileImage.isNotEmpty)
          "image": profileImage[0], // profile picture
      };

      NetworkResponse response = await NetworkCall.multipartRequestForData(
        url: NetworkPath.updateDriverProfile,
        formData: formData,
        methodType: "PATCH",
      );

      if (response.isSuccess) {
        // License update করো (যদি image change হয়)
        await updateLicence();
        // Refresh profile
        await fetchDriverProfile();
        EasyLoading.showSuccess("Profile updated successfully");
        Get.back(); // Optional: screen close
      } else {
        EasyLoading.showError(response.errorMessage ?? "Update failed");
      }
    } catch (e) {
      EasyLoading.showError("Error: $e");
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> updateLicence() async {
    // EasyLoading.show(status: "Updating...");

    try {
      Map<String, dynamic> formDataBody = {
        "licenseFrontSide": drivingLicenseFrontImage.isNotEmpty
            ? drivingLicenseFrontImage[0]
            : null,
        "licenseBackSide": drivingLicenseBackImage.isNotEmpty
            ? drivingLicenseBackImage[0]
            : null,
      };

      NetworkResponse response = await NetworkCall.multipartRequestForData(
        url: NetworkPath.updateDriverLinses,
        formData: formDataBody,
        methodType: "PATCH",
      );

      if (response.isSuccess) {
        fetchDriverProfile();
        EasyLoading.showSuccess("Profile update Successful");
      } else {
        Logger().e(response.errorMessage);
        EasyLoading.showError(
          "Failed to update profile ${response.errorMessage}",
        );
      }
    } catch (e) {
      EasyLoading.showError("Error: $e");
    }
  }
}
