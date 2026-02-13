import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InAppNotificationController extends GetxController {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void onInit() {
    super.onInit();
    getAndSaveFCMToken();
    _initializeLocalNotifications();
    requestPermissions();
    initPushNotification();
  }

  // Initialize local notifications
  void _initializeLocalNotifications() {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    DarwinInitializationSettings initializationSettingsIOS =
        const DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    _localNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        print("Notification clicked with payload: ${response.payload}");
      },
    );
  }

  // Request permission for iOS notifications
  void requestPermissions() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  // Show local notification when the app is in the foreground
  void _showLocalNotification({
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'channel_id',
          'channel_name',
          importance: Importance.high,
          priority: Priority.high,
        );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotificationsPlugin.show(0, title, body, notificationDetails);
  }

  // Get and save the FCM token to SharedPreferences
  Future<void> getAndSaveFCMToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    try {
      String? fcmToken = await _firebaseMessaging.getToken();

      if (fcmToken != null) {
        await preferences.setString('fcm_token', fcmToken);
        print("FCM Token: $fcmToken");
        initPushNotification();
      } else {
        print("Failed to get FCM token.");
      }
    } catch (e) {
      print("Error getting FCM token: $e");
    }
  }

  // Handle push notifications when the app is in the foreground
  Future<void> initPushNotification() async {
    // Handle notifications when the app is in the background or terminated
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Foreground notification received: ${message.notification?.title}");
      // Show local notification when the app is open
      _showLocalNotification(
        title: message.notification?.title ?? 'No Title',
        body: message.notification?.body ?? 'No Body',
      );
    });

    // Handle notifications when the app is opened from a background state
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Notification opened: ${message.notification?.title}");
    });

    // Handle when the app is completely terminated and opened via notification
    _firebaseMessaging.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        print("App opened via notification: ${message.notification?.title}");
      }
    });
  }

  // Optionally, you can set up background handling for iOS and Android
  Future<void> saveTokenForiOS() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    try {
      if (GetPlatform.isIOS) {
        await _firebaseMessaging.requestPermission(
          alert: true,
          badge: true,
          sound: true,
        );
        print('User granted permission for notifications');
        String? apnsToken = await _firebaseMessaging.getAPNSToken();
        print('APNs Token: $apnsToken');
        String? fcmToken = await _firebaseMessaging.getToken();
        if (fcmToken != null) {
          await preferences.setString('fcm_token', fcmToken);
          print("FCM Token for iOS: $fcmToken");
        } else {
          print("Failed to get FCM token on iOS.");
        }
        _firebaseMessaging.setForegroundNotificationPresentationOptions(
          alert: true,
          sound: true,
          badge: true,
        );
      } else {
        print("saveTokenForiOS function is being called on a non-iOS platform");
      }
    } catch (e) {
      print("Error in saveTokenForiOS: $e");
    }
  }

  // Optionally, implement the logic to handle notification response when the app is not running or in the background
  Future<String?> getSavedFCMToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('fcm_token');
  }
}
