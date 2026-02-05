import 'package:get/get.dart';
import '../feature/auth/onboarding/view/onboarding.dart';
import '../feature/auth/register/screen/register_screen.dart';
import '../feature/bottom_navbar/screen/bottom_nav_user.dart';
import '../feature/location/view/location_screen.dart';
import '../feature/profile/screen/profile_edit_screen.dart';
import '../feature/signup/view/signup_screen.dart';
import '../feature/splash_screen/screen/splash_screen.dart';

class AppRoute {
  static String splashScreen = '/splashScreen';
  static String registerScreen = "/registerScreen";
  static String onboardingScreen = "/onboardingScreen";
  static String locationScreen = "/locationScreen";
  static String bottomNavbarUser = "/bottomNavbarUser";
  static String signUpScreen = "/signUpScreen";
  static String profileEditScreen = "/profileEditScreen";

  static String getSplashScreen() => splashScreen;
  static String getOnboardingScreen() => onboardingScreen;
  static String getRegisterScreen() => registerScreen;
  static String getLocationScreen() => locationScreen;
  static String getBottomNavbarUser() => bottomNavbarUser;
  static String getSignUpScreen() => signUpScreen;
  static String getProfileEditScreen() => profileEditScreen;

  static List<GetPage> routes = [
    GetPage(name: splashScreen, page: () => SplashScreen()),
    GetPage(name: onboardingScreen, page: () => OnboardingScreen()),
    GetPage(name: registerScreen, page: () => RegisterScreen()),
    GetPage(name: locationScreen, page: () => LocationScreen()),
    GetPage(name: bottomNavbarUser, page: () => BottomNavbarUser()),
    GetPage(name: signUpScreen, page: () => SignUpScreen()),
    GetPage(name: profileEditScreen, page: () => ProfileEditScreen()),
  ];
}
