import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onpods/screens/auth_screen/login_screen.dart';
import 'package:onpods/utils/snack_bar.dart';
import 'package:onpods/widgets/custom_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomElevatedButton(
              onTap: () async {
                final pref = await SharedPreferences.getInstance();
                pref.clear();
                Get.off(const LoginScreen(),
                    transition: Transition.leftToRight);
                showSnackbar('Success', 'You are Logged out successfully');
              },
              text: "Logout"),
          const Text(
            'Profile page',
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
