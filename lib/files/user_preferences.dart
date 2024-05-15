import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static SharedPreferences? _preferences;

  static const _keyIsLoggedIn = 'isLoggedIn';

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setLoggedIn(bool isLoggedIn) async =>
      await _preferences?.setBool(_keyIsLoggedIn, isLoggedIn);

  static bool isLoggedIn() => _preferences?.getBool(_keyIsLoggedIn) ?? false;
}
