import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/const/app_colors.dart';
import '../../../core/const/image_path.dart';
import '../controller/signup_controller.dart';
import '../widget/car_image_widget.dart';
import '../widget/custom_input_field.dart';
import '../widget/driving_license_widget.dart';
import '../widget/id_widget.dart';
import '../widget/insurance_widget.dart';
import '../widget/judicial_record_widget.dart';
import '../widget/signup_for_car_profile_image_widget.dart';

class SignUpScreen extends StatelessWidget {
  final double? latitude;
  final double? longitude;

  const SignUpScreen({super.key, this.latitude, this.longitude});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignUpController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.backgroundColor,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Image.asset(ImagePath.backIcon, width: 50, height: 50),
        ),
        title: const Text(
          "Sign Up for car",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Personal Information",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            SignupForCarProfileImageWidget(),
            const SizedBox(height: 24),

            // Fields
            CustomInputField(
              hintText: "Full Name (Same As ID / License)*",

              onChanged: (val) => controller.updateField("fullName", val),
            ),
            CustomInputField(
              hintText: "Address",
              onChanged: (val) => controller.updateField("address", val),
            ),

            const SizedBox(height: 16),
            NidCardWidget(),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: CustomInputField(
                hintText: "Gender",
                isDropdown: true,
                dropdownItems: ["Male", "Female", "Other"],
                onChanged: (val) => controller.updateField("gender", val),
              ),
            ),

            CustomInputField(
              hintText: "Date Of Birth",
              onChanged: (val) => controller.updateField("dateOfBirth", val),
            ),
            const SizedBox(height: 16),
            DrivingLicenseWidget(),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: JudicialRecordWidget(),
            ), // Judicial Record field
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: InsuranceWidget(),
            ),
            const SizedBox(height: 20),
            const Text(
              "Taxi Information",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 16),
            CarImageWidget(), //  New Added
            const SizedBox(height: 16),

            CustomInputField(
              hintText: " Car Manufacturer*",
              onChanged: (val) => controller.updateField("manufacturer", val),
            ),

            CustomInputField(
              hintText: "Model*",
              onChanged: (val) => controller.updateField("car_model", val),
            ),
            CustomInputField(
              hintText: " License Plate Number*",
              onChanged: (val) =>
                  controller.updateField("licensePlateNumber", val),
            ),

            const SizedBox(height: 20),

            // CarLicenseWidget(), //  New added
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  controller.submitForm();
                  // Get.to(() => const SuccessScreen());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow[600],
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),

                child: const Text(
                  "Agree & Signup",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
