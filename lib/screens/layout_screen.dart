import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../utils/utils_exports.dart';
import '../widgets/widgets_exports.dart';
import 'screens_exports.dart';

class Layout extends StatefulWidget {
  const Layout({Key? key}) : super(key: key);

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  final _controller = PersistentTabController(initialIndex: 0);
  DateTime? currentBackPressTime;

  Future<bool> checkInternetConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

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

  @override
  Widget build(BuildContext context) {
    List<PersistentBottomNavBarItem> navBarItems() {
      return [
        PersistentBottomNavBarItem(
            title: 'Home',
            activeColorPrimary: Colors.white.withOpacity(0.7),
            activeColorSecondary: blueColor,
            icon: const ImageIcon(AssetImage(homeIcon))),
        PersistentBottomNavBarItem(
            title: 'Quotes',
            activeColorPrimary: Colors.white.withOpacity(0.7),
            activeColorSecondary: blueColor,
            icon: const ImageIcon(AssetImage(quoteIcon))),
        PersistentBottomNavBarItem(
            title: 'Podcast',
            activeColorPrimary: Colors.white.withOpacity(0.7),
            activeColorSecondary: blueColor,
            icon: const ImageIcon(AssetImage(podcastIcon))),
        PersistentBottomNavBarItem(
            title: 'Chat Room',
            activeColorPrimary: Colors.white.withOpacity(0.7),
            activeColorSecondary: blueColor,
            icon: const ImageIcon(AssetImage(chatRoomIcon))),
        PersistentBottomNavBarItem(
            title: 'Profile',
            activeColorPrimary: Colors.white.withOpacity(0.7),
            activeColorSecondary: blueColor,
            icon: const ImageIcon(AssetImage(profileIcon))),
      ];
    }

    return FutureBuilder<bool>(
      future: checkInternetConnectivity(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Image.asset(
            liveGif,
            color: blueColor,
            scale: 3,
          );
        } else if (!snapshot.hasData) {
          return const NoConnection();
        } else {
          return PersistentTabView(
            context,
            controller: _controller,
            screens: const [
              HomeScreen(),
              QuotesScreen(),
              PodcastScreen(),
              ChatRoomList(),
              ProfileScreen(),
            ],
            items: navBarItems(),
            confineInSafeArea: true,
            backgroundColor: Colors.black,
            handleAndroidBackButtonPress: true,
            resizeToAvoidBottomInset: true,
            stateManagement: true,
            hideNavigationBarWhenKeyboardShows: false,
            decoration: NavBarDecoration(
              borderRadius: BorderRadius.circular(10.0),
              colorBehindNavBar: scaffoldBackgroundColor,
            ),
            popAllScreensOnTapOfSelectedTab: true,
            popActionScreens: PopActionScreensType.all,
            itemAnimationProperties: const ItemAnimationProperties(
              duration: Duration(milliseconds: 400),
              curve: Curves.ease,
            ),
            screenTransitionAnimation: const ScreenTransitionAnimation(
              animateTabTransition: true,
              curve: Curves.easeInOut,
              duration: Duration(milliseconds: 200),
            ),
            navBarStyle: NavBarStyle.style12,
            padding: const NavBarPadding.all(12),
          );
        }
      },
    );
  }
}
