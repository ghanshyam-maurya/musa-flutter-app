import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  static late SharedPreferences _prefs;

  // call this method from iniState() function of mainApp().
  static Future<SharedPreferences> init() async {
    _prefs = await SharedPreferences.getInstance();
    return _prefs;
  }

  //sets
  static Future<bool> setBool(String key, bool value) async =>
      await _prefs.setBool(key, value);

  static Future<bool> setDouble(String key, double value) async =>
      await _prefs.setDouble(key, value);

  static Future<bool> setInt(String key, int value) async =>
      await _prefs.setInt(key, value);

  static Future<bool> setString(String key, String value) async =>
      await _prefs.setString(key, value);

  static Future<bool> setStringList(String key, List<String> value) async =>
      await _prefs.setStringList(key, value);

  //gets
  static bool? getBool(String key) => _prefs.getBool(key);

  static double? getDouble(String key) => _prefs.getDouble(key);

  static int? getInt(String key) => _prefs.getInt(key);

  static String? getString(String key) => _prefs.getString(key);

  static List<String>? getStringList(String key) => _prefs.getStringList(key);

  //deletes..
  static Future<bool> remove(String key) async => await _prefs.remove(key);

  static Future<bool> clear() async => await _prefs.clear();
}

abstract class PrefKeys {
  static const String token = 'token';
  static const String otp = 'otp';
  static const String tempPassword = 'password';
  static const String email = 'Email';
  static const String tempEmail = 'email';
  static const String userId = 'id';
  static const String uId = 'userId';
  static const String userData = 'user_data';
  static const String fcmToken = 'fcm_token';
  static const String lastPage = 'pageIndex';
  static const String about = 'bio';
  static const String recoding = 'recoding';
  static const String userName = 'user_name';
  static const String firstName = 'first_name';
  static const String lastName = 'last_name';
  static const String deviceId = 'device_id';
  static const String userType = 'user_type';
  static const String deviceType = 'device_type';
}
