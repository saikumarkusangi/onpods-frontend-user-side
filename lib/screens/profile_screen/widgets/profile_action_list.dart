import 'dart:ui';
import 'package:flutter_hud/flutter_hud.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:onpods/screens/my_list_screen.dart';
import 'package:onpods/screens/privacy_policy_screen/privacy_page.dart';
import 'package:onpods/screens/privacy_policy_screen/terms_conditions.dart';
import 'package:onpods/screens/profile_screen/widgets/built_action_item.dart';
import 'package:onpods/utils/exports.dart';

class ProfileActionList extends StatefulWidget {
  final String profilePic;
  final String userName;
  final String userId;
  final List intrests;
  const ProfileActionList(
      {super.key,
      required this.profilePic,
      required this.userName,
      required this.userId, required this.intrests});

  @override
  State<ProfileActionList> createState() => _ProfileActionListState();
}

class _ProfileActionListState extends State<ProfileActionList> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final _googleOauth = GoogleSignIn();
    return WidgetHUD(
      showHUD: isLoading,
      hud: HUD(
          progressIndicator: Image.asset(
        liveGif,
        color: blueColor,
        scale: 3,
      )),
      builder: (context, child) => SingleChildScrollView(
        child: Column(
          children: [
            buildActionItem(Icons.edit, 'Edit Profile', () {
              Get.to(
                  EditProfileScreen(
                      profilePic: widget.profilePic,
                      userName: widget.userName,
                      userId: widget.userId,
                      intrests: widget.intrests),
                  transition: Transition.cupertino);
            }, Colors.orange),
            buildActionItem(Icons.download, 'Downloads', () {
              Get.to(const DownloadsPage(), transition: Transition.cupertino);
            }, Colors.blueAccent),
            buildActionItem(Icons.bookmark, 'My List', () {
              // Navigate to contact us screen
              Get.to(const MyListScreen());
            }, const Color.fromARGB(255, 7, 238, 126)),
        
            buildActionItem(Icons.privacy_tip, 'Privacy Policies', () {
              // Navigate to privacy policies screen
               Get.to(const PrivacyPolicyPage(), transition: Transition.cupertino);
            }, Colors.amber),
            buildActionItem(Icons.book, 'Terms and Conditions', () {
              // Navigate to terms and conditions screen
              Get.to(const TermsAndConditionsPage(), transition: Transition.cupertino);
            }, Colors.blue),
            // buildActionItem(Icons.bug_report, 'Report Bugs', () {
            //   // Navigate to contact us screen
            //   // Example: Get.to(ContactUsScreen());
            // }, Colors.greenAccent),
            buildActionItem(Icons.delete_forever, 'Delete Account', () async {
              showDialog(
                  context: context,
                  builder: (context) {
                    return BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: Container(
                        color: Colors.transparent,
                        child: AlertDialog(
                          backgroundColor: const Color.fromARGB(255, 78, 77, 77),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6)),
                          title: Text(
                            'Are you sure?',
                            style:
                                TextStyle(fontSize: 28.sp, color: Colors.white),
                          ),
                          content: SizedBox(
                            height: 120,
                            child: Column(
                              children: [
                                Text(
                                  'Account will be deleted permanently.',
                                  style: TextStyle(
                                      fontSize: 22.sp,
                                      color: const Color.fromARGB(
                                          255, 192, 190, 190)),
                                ),
                                const Divider(
                                  color: Color.fromARGB(255, 169, 166, 166),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        color: blueColor,
                                        child: TextButton(
                                          child: Text(
                                            'Cancel',
                                            style: TextStyle(
                                                fontSize: 20.sp,
                                                color: Colors.white),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Container(
                                        color: Colors.redAccent,
                                        child: TextButton(
                                          child: Text(
                                            'Delete',
                                            style: TextStyle(
                                                fontSize: 20.sp,
                                                color: Colors.white),
                                          ),
                                          onPressed: () async {
                                            try {
                                              setState(() {
                                                isLoading = true;
                                              });
                                              await UserServices().delete();
                                              final pref = await SharedPreferences
                                                  .getInstance();
                                              await _googleOauth.signOut();
                                              pref.clear();
                                              Get.offAll(const LoginScreen(),
                                                  transition: Transition.fade);
                                              (
                                                'Success',
                                                'Account Deleted permanently'
                                              );
                                            } finally {
                                              setState(() {
                                                isLoading = false;
                                              });
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  });
            }, Colors.redAccent),
        
            buildActionItem(Icons.logout, 'Logout', () async {
              final pref = await SharedPreferences.getInstance();
              await _googleOauth.signOut();
              pref.clear();
              Get.offAll(const LoginScreen(), transition: Transition.fade);
              showSnackbar('Success', 'You are logged out successfully',ContentType.success,context);
            }, Colors.red.shade300),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
