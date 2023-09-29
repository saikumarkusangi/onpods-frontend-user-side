import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onpods/screens/podcast_screen/single_category_podcast.dart';
import 'package:onpods/utils/colors.dart';

class BrowseAllCard extends StatefulWidget {
  const BrowseAllCard({super.key});

  @override
  State<BrowseAllCard> createState() => _BrowseAllCardState();
}

class _BrowseAllCardState extends State<BrowseAllCard> {
  @override
  Widget build(BuildContext context) {
    List data = [
      {
        'name': 'Motivation',
        'color': '0xFFEC7A00',
        "image":
            "https://cdn-icons-png.flaticon.com/512/3094/3094768.png"
      },
      {
        'name': 'Business',
        'color': '0xFFDE0094',
        'image':
            'https://static.vecteezy.com/system/resources/thumbnails/009/343/580/small/3d-business-analysis-chart-illustration-png.png'
      },
      {
        'color': '0xFF07C0AD',
        'name': 'Political',
        'image':
            'https://cdn-icons-png.flaticon.com/512/1651/1651652.png'
      },
      {
        'color': '0xFF8AD80B',
        'name': 'Love',
        'image':
            'https://cdn.pixabay.com/photo/2020/02/03/05/31/couple-4814817_960_720.png'
      },
      {
        'color': '0xFF0876B1',
        'name': 'Peace',
        'image':
            'https://www.pngkit.com/png/full/174-1744675_open-dove-of-peace-emoji-png.png'
      },
      {
        'color': '0xFF3DA0DD',
        'name': 'Friendship',
        'image':
            'https://freepngimg.com/save/108661-forever-friendship-hq-image-free/1500x1000'
      },
      {
        'color': '0xFFffd500',
        'name': 'Family',
        'image':
            'https://www.pngmart.com/files/21/Happy-Family-Vector-PNG-Isolated-HD.png'
      },
      {
        'color': '0xFFF46866',
        'name': 'Success',
        'image': 'https://freepngimg.com/save/18341-success-png/450x283'
      }
    ];
    return Padding(
      padding: const EdgeInsets.only(top: 15, bottom: 15),
      child: SizedBox(
        child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: data.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 16 / 10,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                crossAxisCount: 2),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => Get.to(()=>
                  SinglePodcastCategory(
                  title: data[index]['name'],
                  image: data[index]['image'],
                ),transition: Transition.cupertino),
                child: Container(
                  decoration: BoxDecoration(
                      color: Color(int.parse(data[index]['color'])),
                      borderRadius: BorderRadius.circular(4)),
                  child: Stack(
                    children: [
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          decoration: BoxDecoration(                           
                              borderRadius: BorderRadius.circular(6),
                              image: DecorationImage(
                                  image: NetworkImage(
                                    data[index]['image'],
                                  ),
                                  fit: BoxFit.contain)),
                          width:100,
                          height: 70,
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            child: Text(
                              data[index]['name'],
                              maxLines: 2,
                              style: const TextStyle(
                                  fontSize: 18,
                                  overflow: TextOverflow.ellipsis,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}
