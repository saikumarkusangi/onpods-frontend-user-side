import 'package:shared_preferences/shared_preferences.dart';

class UserSession {
  static Future<void> initialize() async {
    await SharedPreferences.getInstance();
  }

  static Future<void> setUserId(String userId) async {
    print('@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
    print(userId);
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    print('##################################' + userId);
    await _prefs.setString('user_id', userId);
  }

  static Future<String?> getUserId() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    
    return _prefs.getString('user_id');
  }
}
