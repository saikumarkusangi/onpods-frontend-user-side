
import 'package:onpods/utils/exports.dart';



class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final ValueNotifier<double> appBarOpacity;

  const CustomAppBar({super.key, required this.appBarOpacity});

  @override
  Size get preferredSize => const Size.fromHeight(50);

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
                  width: 0.3.sw,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Get.to(const SearchScreen(),
                          transition: Transition.cupertino),
                      child: Image.asset(
                        searchIconImage,
                        scale: 3.5,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () => Get.to( NotificationsPage(),
                          transition: Transition.cupertino),
                      child: Image.asset(
                        announcement,
                        scale:3,
                        color: Colors.white,
                      ),
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
