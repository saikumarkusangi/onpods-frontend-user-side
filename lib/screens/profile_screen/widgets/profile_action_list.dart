import 'package:google_sign_in/google_sign_in.dart';
import 'package:onpods/screens/profile_screen/widgets/built_action_item.dart';
import 'package:onpods/utils/exports.dart';

class ProfileActionList extends StatelessWidget {
  final String profilePic;
  final String userName;
  final String userId;
  const ProfileActionList(
      {super.key,
      required this.profilePic,
      required this.userName,
      required this.userId});

  @override
  Widget build(BuildContext context) {
    final _googleOauth = GoogleSignIn();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        buildActionItem(Icons.edit, 'Edit Profile', () {
          Get.to(
              EditProfileScreen(
                profilePic: profilePic,
                userName: userName,
                userId: userId,
              ),
              transition: Transition.cupertino);
        }, Colors.orange),
        buildActionItem(Icons.download, 'Downloads', () {
          Get.to(const DownloadsPage(), transition: Transition.cupertino);
        }, Colors.blueAccent),
        buildActionItem(Icons.security, 'Community Guidelines', () {
          // Navigate to community guidelines screen
          // Example: Get.to(CommunityGuidelinesScreen());
        }, Colors.cyan),
        buildActionItem(Icons.privacy_tip, 'Privacy Policies', () {
          // Navigate to privacy policies screen
          // Example: Get.to(PrivacyPoliciesScreen());
        }, Colors.amber),
        buildActionItem(Icons.book, 'Terms and Conditions', () {
          // Navigate to terms and conditions screen
          // Example: Get.to(TermsAndConditionsScreen());
        }, Colors.blue),
        buildActionItem(Icons.bug_report, 'Report Bugs', () {
          // Navigate to contact us screen
          // Example: Get.to(ContactUsScreen());
        }, Colors.greenAccent),
        buildActionItem(Icons.logout, 'Logout', () async {
          final pref = await SharedPreferences.getInstance();
          await _googleOauth.signOut();
          pref.clear();
          Get.off(const LoginScreen(), transition: Transition.leftToRight);
          showSnackbar('Success', 'You are logged out successfully');
        }, Colors.red),
        const SizedBox(height: 10),
      ],
    );
  }
}
