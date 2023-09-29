import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onpods/screens/screens_exports.dart';

import '../utils/utils_exports.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final ValueNotifier<double> appBarOpacity;

  CustomAppBar({required this.appBarOpacity});

  @override
  Size get preferredSize => Size.fromHeight(60); // Set the desired height

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
      valueListenable: appBarOpacity,
      builder: (context, opacityValue, child) {
        return AppBar(
          toolbarHeight: preferredSize.height,
          backgroundColor: Colors.black.withOpacity(opacityValue),
          flexibleSpace: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  appBarLogo,
                  scale: 1.2,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Get.to(const PodcastScreen(),
                          transition: Transition.cupertino),
                      child: Image.asset(
                        searchIconImage,
                        scale: 24,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.notifications_outlined,
                        color: Colors.white,
                        size: 28,
                      ),
                      onPressed: () => Get.to(NotificationsPage(),
                          transition: Transition.cupertino),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
