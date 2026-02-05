import 'package:get/get.dart';

class PrivacyPolicyController extends GetxController {
  // Title of the screen
  final title = "Privacy policy".obs;

  // Privacy policy text (could also be loaded from API or local JSON later)
  final policyText = """
 PRIVACY POLICY – BROTHERS TAXI (DRIVER APP)
Effective Date: 26-08-2025
Last Updated: 26-08-2025

1. Introduction
This Privacy Policy explains how information is collected and used when operating the Brothers Taxi Driver App.
By using the Driver App, you agree to this Privacy Policy.

2. Information We Collect
a. Driver Identification Information
Full name
Phone number
Vehicle details (plate number, vehicle type)
Collected to authenticate drivers and assign rides.
b. Location Information
Continuous location access while the app is active
Used to:
Match drivers with nearby riders
Track active trips
Optimize navigation & pickup accuracy
Location data is collected only during active driver status and is not used outside ride fulfillment.
c. App & Performance Data
Ride history
App usage logs
Device information
Used to improve app reliability and safety.

3. Payments
Drivers receive cash payments directly from riders
The Driver App:
Does not collect banking details
Does not process digital payments

4. How Driver Data Is Used
Ride assignment
Navigation and status updates
Customer support and dispute resolution
Operational safety and service quality

5. Data Sharing
Driver data is:
Shared with riders only when required (name + vehicle information)
Never sold to third parties
Disclosed only if required by law

6. Data Retention
Driver data is retained only while the account is active or legally required.

7. Security
We implement technical safeguards to protect driver identity and location data.

8. Driver Rights
Drivers may:
Request access or deletion of personal data
Disable location access when not working
Request account deactivation

9. Children’s Privacy
The Driver App is strictly for licensed adult drivers (18+).

10. Contact
 Email: aboulhosnanwar910@gmail.com
 Phone: +961 71817191
""".obs;
}
