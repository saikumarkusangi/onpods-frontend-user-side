import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:onpods/models/user.dart';
import 'package:onpods/resources/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  final _googleOauth = GoogleSignIn();
  bool _isLoading = false;
  AuthService? _authService;
  String userId = '';
  AuthProvider() {
    _authService = AuthService(this);
  }

  bool get isLoading => _isLoading;

  // ---------------------------- Login -----------------------------------------

  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      final userData = await _authService!.login(email, password);
      storeUserData(userData);
    } catch (error) {
      await _googleOauth.signOut();
      throw Exception(error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

// ---------------------------- Store Data ------------------------------------------

  void storeUserData(Map<String, dynamic> userData) async {
    final user = UserModel.fromJson(userData);
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isUserLoggedIn', true);
    prefs.setString('user_id', user.data.id);

    notifyListeners();
  }

  // ---------------------------- Sign UP -----------------------------------------

  Future<void> signUp(String name, String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      final userData = await _authService!.signup(name, email, password);

      storeUserData(userData);
    } catch (error) {
      await _googleOauth.signOut();
      throw Exception(error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ---------------------------- Forgot Password -----------------------------------------

  Future<Map<String, dynamic>> forgotPassword(String email) async {
    _isLoading = true;
    notifyListeners();
    try {
      final otp = await _authService!.forgotPassword(email);
      return otp;
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
    await _googleOauth.signOut();
    notifyListeners();
  }
}
