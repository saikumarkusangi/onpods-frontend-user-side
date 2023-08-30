import 'package:flutter/material.dart';
import 'package:onpods/screens/home_screen/widgets/home_skeleton.dart';

class TrendingPodcast extends StatefulWidget {
  const TrendingPodcast({super.key});

  @override
  State<TrendingPodcast> createState() => _TrendingPodcastState();
}

class _TrendingPodcastState extends State<TrendingPodcast> {
  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Trending Podcast',
          style: TextStyle(color: Colors.white, fontSize: 22),
        ),
        HomeSkeleton()
      ],
    );
  }
}
