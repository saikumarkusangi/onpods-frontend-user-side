import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:onpods/utils/exports.dart';

class AuthService {
  final AuthProvider authProvider;
  AuthService(this.authProvider);
 final context = BuildContext;
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

        return userData;
      } else {
        final Map<String, dynamic> error = json.decode(response.body);

        throw error['message'];
      }
    } catch (e) {
      
      if (e is TimeoutException) {
        showSnackbar('Timeout', 'Server is too busy.Please come back again',ContentType.failure,context);
      } else if (e
          .toString()
          .contains('ClientException with SocketException')) {
        showSnackbar(
            'Network Connection Error', 'Check your Internet Connection!!!',ContentType.failure,context);
      } else {
        // Handle other exceptions
        showSnackbar('Something Went Wrong', e,ContentType.failure,context);
      }
      throw Exception('Error: $e');
    }
  }

// --------------------------------- Login--------------------------------------------------

  Future<Map<String, dynamic>> oAuthlogin(String id) async {
    try {
      print(
          'calling oauth login @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ id');
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        body: {
          'oauth': id,
        },
      ).timeout(const Duration(seconds: 30));
      print(response);
      if (response.statusCode == 200) {
        final Map<String, dynamic> userData = json.decode(response.body);

        return userData;
      } else {
        final Map<String, dynamic> error = json.decode(response.body);

        throw error['message'];
      }
    } catch (e) {
      if (e is TimeoutException) {
        showSnackbar('Timeout', 'Server is too busy.Please come back again',ContentType.failure,context);
      } else if (e
          .toString()
          .contains('ClientException with SocketException')) {
        showSnackbar(
            'Network Connection Error', 'Check your Internet Connection!!!',ContentType.failure,context);
      } else {
        // Handle other exceptions
        showSnackbar('Something Went Wrong', e,ContentType.failure,context);
      }
      throw Exception('Error: $e');
    }
  }

// ---------------------------------- Signup----------------------------------------

  Future<Map<String, dynamic>> signup(
      String name, String email, String password) async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        body: {
          'username': name,
          'email': email,
          'password': password,
          'fcmToken': fcmToken
        },
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final Map<String, dynamic> userData = json.decode(response.body);

        return userData;
      } else {
        final Map<String, dynamic> error = json.decode(response.body);
        throw error['message'];
      }
    } catch (e) {
      if (e is TimeoutException) {
        showSnackbar('Timeout', 'Server is too busy.Please come back again',ContentType.failure,context);
      } else if (e
          .toString()
          .contains('ClientException with SocketException')) {
        showSnackbar(
            'Network Connection Error', 'Check your Internet Connection!!!',ContentType.failure,context);
      } else {
        // Handle other exceptions
        showSnackbar('Something Went Wrong', e,ContentType.failure,context);
      }
      throw Exception('Error: $e');
    }
  }

  // ---------------------------------- Signup----------------------------------------

  Future<Map<String, dynamic>> oAuthsignup(
      String name, String email, String id, String photoUrl) async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    try {
      print(
          'calling oauth signup @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        body: {
          'username': name,
          'email': email,
          'oauth': id,
          'profilePic': photoUrl,
          'fcmToken': fcmToken
        },
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final Map<String, dynamic> userData = json.decode(response.body);

        return userData;
      } else {
        final Map<String, dynamic> error = json.decode(response.body);
        throw error['message'];
      }
    } catch (e) {
      if (e is TimeoutException) {
        showSnackbar('Timeout', 'Server is too busy.Please come back again',ContentType.failure,context);
      } else if (e
          .toString()
          .contains('ClientException with SocketException')) {
        showSnackbar(
            'Network Connection Error', 'Check your Internet Connection!!!',ContentType.failure,context);
      } else {
        // Handle other exceptions
        showSnackbar('Something Went Wrong', e,ContentType.failure,context);
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
              'Something went wrong', '${data['message']} with this mail id.',ContentType.failure,context);
        } else {
          showSnackbar('OTP Sent', 'Check your email for otp!',ContentType.failure,context);
          Get.to(
              OtpVerifyScreen(
                otp: data['otp'].toString(),
                email: email,
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
        showSnackbar('Timeout', 'Server is too busy.Please come back again',ContentType.failure,context);
      } else if (e
          .toString()
          .contains('ClientException with SocketException')) {
        showSnackbar(
            'Network Connection Error', 'Check your Internet Connection!!!',ContentType.failure,context);
      } else {
        // Handle other exceptions
        showSnackbar('Something Went Wrong', e,ContentType.failure,context);
      }
      throw Exception('Error: $e');
    }
  }

  // --------------------------------- resetPassword--------------------------------------------------

  Future<Map<String, dynamic>> resetPassword(String password,String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/reset-password'),
        body: {
          'password': password,
          'email':email
        
        },
      ).timeout(const Duration(seconds: 30));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        final Map<String, dynamic> error = json.decode(response.body);

        throw error['message'];
      }
    } catch (e) {
      if (e is TimeoutException) {
        showSnackbar('Timeout', 'Server is too busy.Please come back again',ContentType.failure,context);
      } else if (e
          .toString()
          .contains('ClientException with SocketException')) {
        showSnackbar(
            'Network Connection Error', 'Check your Internet Connection!!!',ContentType.failure,context);
      } else {
        // Handle other exceptions
        showSnackbar('Something Went Wrong', e,ContentType.failure,context);
      }
      throw Exception('Error: $e');
    }
  }
}
