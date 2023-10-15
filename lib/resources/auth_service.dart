
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:onpods/utils/exports.dart';



class AuthService {
  final AuthProvider authProvider;

  AuthService(this.authProvider);

  // --------------------------------- Login--------------------------------------------------

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        body: {
          'email': email,
          'password': password,
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

        throw error['message'];
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
        showSnackbar('Something Went Wrong', e);
      }
      throw Exception('Error: $e');
    }
  }

// ---------------------------------- Signup----------------------------------------

  Future<Map<String, dynamic>> signup(
      String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        body: {
          'username': name,
          'email': email,
          'password': password,
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
        throw error['message'];
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
        showSnackbar('Something Went Wrong', e);
      }
      throw Exception('Error: $e');
    }
  }




  // --------------------------------- Forgot Password --------------------------------------------------

  Future<Map<String, dynamic>> forgotPassword(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/forgot-password'),
        body: {
          'email': email,
        },
      ).timeout(const Duration(seconds: 30));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['status'] == 'fail') {
          showSnackbar(
              'Something went wrong', '${data['message']} with this mail id.');
        } else {
          showSnackbar('OTP Sent', 'Check your email for otp!');
          Get.to(
              OtpVerifyScreen(
                otp: data['otp'].toString(),
              ),
              transition: Transition.rightToLeft);
        }
        return data;
      } else {
        final Map<String, dynamic> error = json.decode(response.body);

        throw error['message'];
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
        showSnackbar('Something Went Wrong', e);
      }
      throw Exception('Error: $e');
    }
  }

  // --------------------------------- resetPassword--------------------------------------------------

  Future<Map<String, dynamic>> resetPassword(
      String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/reset-password'),
        body: {
          'email': email,
          'password': password,
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

        throw error['message'];
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
        showSnackbar('Something Went Wrong', e);
      }
      throw Exception('Error: $e');
    }
  }
}
