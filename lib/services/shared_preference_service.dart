import 'package:shared_preferences/shared_preferences.dart';

class Preference {
  static SharedPreferences? _preferences;
  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  //login
  static Future<bool?> getLoginStatus() async => _preferences?.getBool("isLoggedIn");
  static void setLoginStatus(bool value) => _preferences!.setBool("isLoggedIn", value);

}