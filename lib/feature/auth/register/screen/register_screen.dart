import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:nader_driver/feature/auth/register/screen/register_otp_verify.dart';

import '../../../../core/global_widegts/custom_button.dart';
import '../../../../core/style/global_text_style.dart';
import '../controller/driver_text_editing_controller.dart';
import '../controller/google_signin_controller.dart';
import '../controller/register_controller.dart';
import '../widget/backgroundimage.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final RegisterController controller = Get.put(RegisterController());
  final DriverTextEditingController adminTextEditingController = Get.put(
    DriverTextEditingController(),
  );
  final GoogleSignInController googleSignInController = Get.put(
    GoogleSignInController(),
  );

  @override
  void dispose() {
    adminTextEditingController.phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AuthBackgroundImage(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 80),
              SizedBox(
                child: Text(
                  "Enter your phone \nnumber",
                  style: globalTextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                    lineHeight: 1.5,
                    color: const Color(0xFF041020),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              /// Phone input with country picker
              Container(
                height: 55,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F4),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: SizedBox(
                        child: CountryCodePicker(
                          onChanged: (code) {
                            if (code.dialCode != null) {
                              adminTextEditingController.countryCode.text =
                                  code.dialCode!;
                              adminTextEditingController.selectedCountryCode =
                                  code;
                            }
                          },
                          initialSelection: 'LB',
                          favorite: const ['+961', 'LB'],
                          showCountryOnly: false,
                          showOnlyCountryWhenClosed: false,
                          alignLeft: false,
                          showDropDownButton: true,
                          showFlag: true,
                          showFlagMain: true,
                          flagWidth: 24,
                          textStyle: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                          searchDecoration: InputDecoration(
                            hintText: 'Search country',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                          dialogTextStyle: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          dialogBackgroundColor: Colors.white,
                          dialogSize: Size(
                            MediaQuery.of(context).size.width * 0.9,
                            MediaQuery.of(context).size.height * 0.7,
                          ),
                          showFlagDialog: true,
                          flagDecoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 2,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: TextFormField(
                          controller: adminTextEditingController.phone,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: "Enter phone number",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// Continue button
              CustomButton(
                title: "Continue",
                onPress: _loginApiHitButton,
                backgroundColor: const Color(0xFFFFDC71),
              ),

              const SizedBox(height: 20),

              /// Or separator
              // Align(
              //   alignment: Alignment.center,
              //   child: SizedBox(
              //     height: 24,
              //     width: 327,
              //     child: Row(
              //       children: [
              //         Container(
              //           height: 1,
              //           width: 144,
              //           decoration: const BoxDecoration(
              //             color: Color(0xFFEDEDF3),
              //           ),
              //         ),
              //         const SizedBox(width: 5),
              //         Text(
              //           "Or",
              //           style: globalTextStyle(
              //             fontSize: 14,
              //             color: const Color(0xFF8697AC),
              //           ),
              //         ),
              //         const SizedBox(width: 5),
              //         Container(
              //           height: 1,
              //           width: 144,
              //           decoration: const BoxDecoration(
              //             color: Color(0xFFEDEDF3),
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),

              // const SizedBox(height: 20),

              /// Google button
              /* GestureDetector(
                onTap: () {
                  googleSignInController.signInWithGoogle();
                },
                child: Container(
                  height: 56,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFFEDEDF3),
                      width: 2,
                    ),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SizedBox(
                          height: 24,
                          width: 24,
                          child: Image.asset("assets/images/google.png"),
                        ),
                      ),
                      const SizedBox(width: 25),
                      Center(
                        child: Text(
                          "Continue with Google",
                          style: globalTextStyle(
                            fontSize: 16,
                            color: const Color(0xFF041020),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),*/
            ],
          ),
        ),
      ),
    );
  }

  void _loginApiHitButton() async {
    bool isSuccess = await controller.registerUser(
      phoneNumber: adminTextEditingController.countryCodeAndPhone,
      role: "DRIVER",
    );
    if (isSuccess) {
      Get.to(
        () => RegisterOtpVerify(
          driverPhoneNo: adminTextEditingController.countryCodeAndPhone,
        ),
      );
    }
  }
}
