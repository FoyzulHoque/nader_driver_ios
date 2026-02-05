import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

import '../../../../core/global_widegts/appBar.dart';
import '../../../../core/global_widegts/custom_button.dart';
import '../../../../core/style/global_text_style.dart';
import '../controller/register_otp_controller.dart';


class RegisterOtpVerify extends StatefulWidget {
  final String driverPhoneNo;
  RegisterOtpVerify({super.key, required this.driverPhoneNo});
  @override
  _ForgetPassOtpVerifyState createState() => _ForgetPassOtpVerifyState();
}

class _ForgetPassOtpVerifyState extends State<RegisterOtpVerify> {
  final RegisterOtpControllers registerOtpControllers = Get.put(
    RegisterOtpControllers(),
  );
  Timer? _timer;
  int _secondsRemaining = 120;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _secondsRemaining = 120;
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$minutes:$secs";
  }

  @override
  void dispose() {
    _timer?.cancel();
    registerOtpControllers.otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40),
              CustomAppBar(
                title: "",
                onLeadingTap: () {
                  Navigator.pop(context);
                },
              ),
              SizedBox(height: 20),
              Text(
                "Verification",
                style: globalTextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                "Hay, We had send you code number by",
                style: globalTextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
              Text(
                "${widget.driverPhoneNo}",
                style: globalTextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 40),

              // OTP PIN input
              Align(
                alignment: Alignment.center,
                child: Pinput(
                  length: 4,
                  controller: registerOtpControllers.otpController,
                  defaultPinTheme: PinTheme(
                    width: 50,
                    height: 60,
                    textStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.grey,
                      ), // 👉 grey initially
                    ),
                  ),
                  focusedPinTheme: PinTheme(
                    width: 50,
                    height: 60,
                    textStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.amber,
                        width: 2,
                      ), // 👉 green when focused
                    ),
                  ),
                  onCompleted: (pin) {
                    int otp =
                        int.tryParse(
                          registerOtpControllers.otpController.text,
                        ) ??
                        0;
                    registerOtpControllers.verifyLogin(
                      phoneNumber: widget.driverPhoneNo,
                      otp: otp,
                    );
                  },
                ),
              ),
              SizedBox(height: 15),

              Obx(
                () => registerOtpControllers.otpError.value
                    ? Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xFfFEEFEF),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.info, color: Colors.red),
                            SizedBox(width: 10),
                            Text(
                              registerOtpControllers.otpErrorText.value,
                              style: globalTextStyle(
                                color: Colors.red,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    : Container(),
              ),

              SizedBox(height: 10),

              // Countdown timer
              Align(
                alignment: Alignment.center,
                child: Text(
                  _secondsRemaining > 0
                      ? _formatTime(_secondsRemaining)
                      : "00.00",
                  style: TextStyle(color: Colors.amber),
                ),
              ),
              SizedBox(height: 20),
              CustomButton(
                title: "Resend OTP",
                backgroundColor: Color(0xFFFFDC71),
                borderColor: Colors.transparent,
                onPress: () {
                  if (registerOtpControllers.otpController.text.isEmpty) {
                    registerOtpControllers.otpErrorText.value =
                        "Otp filled empty";
                    registerOtpControllers.otpError.value = true;
                    Get.snackbar("Otp empty", "Please enter otp code!");
                  } else if (registerOtpControllers.otpController.length < 4) {
                    registerOtpControllers.otpErrorText.value =
                        "Otp filled incomplete";
                    registerOtpControllers.otpError.value = true;
                    Get.snackbar("Incomplete", "Please enter otp code!");
                  } else {
                    registerOtpControllers.otpError.value = false;
                    int otp =
                        int.tryParse(
                          registerOtpControllers.otpController.text,
                        ) ??
                        0;
                    registerOtpControllers.verifyLogin(
                      phoneNumber: widget.driverPhoneNo,
                      otp: otp,
                    );
                  }
                },
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  _startTimer();
                  registerOtpControllers.resendOtp(widget.driverPhoneNo);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Didn’t receive a code?",
                      style: globalTextStyle(
                        fontSize: 14,
                        color: Color(0xFF4D5154),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Resend Code",
                      style: globalTextStyle(
                        fontSize: 14,
                        color: Colors.amber,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
