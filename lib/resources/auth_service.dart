import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:onpods/providers/auth_provider.dart';
import 'package:onpods/screens/Layout.dart';
import 'package:onpods/screens/screens_exports.dart';
import 'package:onpods/utils/utils_exports.dart';

class AuthService {
  final AuthProvider authProvider;

  AuthService(this.authProvider);

  // --------------------------------- Login--------------------------------------------------

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/signin'),
        body: {
          'user_email': email,
          'user_password': password,
        },
      ).timeout(const Duration(seconds: 30));
      if (response.statusCode == 200) {
        final Map<String, dynamic> userData = json.decode(response.body);
        authProvider.storeUserData(userData);
        showSnackbar('Successful', 'You are logged in!');
        Get.offAll(const Layout(), transition: Transition.leftToRight);
        return userData;
      } else {
        final Map<String, dynamic> error = json.decode(response.body);
        showSnackbar('Something Went Wrong', error['message']);
        throw Exception('Login failed with status code: ${error['message']}');
      }
    } catch (e) {
      if (e is TimeoutException) {
        showSnackbar('Timeout', 'Server is too busy.Please come back again');
      } else if (e
          .toString()
          .contains('ClientException with SocketException')) {
        showSnackbar(
            'Network Connection Error', 'Check your Internet Connection!!!');
      } else {
        // Handle other exceptions
        showSnackbar('Error', 'An error occurred: $e');
      }
      throw Exception('Error: $e');
    }
  }

// ---------------------------------- Signup----------------------------------------

  Future<Map<String, dynamic>> signup(
      String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/signup'),
        body: {
          'user_name': name,
          'user_email': email,
          'user_password': password,
        },
      ).timeout(const Duration(seconds: 30));
      if (response.statusCode == 200) {
        final Map<String, dynamic> userData = json.decode(response.body);
        authProvider.storeUserData(userData);
        showSnackbar('Successful', 'Account Created Successfully!');
        Get.offAll(const ChooseYourInterestScreen(),
            transition: Transition.leftToRight);
        return userData;
      } else {
        final Map<String, dynamic> error = json.decode(response.body);
        showSnackbar('Something Went Wrong', error['message']);
        throw Exception('Signup failed with status code: ${error['message']}');
      }
    } catch (e) {
      if (e is TimeoutException) {
        showSnackbar('Timeout', 'Server is too busy.Please come back again');
      } else if (e
          .toString()
          .contains('ClientException with SocketException')) {
        showSnackbar(
            'Network Connection Error', 'Check your Internet Connection!!!');
      } else {
        // Handle other exceptions
        showSnackbar('Error', 'An error occurred: $e');
      }
      throw Exception('Error: $e');
    }
  }
}
