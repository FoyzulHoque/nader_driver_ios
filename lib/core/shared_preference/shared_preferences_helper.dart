import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static const String _accessTokenKey = 'token';
  static const String _selectedRoleKey = 'selectedRole';
  static const String _categoriesKey = "categories";
  static const String _isWelcomeDialogShownKey =
      'isDriverVerificationDialogShown';
  static const String _accessPhoneNo = 'phone_no';
  static const String _userIdKey = 'userId';
  static const String _userRole = 'role';
  static const String _showOnboardKey = 'showOnboard';
  static const String _isExistKey = 'isExist'; // ✅ Added this key

  // 🔹 Save isExist flag
  static Future<void> saveIsExist(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isExistKey, value);
  }

  // 🔹 Retrieve isExist flag
  static Future<bool> getIsExist() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isExistKey) ?? false;
  }

  // Existing methods...
  static Future<void> saveToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, token);
    await prefs.setBool('isLogin', true);
  }

  static Future<String?> getAccessToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey);
  }

  static Future<void> saveUserId(String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userIdKey, id);
  }

  static Future<void> saveSelectedRole(String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userRole, role);
  }

  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }

  static Future<void> clearAllData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_selectedRoleKey);
    await prefs.remove('isLogin');
    await prefs.remove(_accessPhoneNo);
    await prefs.remove(_isExistKey);
    await prefs.remove(_userIdKey); // ✅ clear also
  }

  static Future<String?> getSelectedRole(String role) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_selectedRoleKey);
  }

  static Future<bool?> checkLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool("isLogin") ?? false;
  }

  static Future<void> setWelcomeDialogShown(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isWelcomeDialogShownKey, value);
  }

  static Future<bool> isWelcomeDialogShown() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isWelcomeDialogShownKey) ?? false;
  }

  static Future<void> setShowOnboard(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_showOnboardKey, value);
  }

  static Future<bool> getShowOnboard() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_showOnboardKey) ?? false;
  }

  static Future<void> savePhoneNo(String phoneNo) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessPhoneNo, phoneNo);
  }

  static Future<String?> getPhoneNo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessPhoneNo);
  }

  static Future<void> dataClear() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
