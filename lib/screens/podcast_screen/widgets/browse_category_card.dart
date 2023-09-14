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
        'color': '0xFFf77f00',
        "image":
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS1k77e_FxORW4ninNpZ7irpy0iQTHRIe9czOB704Vxs1n20IL-1IUs7NAJFEJl7IjTBFk&usqp=CAU"
      },
      {
        'name': 'Business',
        'color': '0xFFfface4',
        'image':
            'https://online.hbs.edu/Style%20Library/api/resize.aspx?imgpath=/PublishingImages/overhead-view-of-business-strategy-meeting.jpg&w=1200&h=630'
      },
      {
        'color': '0xFF83c5be',
        'name': 'Political',
        'image':
            'https://leverageedublog.s3.ap-south-1.amazonaws.com/blog/wp-content/uploads/2020/03/05191207/Political-Leaders.png'
      },
      {
        'color': '0xFFA1EE27',
        'name': 'Love',
        'image':
            'https://www.yourtango.com/sites/default/files/image_blog/how%20to%20get%20him%20to%20be%20more%20romantic.jpg'
      },
      {
        'color': '0xFFb5e2fa',
        'name': 'Peace',
        'image':
            'https://kashmirpulse.com/wp-content/uploads/2019/02/Pigeon-Dove-Peace.jpg'
      },
      {
        'color': '0xFF669bbc',
        'name': 'Friendship',
        'image':
            'https://miro.medium.com/v2/resize:fit:1400/1*FU5FeZPahK3OoL217xB0hA.jpeg'
      },
      {
        'color': '0xFFffd500',
        'name': 'Family',
        'image':
            'https://images.squarespace-cdn.com/content/v1/5a0f0ac6bff2002ba3f1c5b6/7f52594a-6ebf-4da0-9d11-c30f3ae2ab1f/how-can-family-focused-ABA-therapy-help-children.jpg'
      },
      {
        'color': '0xFFf28482',
        'name': 'Success',
        'image': 'https://iasbaba.com/wp-content/uploads/2021/01/Successful.jpg'
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
                onTap: () => Get.to(
                  SinglePodcastCategory(
                  title: data[index]['name'],
                  image: data[index]['image'],
                ),transition: Transition.rightToLeftWithFade),
                child: Container(
                  decoration: BoxDecoration(
                      color: Color(int.parse(data[index]['color'])),
                      borderRadius: BorderRadius.circular(8)),
                  child: Stack(
                    children: [
                      Positioned(
                        bottom: -5,
                        right: -5,
                        child: RotationTransition(
                          turns: const AlwaysStoppedAnimation(15 / 360),
                          child: Container(
                            decoration: BoxDecoration(
                                boxShadow: const [
                                  BoxShadow(
                                      color: Colors.black38,
                                      blurRadius: 2,
                                      offset: Offset(-3, 3))
                                ],
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                    image: NetworkImage(
                                      data[index]['image'],
                                    ),
                                    fit: BoxFit.cover)),
                            width: 70,
                            height: 70,
                          ),
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
