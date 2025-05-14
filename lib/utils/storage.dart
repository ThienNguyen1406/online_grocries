import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static Future<String?> getDeviceToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("device_token");
  }

  static Future<void> setDeviceToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("device_token", token);
  }
}
