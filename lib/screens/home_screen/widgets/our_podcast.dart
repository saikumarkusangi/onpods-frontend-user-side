import 'package:flutter/material.dart';
import 'package:onpods/screens/home_screen/widgets/home_skeleton.dart';

class OurPodcast extends StatefulWidget {
  const OurPodcast({super.key});

  @override
  State<OurPodcast> createState() => _OurPodcastState();
}

class _OurPodcastState extends State<OurPodcast> {
  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Explore Our Podcast',
          style: TextStyle(color: Colors.white, fontSize: 22),
        ),
        OurPodcastsSkeleton()
      ],
    );
  }
}
