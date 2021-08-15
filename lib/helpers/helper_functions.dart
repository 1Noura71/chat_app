import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {
  static String prefsUserLoggedInKey = 'ISLOGGEDIN';
  static String prefsUserNameKey = 'USERNAMEKEY';
  static String prefsUserEmailKey = 'USEREMAILKEY';

  // saving data to sharedPreferences

  static Future<bool> saveUserLoggedIn(bool isLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(prefsUserLoggedInKey, isLoggedIn);
  }

  static Future<bool> saveUserName(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(prefsUserNameKey, username);
  }

  static Future<bool> saveUserEmail(email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(prefsUserEmailKey, email);
  }

  // gitting data from sharedPreferences
  static Future<bool?> getUserLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(prefsUserLoggedInKey);
  }

  static Future getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(prefsUserNameKey);
  }

  static Future<String?> getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(prefsUserEmailKey);
  }
}
