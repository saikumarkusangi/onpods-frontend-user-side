import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';

import '../providers/providers_exports.dart';
import '../utils/utils_exports.dart';
import 'screens_exports.dart';

class Layout extends StatefulWidget {
  const Layout({Key? key}) : super(key: key);

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  final _controller = PersistentTabController(initialIndex: 0);
  final List<Widget> _screens = [
    const HomeScreen(),
    const QuotesScreen(),
    const PodcastScreen(),
    const ChatRoomList(),
    const ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    List<PersistentBottomNavBarItem> _navBarItems() {
      return [
        PersistentBottomNavBarItem(
            title: 'Home',
            activeColorPrimary: Colors.grey.withOpacity(0.5),
            activeColorSecondary: Colors.blue,
            icon: const ImageIcon(AssetImage(homeIcon))),
        PersistentBottomNavBarItem(
            title: 'Quotes',
            activeColorPrimary: Colors.grey.withOpacity(0.5),
            activeColorSecondary: Colors.blue,
            icon: const ImageIcon(AssetImage(quoteIcon))),
        PersistentBottomNavBarItem(
            title: 'Podcast',
            activeColorPrimary: Colors.grey.withOpacity(0.5),
            activeColorSecondary: Colors.blue,
            icon: const ImageIcon(AssetImage(podcastIcon))),
        PersistentBottomNavBarItem(
            title: 'Chat Room',
            activeColorPrimary: Colors.grey.withOpacity(0.5),
            activeColorSecondary: Colors.blue,
            icon: const ImageIcon(AssetImage(chatRoomIcon))),
        PersistentBottomNavBarItem(
            title: 'Profile',
            activeColorPrimary: Colors.grey.withOpacity(0.5),
            activeColorSecondary: Colors.blue,
            icon: const ImageIcon(AssetImage(profileIcon))),
      ];
    }

    return PersistentTabView(
      context,
      controller: _controller,
      screens: _screens,
      items: _navBarItems(),
      confineInSafeArea: true,
      backgroundColor: bottomNavColor,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      hideNavigationBarWhenKeyboardShows: false,
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Colors.white,
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
}
