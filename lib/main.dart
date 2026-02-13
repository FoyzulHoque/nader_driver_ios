import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:nader_driver/in_app_notification.dart'
    show InAppNotificationController;
import 'package:nader_driver/route/route.dart';
import 'feature/chat/controller/chat_controller.dart';
import 'feature/home/controller/driver_confirmation_controller.dart';
import 'feature/home/controller/online_ride_controller.dart';
import 'feature/home/controller/rider_info_api_controller.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  configEasyLoading();

  // Initialize controllers
  Get.put(InAppNotificationController());
  Get.put(OnlineRideController());
  Get.put(RiderInfoApiController());
  Get.put(DriverConfirmationController());
  Get.put(ChatController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: 'Brothers Taxi Driver',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          ),
          getPages: AppRoute.routes,
          initialRoute: AppRoute.splashScreen,
          builder: EasyLoading.init(),
          home: child,
        );
      },
      child: const SizedBox.shrink(),
    );
  }
}

void configEasyLoading() {
  EasyLoading.instance
    ..loadingStyle = EasyLoadingStyle.custom
    ..backgroundColor = Colors.grey
    ..textColor = Colors.white
    ..indicatorColor = Colors.white
    ..maskColor = Colors.green
    ..userInteractions = false
    ..dismissOnTap = false;
}
