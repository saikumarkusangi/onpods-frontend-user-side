import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onpods/screens/home_screen/widgets/our_podcast.dart';
import 'package:onpods/screens/home_screen/widgets/quotes_for_you.dart';
import 'package:onpods/screens/home_screen/widgets/recommendation.dart';
import 'package:onpods/screens/home_screen/widgets/trending_podcast.dart';
import 'package:onpods/utils/colors.dart';
import 'package:onpods/utils/images.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<String?> getStoredUsername() async {
    final prefs = await SharedPreferences.getInstance();
    final storedUsername = prefs.getString('user_name');
    return storedUsername;
  }

  @override
  Widget build(BuildContext context) {
    DateTime? currentBackPressTime;

    Future<bool> onWillPop() async {
      DateTime now = DateTime.now();
      if (currentBackPressTime == null ||
          now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
        currentBackPressTime = now;
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.transparent,
            behavior: SnackBarBehavior.floating,
            width: 0.55.sw,
            content: Container(
              margin: const EdgeInsets.symmetric(vertical: 2.0),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(60)),
              child: const Text(
                'Press back again to exit',
                style: TextStyle(color: Colors.black),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
        return Future.value(false);
      }
      return Future.value(true);
    }

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 120,
        backgroundColor: scaffoldBackgroundColor,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Image.asset(appBarLogo),
        ),
      ),
      body: WillPopScope(
        onWillPop: onWillPop,
        child: const Padding(
          padding: EdgeInsets.only(left: 18),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // FutureBuilder<String?>(
                //   future: getStoredUsername(),
                //   builder: (context, snapshot) {
                //     if (snapshot.hasError) {
                //       return Text('Error: ${snapshot.error}');
                //     } else if (snapshot.hasData) {
                //       return Text(
                //         snapshot.data!,
                //         style: const TextStyle(color: Colors.white),
                //       );
                //     }
                //     return const CircularProgressIndicator();
                //   },
                // ),
                // ElevatedButton(
                //   onPressed: () {
                //     userProvider.logout();
                //     Get.off(const LoginScreen(),
                //         transition: Transition.leftToRight);
                //   },
                //   child: const Text('Logout'),
                // ),
                SizedBox(
                  height: 20,
                ),
                OurPodcast(),
                SizedBox(
                  height: 20,
                ),
                Recommendation(),
                SizedBox(
                  height: 20,
                ),
                TrendingPodcast(),
                SizedBox(
                  height: 20,
                ),
                QuotesForYou()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
