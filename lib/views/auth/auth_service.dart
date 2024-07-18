import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _isLoggedInKey = "isLoggedIn";

  static Future<void> setLoginStatus(bool isLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, isLoggedIn);
  }

  static Future<bool> getLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  static Future<void> logout() async {
    await setLoginStatus(false);
  }
}