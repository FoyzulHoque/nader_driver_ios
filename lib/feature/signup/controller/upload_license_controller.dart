// import 'dart:io';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import '../../../core/network_caller/endpoints.dart';
// import '../../../core/network_caller/network_config.dart';
// import '../model/driving_license_model.dart';

// class UploadLicenseController extends GetxController {
//   var isLoading = false.obs;
//   var images = <File>[].obs;
//   var driverLicense = Rxn<LicenseModel>();

//   /// Add image from gallery
//   Future<void> addImage() async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);

//     if (pickedFile != null) {
//       images.add(File(pickedFile.path));
//     }
//   }

//   /// Remove image
//   void removeImage(int index) {
//     if (index >= 0 && index < images.length) {
//       images.removeAt(index);
//     }
//   }

//   /// Upload license API call
//   Future<void> uploadLicense() async {
//     if (images.length < 2) {
//       EasyLoading.showError("Please select both front & back license images");
//       return;
//     }

//     isLoading.value = true;
//     EasyLoading.show(status: "Uploading...");

//     try {
//       Map<String, dynamic> data = {
//         "licenseFrontSide": images[0].path,
//         "licenseBackSide": images[1].path,
//       };

//       NetworkResponse response = await NetworkCall.multipartRequestForData(
//         url: NetworkPath.uploadDriverLicense,
//         profileData: data,
//         methodType: "PATCH",
//       );

//       if (response.isSuccess) {
//         var responseData = response.responseData!["data"];
//         driverLicense.value = LicenseModel.fromJson(responseData);
//         EasyLoading.showSuccess("License uploaded successfully");
//       } else {
//         EasyLoading.showError(response.errorMessage ?? "Failed to upload license");
//       }
//     } catch (e) {
//       EasyLoading.showError("Error: $e");
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }
