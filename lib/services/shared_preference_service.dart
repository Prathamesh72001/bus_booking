import 'package:shared_preferences/shared_preferences.dart';

class Preference {
  static SharedPreferences? _preferences;
  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  //login
  static Future<bool?> getLoginStatus() async => _preferences?.getBool("isLoggedIn");
  static void setLoginStatus(bool value) => _preferences!.setBool("isLoggedIn", value);

  //user
  static Future<String?> getUser() async => _preferences?.getString("user");
  static void setUser(String value) => _preferences!.setString("user", value);
}