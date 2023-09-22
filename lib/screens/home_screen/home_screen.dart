import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onpods/screens/player/player_screen.dart';
import '../../utils/utils_exports.dart';
import '../screens_exports.dart';
import 'widgets/banner_carsouel.dart';
import '../podcast_screen/widgets/podcast_card_template.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        toolbarHeight: 60,
        backgroundColor: Colors.black.withOpacity(0),
        flexibleSpace: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 40),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                appBarLogo,
                scale: 1.1,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    searchIconImage,
                    scale: 24,
                    color: Colors.white,
                  ),
                  const SizedBox(
                    width: 14,
                  ),
                  IconButton(
                      icon: const Icon(
                        Icons.notifications_outlined,
                        color: Colors.white,
                        size: 28,
                      ),
                      onPressed: () => Get.to(NotificationsPage(),
                          transition: Transition.cupertino)),
                ],
              )
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(),
        child: Stack(
          children: [
            const SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      BannerCarsouel(),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  PodcastCardTemplate(categoryTitle: 'Trending Podcast'),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: () => Get.to(
                    const PlayerScreen(
                      poster: 'poster',
                      title: 'title',
                      episode: 'episode',
                      audioUrl: 'audioUrl',
                      playlist: [],
                    ),
                    transition: Transition.downToUp),
                child: Container(
                  height: 70,
                  width: double.infinity,
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.black, // Background color
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 5,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Leading Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          'https://i.iheart.com/v3/url/aHR0cHM6Ly93d3cub21ueWNvbnRlbnQuY29tL2QvcHJvZ3JhbXMvZTczYzk5OGUtNmU2MC00MzJmLTg2MTAtYWUyMTAxNDBjNWIxLzc0NDNiZThlLTY3NTgtNDEzMS1iZDE3LWIwNGEwMGVlMTcwNS9pbWFnZS5qcGc_dD0xNjkwMzg0OTI5JnNpemU9TGFyZ2U?ops=fit(960%2C960)',
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                      // Title and Subtitle
                      const Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'trackTitle',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                'trackSubtitle',
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Trailing Play/Pause Icon
                      IconButton(
                        onPressed: () {
                          // Toggle playback state or perform other actions here
                        },
                        icon: const Icon(
                          false ? Icons.pause : Icons.play_arrow,
                          size: 32,
                          color: Colors.blue, // Icon color
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
