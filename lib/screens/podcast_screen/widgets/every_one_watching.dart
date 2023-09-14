import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/utils_exports.dart';

class EveryOneWatching extends StatefulWidget {
  const EveryOneWatching({super.key});

  @override
  State<EveryOneWatching> createState() => _EveryOneWatchingState();
}

class _EveryOneWatchingState extends State<EveryOneWatching> {
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
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Every One Listening',
          style: TextStyle(color: Colors.white, fontSize: 22),
        ),
        const SizedBox(height: 10,),
        SizedBox(
          height: 0.298.sh,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: data.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 15),
                child: SizedBox(
                  width: 0.38.sw,
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
                                fit: BoxFit.contain,
                                alignment: Alignment.center)),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        data[index]['title'],
                        maxLines: 2,
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
      ],
    );
  }
}
