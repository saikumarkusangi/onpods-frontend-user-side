import 'package:flutter/material.dart';
import 'package:onpods/screens/screens_exports.dart';

class AppRoutes {
  static const String login = '/login';
  static const String splash = '/splash';
  static const String signup = '/signup';
  static const String chooseintrest = '/chooseintrest';
  static const String home = '/home';

  static Map<String, WidgetBuilder> routes = {
    splash: (context) => const SplashScreen(),
    login: (context) => const LoginScreen(),
    signup: (context) => const SignUpScreen(),
    chooseintrest: (context) => const ChooseYourInterestScreen(),
    home: (context) => const HomeScreen()
  };
}
