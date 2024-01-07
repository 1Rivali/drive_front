import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static SharedPreferences? sharedPreferences;

  static init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static setString({required String key, required String value}) async {
    await sharedPreferences?.setString(key, value);
  }

  static getData({required String key}) {
    return sharedPreferences?.get(key);
  }

  static removeData() {
    sharedPreferences?.clear();
  }
}
