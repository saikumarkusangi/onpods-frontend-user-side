// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onpods/utils/colors.dart';

class TrendingPodcast extends StatefulWidget {
  const TrendingPodcast({super.key});

  @override
  State<TrendingPodcast> createState() => _TrendingPodcastState();
}

class _TrendingPodcastState extends State<TrendingPodcast> {
  @override
  Widget build(BuildContext context) {
    List data = [
      {
        "title": "You Feeling This",
        "image":
            "https://i.iheart.com/v3/url/aHR0cHM6Ly93d3cub21ueWNvbnRlbnQuY29tL2QvcHJvZ3JhbXMvZTczYzk5OGUtNmU2MC00MzJmLTg2MTAtYWUyMTAxNDBjNWIxLzViMjRjZDE5LTQ2NTMtNGEwMi04YzJiLWIwMDMwMTUwMTZjYS9pbWFnZS5qcGc_dD0xNjg0MjUyODQxJnNpemU9TGFyZ2U?ops=fit(960%2C960)",
      },
      {
        "title": "The Mantawauk Caves",
        "image":
            "https://i.iheart.com/v3/url/aHR0cHM6Ly93d3cub21ueWNvbnRlbnQuY29tL2QvcGxheWxpc3QvZTczYzk5OGUtNmU2MC00MzJmLTg2MTAtYWUyMTAxNDBjNWIxLzUwMDU3ZjdlLTg5ZGMtNDBhNi04NTE1LWFmYjcwMGY3ZDA1MC8yMmU4YTE4Zi02ZWVlLTQ2ZjYtOGQwZC1hZmI3MDBmODIxZGIvaW1hZ2UuanBnP3Q9MTY3OTMzMDExNiZzaXplPUxhcmdl?ops=fit(960%2C960)"
      },
      {
        "image":
            'https://i.iheart.com/v3/url/aHR0cHM6Ly93d3cub21ueWNvbnRlbnQuY29tL2QvcHJvZ3JhbXMvZTczYzk5OGUtNmU2MC00MzJmLTg2MTAtYWUyMTAxNDBjNWIxL2E5MTAxOGE0LWVhNGYtNDEzMC1iZjU1LWFlMjcwMTgwYzMyNy9pbWFnZS5qcGc_dD0xNjg0ODQ2NDMyJnNpemU9TGFyZ2U?ops=fit(960%2C960)',
        "title": 'Stuff You Should Know',
      }
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15),
          child: const Text(
            'Trending Podcast',
            style: TextStyle(color: Colors.white, fontSize: 22),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        SizedBox(
          height: 0.27.sh,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: data.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(left: 15),
                child: SizedBox(
                  width: 0.41.sw,
                  child: Column(
                    children: [
                      Container(
                        width: 0.4.sw,
                        height: 0.22.sh,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: primaryColor,
                            image: DecorationImage(
                                image: NetworkImage(data[index]['image']),
                                fit: BoxFit.cover,
                                alignment: Alignment.center)),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        data[index]['title'],
                        maxLines: 1,
                        style: const TextStyle(
                            overflow: TextOverflow.ellipsis,
                            color: Colors.white,
                            fontSize: 16),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        )
        // HomeSkeleton()
      ],
    );
  }
}
