import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class OurPodcast extends StatefulWidget {
  const OurPodcast({super.key});

  @override
  State<OurPodcast> createState() => _OurPodcastState();
}

class _OurPodcastState extends State<OurPodcast> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 15),
          child: Text(
            'Featured Podcasts',
            style: TextStyle(color: Colors.white, fontSize: 22),
          ),
        ),
        const SizedBox(
          height: 10,
        ),

        CarouselSlider(
            options: CarouselOptions(
              height: 180.0,
              enlargeCenterPage: true,
              autoPlay: true,
              aspectRatio: 16 / 9,
              autoPlayCurve: Curves.fastOutSlowIn,
              enableInfiniteScroll: true,
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              viewportFraction: 0.8,
            ),
            items: [
              Container(
                margin: const EdgeInsets.all(6.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  image: const DecorationImage(
                    image: NetworkImage(
                        "https://dw5sx4vw4zsrz.cloudfront.net/media/zmefogfk/desktop-205.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(6.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  image: const DecorationImage(
                    image: NetworkImage(
                        "https://dw5sx4vw4zsrz.cloudfront.net/media/5pentapt/207.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(6.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  image: const DecorationImage(
                    image: NetworkImage(
                        "https://dw5sx4vw4zsrz.cloudfront.net/media/fqenbbe1/desktop-95.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(6.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  image: const DecorationImage(
                    image: NetworkImage(
                        "https://dw5sx4vw4zsrz.cloudfront.net/media/wdhpchyg/hindi-vs-english-desktop.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ])
        // OurPodcastsSkeleton()
      ],
    );
  }
}
