import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../../../core/network_caller/endpoints.dart';
import '../../../core/network_caller/network_config.dart';
import '../model/signup_model.dart';
import '../../success/view/success_screen.dart';

class SignUpController extends GetxController {
  final form = SignUpModel().obs;
  var selectedValue = "BH".obs;

  var profileImage = <File>[].obs;
  var idImages = <File>[].obs;
  var licenseImages = <File>[].obs;
  var judicialRecordImages = <File>[].obs;
  var insuranceImages = <File>[].obs;
  var carImages = <File>[].obs;





  final TextEditingController box1Controller = TextEditingController();
  final TextEditingController box2Controller = TextEditingController();
  final TextEditingController box3Controller = TextEditingController();
  final TextEditingController box4Controller = TextEditingController();


  void updateField(String key, String? value) {
    switch (key) {
      case "fullName":
        form.value.fullName = value;
        break;
      case "address":
        form.value.address = value;
        break;
      case "nidNumber":
        form.value.nidNumber = value;
        break;
      case "gender":
        form.value.gender = value;
        break;
      case "dateOfBirth":
        form.value.dateOfBirth = value;
        break;
      case "manufacturer":
        form.value.manufacturer = value;
        break;
      case "licensePlateNumber":
        form.value.licensePlateNumber = value;
        break;
      case "plateCode":
        form.value.plateCode = value;
        break;
      case "referralCode":
        form.value.referralCode = value;
        break;
      case "car_model":
        form.value.carModel = value;
        break;
      case "car_model":
        form.value.carModel = value;
        break;
    }
    form.refresh();
  }

  void updateSelectedValue(String value) {
    selectedValue.value = value;
  }

  Future<File> _saveImagePermanently(String imagePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = path.basename(imagePath);
    final image = File('${directory.path}/$name');
    return File(imagePath).copy(image.path);
  }

  Future<void> submitForm() async {
    final data = form.value;

    EasyLoading.show(status: "Updating...");

    try {
      String fullName = data.fullName ?? "";
      String dateOfBirth = data.dateOfBirth ?? "";
      String address = data.address ?? "";
      String nidNumber = data.nidNumber ?? "";
      String gender = data.gender ?? "";
      String licensePlateNumber = data.licensePlateNumber ?? "";


      // Default data (backend expects non-empty values)
      String manufacturer = data.manufacturer ?? "Unknown";
      String model = data.carModel ?? "Unknown";
      int year = 2023;
      String color = "Black";

      Map<String, dynamic> profileData = {
        "profile": {
          "fullName": fullName,
          "dob": dateOfBirth,
          "gender": gender.toUpperCase(),
          "address": address,
        },
        "vehicle": {
          "manufacturer": manufacturer,
          "model": model,
          "licensePlateNumber": licensePlateNumber,
        },
      };




      Map<String, dynamic> formDataBody = {
        "data": jsonEncode(profileData),
        "profileImage": profileImage.isNotEmpty ? profileImage[0] : null,
        "licenseFrontSide": licenseImages.isNotEmpty ? licenseImages[0] : null,
        "licenseBackSide": licenseImages.length > 1 ? licenseImages[1] : null,
        "vehicleImage": carImages.isNotEmpty ? carImages[0] : null,
        "idFrontImage": idImages.isNotEmpty ? idImages[0] : null,
        "idBackImage": idImages.length > 1 ? idImages[1] : null,
        "judicialRecord": judicialRecordImages.isNotEmpty ? judicialRecordImages : null,
        "compulsoryInsurance": insuranceImages.isNotEmpty ? insuranceImages : null,
      };


      NetworkResponse response = await NetworkCall.multipartRequestForData(
        url: NetworkPath.updateDriverOnboarding,
        formData: formDataBody,
        methodType: "POST",
      );

      if (response.isSuccess) {
        EasyLoading.showSuccess("Vehicle Signup Successful");
        Get.to(() => const SuccessScreen(msg: "sdfsdf",));
      } else {
        Logger().e(response.errorMessage);
        EasyLoading.showError( "Failed to update profile ${response.errorMessage}",
        );
      }
    } catch (e) {
      EasyLoading.showError("Error: $e");
    }
  }



// ===========profileImage sections start==========
  // / Profile image from gallery
  Future<void> addProfileImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final permanentImage = await _saveImagePermanently(pickedFile.path);
      profileImage.add(permanentImage);
    }
  }

  /// Remove image
  void removeProfileImage(int index) {
    if (index >= 0 && index < profileImage.length) {
      profileImage.removeAt(index);
    }
  }
// ===========profileImage sections end==========


  // ===========idImages sections start==========
  // / Add image from gallery
  Future<void> addIdImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final permanentImage = await _saveImagePermanently(pickedFile.path);
      idImages.add(permanentImage);
    }
  }

  /// Remove image
  void removeIdImage(int index) {
    if (index >= 0 && index < idImages.length) {
      idImages.removeAt(index);
    }
  }
// ===========idImages sections end==========




// ===========licenseImages sections start==========
  // / Add image from gallery
  Future<void> addLicenseImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final permanentImage = await _saveImagePermanently(pickedFile.path);
      licenseImages.add(permanentImage);
    }
  }

  /// Remove image
  void removeLicenseImage(int index) {
    if (index >= 0 && index < licenseImages.length) {
      licenseImages.removeAt(index);
    }
  }
  // ===========licenseImages sections end==========



  // ===========judicialRecordImages sections start==========
  // / Add image from gallery
  Future<void> addJudicialRecordIImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final permanentImage = await _saveImagePermanently(pickedFile.path);
      judicialRecordImages.add(permanentImage);
    }
  }

  /// Remove image
  void removeJudicialRecordIImage(int index) {
    if (index >= 0 && index < judicialRecordImages.length) {
      judicialRecordImages.removeAt(index);
    }
  }
  // ===========judicialRecordImages sections end==========


  // ===========insuranceImages sections start==========
  // / Add image from gallery
  Future<void> addInsuranceImages() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final permanentImage = await _saveImagePermanently(pickedFile.path);
      insuranceImages.add(permanentImage);
    }
  }

  /// Remove image
  void removeInsuranceImages(int index) {
    if (index >= 0 && index < insuranceImages.length) {
      insuranceImages.removeAt(index);
    }
  }
// ===========insuranceImages sections end==========



// ===========carImages sections start==========
  // / Add image from gallery
  Future<void> addCarImages() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final permanentImage = await _saveImagePermanently(pickedFile.path);
      carImages.add(permanentImage);
    }
  }

  /// Remove image
  void removeCarImages(int index) {
    if (index >= 0 && index < carImages.length) {
      carImages.removeAt(index);
    }
  }
// ===========carImages sections end==========





}
