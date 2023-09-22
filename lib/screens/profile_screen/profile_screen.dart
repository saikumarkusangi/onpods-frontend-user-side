import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:onpods/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/snack_bar.dart';
import '../screens_exports.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? userName;
  String userEmail = 'example@gmail.com';

  String userProfileImage =
      'https://media.licdn.com/dms/image/D5603AQHY-yR32GlmsQ/profile-displayphoto-shrink_800_800/0/1693073345614?e=2147483647&v=beta&t=G3EkKjoX6LmsG6qhsEz2coFFi7nuJl-phqp_7mK-IX0';
  int followersCount = 500;
  int followingCount = 300;
  int podcastsCount = 20;
  int postsCount = 10;

  Future<void> _getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('user_name');
    });
  }

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 50),
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(userProfileImage),
          ),
          const SizedBox(height: 20),
          Text(
            userName!,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            userEmail,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.symmetric(
              vertical: 10,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: blueColor,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildUserStat('Followers', followersCount.toString()),
                _buildUserStat('Following', followingCount.toString()),
                _buildUserStat('Podcasts', podcastsCount.toString()),
                _buildUserStat('Posts', postsCount.toString()),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Divider(
              color: Colors.grey.shade600,
            ),
          ),
          // second part (scrollable)
          const Expanded(
            child: SingleChildScrollView(
              child: ProfileActionList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserStat(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class ProfileActionList extends StatelessWidget {
  const ProfileActionList({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black, // Dark grey background for actions
      child: Column(
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
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildActionItem(IconData icon, String title, Function() onTap,Color color) {
    return SizedBox(
      width: 0.9.sw,
      height: 70,
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(12),
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
            fontSize: 18,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
