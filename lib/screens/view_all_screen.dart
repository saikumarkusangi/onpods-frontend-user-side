import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onpods/constants/constants.dart';
import 'package:onpods/utils/images.dart';
import 'podcast_screen/detailed_podcast.dart';

class ViewAllScreen extends StatelessWidget {
  final String title;
  const ViewAllScreen({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
      ),
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: data.length,
        itemBuilder: (context, index) {
          final podcastData = data[index];

          return GestureDetector(
            onTap: () => Get.to(
              DetailedPodcast(
                description: podcastData['des']! ?? '',
                image: podcastData['image']! ?? '',
                episodes: const [],
                rating: 3,
                title: podcastData['title']! ?? '',
              ),
              transition: Transition.downToUp,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 150,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: CachedNetworkImage(
                        errorWidget: (context, url, error) => Image.asset(
                          podcastPlaceHolder,
                          scale: 5,
                        ),
                        width: MediaQuery.of(context).size.width * 0.4,
                        imageUrl: podcastData['image']! ?? '',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.485,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          podcastData['title']! ?? '',
                          maxLines: 4,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 18,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          podcastData['des']! ?? '',
                          maxLines: 3,
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 14,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
