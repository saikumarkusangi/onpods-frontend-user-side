import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
        Fluttertoast.showToast(
            msg: "Press again to Exist.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.white,
            textColor: Colors.black,
            fontSize: 16.0);
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
        child: Padding(
          padding: const EdgeInsets.only(),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(
                  height: 20,
                ),
                const OurPodcast(),
                const SizedBox(
                  height: 20,
                ),
                const Recommendation(),
                const SizedBox(
                  height: 20,
                ),
                const TrendingPodcast(),
                const SizedBox(
                  height: 20,
                ),
                const QuotesForYou(),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.network(
                        'https://gcdnb.pbrd.co/images/xj3ry1ACQnt0.png?o=1',
                        scale: 5,
                      ),
                      const Text(
                        'Explore,\nListen, Repeat.',
                        style: TextStyle(
                            fontSize: 28,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
