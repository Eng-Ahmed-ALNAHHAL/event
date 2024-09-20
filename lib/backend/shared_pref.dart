import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static SharedPreferences? save;

  static init() async {
    save = await SharedPreferences.getInstance();

  }

  static Future<bool?> setBoolData(String key, bool value) async {
    return await save?.setBool(key, value);
  }

  static bool? getBoolData(String key) {
    return save?.getBool(key);
  }

  static Future<bool?> setStringData(String key, String value) async {
    return await save?.setString(key, value);
  }

  static String? getStringData(String key) {
    return save?.getString(key);
  }
}