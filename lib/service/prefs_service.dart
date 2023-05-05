import 'package:shared_preferences/shared_preferences.dart';

class PrefsService {

  static String keyMode = "mode";

  static Future<void> storeMode(bool isDark)  async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setBool(keyMode, isDark);
  }

  static Future<bool?> loadMode() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool(keyMode);
  }

}