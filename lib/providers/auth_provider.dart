import 'package:flutter/material.dart';
import 'package:onpods/models/user.dart';
import 'package:onpods/resources/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoading = false;
  UserModel? _user;
  AuthService? _authService;

  AuthProvider() {
    _authService = AuthService(this);
  }

  bool get isLoading => _isLoading;
  UserModel? get user => _user;

  // ---------------------------- Login -----------------------------------------

  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      final userData = await _authService!.login(email, password);
      storeUserData(userData);
    } catch (error) {
      throw Exception(error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

// ---------------------------- Store Data ------------------------------------------

  void storeUserData(Map<String, dynamic> userData) async {
    final user = UserModel.fromJson(userData);
    _user = user;
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isUserLoggedIn', true);
    prefs.setString('user_id', user.user.id);
    prefs.setString('user_name', user.user.userName);
    prefs.setString('user_profile_pic', user.user.userProfilePic);
    prefs.setString('user_downloads', user.user.userDownloads.join(','));
    notifyListeners();
  }

  // ---------------------------- Sign UP -----------------------------------------

  Future<void> signUp(String name,String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      final userData = await _authService!.signup(name,email, password);
      storeUserData(userData);
    } catch (error) {
      throw Exception(error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


// ---------------------------- Logout -----------------------------------------

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    _user = null;
    notifyListeners();
  }
}
