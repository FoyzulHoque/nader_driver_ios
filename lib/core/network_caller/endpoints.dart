class NetworkPath {
  static const String _baseUrl = 'http://72.61.163.212:5006/api/v1';
  static const String ws = 'ws://72.61.163.212:5006';
  static const String registration = '$_baseUrl/users/create-user/register';
  static const String verifyLogin = '$_baseUrl/auth/verify-login';
  static const String resendOtp = '$_baseUrl/auth/resend-otp';
  static const String getDriverProfile = '$_baseUrl/users/get-me';
  static const String updateDriverOnboarding = '$_baseUrl/users/driver/onboarding';
  static const String updateDriverProfile = '$_baseUrl/users/update-profile';
  static const String updateDriverLinses = '$_baseUrl/users/upload-license';
  static const String logout = '$_baseUrl/auth/logout';
  static const String vehicleSignup = '$_baseUrl/vehicle/create';
  static const String myRides = "$_baseUrl/carTransports/my-rides";
  static const String myRidesHistory = "$_baseUrl/carTransports/my-rides-history";
  static const String driverIncome = "$_baseUrl/carTransports/driver-income";
  static const String myReviews = "$_baseUrl/reviews/my-reviews";
  static const String uploadDriverLicense = "$_baseUrl/users/upload-license";
  static const String offlineRideHistory = "$_baseUrl/carTransports/my-rides";
  static const String onlineRidersList = "$_baseUrl/carTransports/my-rides-pending";
  static const String onboarding = "$_baseUrl/users/onboarding";
  static const String createReview = "$_baseUrl/reviews/create";
  static  String carTransportsSingle(String id)=>"$_baseUrl/carTransports/single/$id";
  static  String usersDeleteAccount(String id)=>"$_baseUrl/users/delete-account/$id";



}

class Urls {
  // static const String baseUrl = 'https://yahya-backend.vercel.app/api/v1';
  static const String baseUrl = 'http://72.61.163.212:5006/api/v1';
  static const String googleApiKey = 'AIzaSyATkpZxtsIVek6xHnGRsse_i4yVEofqQbI';
  // Stripe keys have been moved to lib/core/const/stripe_keys.dart
  // Old commented keys removed for security
}
