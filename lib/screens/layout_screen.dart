import 'package:flutter/material.dart';
import 'package:onpods/screens/chat_room/create_chatroom.dart';
import 'package:onpods/utils/exports.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class Layout extends StatefulWidget {
  const Layout({Key? key}) : super(key: key);

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  final _controller = PersistentTabController(initialIndex: 0);
  DateTime? currentBackPressTime;
   late StreamController<bool> _internetStatusController;
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

@override
  void initState() {
    super.initState();
    _internetStatusController = StreamController<bool>();
    _checkInternetConnectivity();
  }
    @override
  void dispose() {
    _internetStatusController.close();
    _connectivitySubscription.cancel();
    super.dispose();
  }

   Future<void> _checkInternetConnectivity() async {
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      _internetStatusController.add(result != ConnectivityResult.none);
    });
  }


  void _showBottomSheet() {
    showModalBottomSheet<void>(
      backgroundColor: const Color.fromARGB(255, 34, 33, 33),
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10))),
      constraints: const BoxConstraints(maxHeight: 280),
      builder: (BuildContext context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Create',
                    style: TextStyle(fontSize: 22, color: Colors.white),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_sharp,
                        color: Colors.white, size: 28),
                  ),
                ],
              ),
            ),
            _buildListTile(
                podcastIcon, 'Upload Podcast', const RecordPodcast()),
            const SizedBox(height: 10),
            _buildListTile(quoteIcon, 'Upload Quote', const CreateQuote()),
            const SizedBox(height: 10),
            _buildListTile(
                chatRoomIcon, 'Create Chat Room',  const CreateChatRoom()),
          ],
        );
      },
    );
  }

  Widget _buildListTile(
      String leadingIcon, String title, Widget pageToNavigate) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 71, 71, 71),
          borderRadius: BorderRadius.circular(60),
        ),
        child: Image.asset(leadingIcon, scale: 12, color: Colors.white),
      ),
      title: Text(
        title,
        style:  TextStyle(
          color: Colors.white,
          fontSize: 22.sp,
          fontWeight: FontWeight.w400,
        ),
      ),
      onTap: () {
        Get.to(pageToNavigate, transition: Transition.downToUp)!
            .whenComplete(() {
          Navigator.pop(context);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<PersistentBottomNavBarItem> navBarItems() {
      return [
        PersistentBottomNavBarItem(
            title: 'Podcasts',
            activeColorPrimary: Colors.white.withOpacity(0.7),
            activeColorSecondary: blueColor,
            icon: const ImageIcon(AssetImage(podcastIcon))),
        PersistentBottomNavBarItem(
            title: 'Quotes',
            activeColorPrimary: Colors.white.withOpacity(0.7),
            activeColorSecondary: blueColor,
            icon: const ImageIcon(AssetImage(quoteIcon))),
        PersistentBottomNavBarItem(
          title: 'Add',
          activeColorPrimary: Colors.white.withOpacity(0.7),
          activeColorSecondary: blueColor,
          icon: const Icon(
            Icons.add_circle_outlined,
            size: 34,
          ),
          onPressed: (context) => _showBottomSheet(),
        ),
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

    return  StreamBuilder<bool>(
      stream: _internetStatusController.stream,
      initialData: true, 
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Image.asset(
            liveGif,
            color: blueColor,
            scale: 3,
          );
        } else if (!snapshot.hasData || !snapshot.data!) {
          return const NoConnection();
        } else {
          return PersistentTabView(
            context,
            controller: _controller,
            screens: const [
              HomeScreen(),
              QuotesScreen(),
              SizedBox(),
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
              colorBehindNavBar: darkscaffoldBackgroundColor,
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
