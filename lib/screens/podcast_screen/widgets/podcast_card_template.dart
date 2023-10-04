import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:onpods/screens/podcast_screen/detailed_podcast.dart';
import 'package:onpods/screens/view_all_screen.dart';
import 'package:onpods/utils/colors.dart';
import '../../../constants/constants.dart';

class PodcastCardTemplate extends StatelessWidget {
  final String categoryTitle;

  const PodcastCardTemplate({Key? key, required this.categoryTitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                categoryTitle,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                 
                ),
              ),
              GestureDetector(
                onTap: () => Get.to(
                    ViewAllScreen(
                      title: categoryTitle,
                    ),
                    transition: Transition.cupertino),
                child: const Text(
                  'View All',
                  style: TextStyle(
                    fontSize: 14,
                    color: blueColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 8, bottom: 8),
            child: SizedBox(
              height: 170,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return _buildPodcastItem(data[index]);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPodcastItem(Map<String, String> itemData) {
    return Padding(
      padding: const EdgeInsets.only(right: 14),
      child: SizedBox(
        width: 0.36.sw,
        child: GestureDetector(
          onTap: () => Get.to(
            
            DetailedPodcast(
            image: itemData['image'] ?? '',
             title: itemData['title'] ?? '', 
             description: itemData['des'] ?? '',
              episodes: [],
               rating:4),
               transition: Transition.cupertino
               ),
          child: Column(
            children: [
              Container(
                width: 0.36.sw,
                height: 140,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: primaryColor,
                  image: DecorationImage(
                    image: NetworkImage(itemData['image']!),
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                itemData['title']!,
                maxLines: 1,
                style: const TextStyle(
                  overflow: TextOverflow.ellipsis,
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
