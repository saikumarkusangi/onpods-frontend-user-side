import 'package:flutter/material.dart';
import 'package:onpods/utils/colors.dart';
import 'package:onpods/utils/images.dart';

class ChartRoomCard extends StatelessWidget {
  final String title;
  const ChartRoomCard({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: darktextFieldColor,
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset(
                    liveGif,
                    width: 20,
                    color: Colors.white,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  const Text(
                    'LIVE',
                    style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 12,
                        color: Colors.red),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                title,
                maxLines: 2,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 160,
                child: Stack(
                  children: [
                    const CircleAvatar(
                        radius: 16,
                        backgroundImage: NetworkImage(
                            'https://c.superprof.com/i/a/24588147/11237620/600/20230117022547/mobile-app-developer-and-full-stack-developer-with-experience-developing-both-android-and-ios-apps-using-flutter-and-web.jpg')),
                    const Positioned(
                      left: 20,
                      child: CircleAvatar(
                          radius: 16,
                          backgroundImage: NetworkImage(
                              'https://m.economictimes.com/thumb/msid-98001983,width-1599,height-1066,resizemode-4,imgsize-86156/neal-mohan-.jpg')),
                    ),
                    const Positioned(
                      left: 40,
                      child: CircleAvatar(
                          radius: 16,
                          backgroundImage: NetworkImage(
                              'https://www.sakshipost.com/sites/default/files/styles/canvas/public/article_images/2023/06/14/Keerthi-Suresh-women-centric-film-1686730032.jpg?itok=kwVZVKoG')),
                    ),
                    const Positioned(
                      left: 60,
                      child: CircleAvatar(
                          radius: 16,
                          backgroundImage: NetworkImage(
                              'https://akm-img-a-in.tosshub.com/businesstoday/images/story/202303/120604-satya-nadella-reuters-sixteen_nine.jpg?size=948:533')),
                    ),
                    Positioned(
                        left: 100,
                        top: 5,
                        child: Text(
                          '+ 60',
                          style:
                              TextStyle(color: Colors.white.withOpacity(0.5)),
                        ))
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  const CircleAvatar(
                      radius: 10,
                      backgroundImage: NetworkImage(
                          'https://c.superprof.com/i/a/24588147/11237620/600/20230117022547/mobile-app-developer-and-full-stack-developer-with-experience-developing-both-android-and-ios-apps-using-flutter-and-web.jpg')),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text(
                    'Sai kumar',
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 1.5),
                    decoration: BoxDecoration(
                        color: blueColor.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(10)),
                    child: const Text(
                      'HOST',
                      style: TextStyle(color: Colors.white, fontSize: 9),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
