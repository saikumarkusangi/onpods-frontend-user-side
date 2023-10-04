import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/utils_exports.dart';
import '../../screens_exports.dart';

class ProfileActionList extends StatelessWidget {
  const ProfileActionList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildActionItem(
          Icons.edit,
          'Edit Profile',
          () {
            // Navigate to edit profile screen
            // Example: Get.to(EditProfileScreen());
          },
         Colors.orange
        ),
        _buildActionItem(
          Icons.download,
          'Downloads',
          () {
            Get.to(const DownloadsPage(), transition: Transition.cupertino);
          },
          Colors.blueAccent
        ),
        _buildActionItem(
          Icons.security,
          'Community Guidelines',
          () {
            // Navigate to community guidelines screen
            // Example: Get.to(CommunityGuidelinesScreen());
          },
          Colors.cyan
        ),
        _buildActionItem(
          Icons.privacy_tip,
          'Privacy Policies',
          () {
            // Navigate to privacy policies screen
            // Example: Get.to(PrivacyPoliciesScreen());
          },
        Colors.amber
        ),
        _buildActionItem(
          Icons.book,
          'Terms and Conditions',
          () {
            // Navigate to terms and conditions screen
            // Example: Get.to(TermsAndConditionsScreen());
          },
        Colors.blue
        ),
        _buildActionItem(
          
          Icons.bug_report,
          'Report Bugs',
          () {
            // Navigate to contact us screen
            // Example: Get.to(ContactUsScreen());
          },
           Colors.greenAccent
         
        ),
        _buildActionItem(
          Icons.logout,
          'Logout',
          () async {
            final pref = await SharedPreferences.getInstance();
            pref.clear();
            Get.off(const LoginScreen(), transition: Transition.leftToRight);
            showSnackbar('Success', 'You are logged out successfully');
          },
          Colors.red
         
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildActionItem(IconData icon, String title, Function() onTap,Color color) {
    return ListTile(
      
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(80), color: color),
        child: Icon(
          icon,
          size: 20,
          color: Colors.white,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
      onTap: onTap,
    );
  }
}
