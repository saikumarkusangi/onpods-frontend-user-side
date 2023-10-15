import 'package:shared_preferences/shared_preferences.dart';

class UserSession {
  static SharedPreferences? _prefs;

  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> setUserId(String userId) async {
    await _prefs!.setString('user_id', userId);
  }

  static String? getUserId() {
    return _prefs!.getString('user_id');
  }
}