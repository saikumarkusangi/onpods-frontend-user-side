import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:onpods/screens/quotes_screen/single_quote.dart';
import 'package:onpods/utils/utils_exports.dart';

class QuoteOfTheDay extends StatelessWidget {
  const QuoteOfTheDay({super.key});

  @override
  Widget build(BuildContext context) {
    String image1 =
        'https://cdn.shopify.com/s/files/1/0070/7032/files/Fearless_Motivational_Quote_Desktop_Wallpaper_1.png?format=jpg&quality=90&v=1600450412';
    String image2 =
        'https://www.weareteachers.com/wp-content/uploads/Reading-Quotes-Feature.jpg';
    String image3 =
        'https://www.cyberlink.com/prog/learning-center/html/9408/PDR19-YouTube-495_Love_Quotes_PC/img/love-quotes.jpg';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Top Three Quote Of The Day",
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.left,
            style: TextStyle(color: Colors.white, fontSize: 22),
          ),
          const SizedBox(
            height: 10,
          ),
          CarouselSlider(
              options: CarouselOptions(
                height: 150.0,
                enlargeCenterPage: true,
                autoPlay: true,
                aspectRatio: 16 / 9,
                autoPlayCurve: Curves.fastOutSlowIn,
                enableInfiniteScroll: true,
                autoPlayAnimationDuration: const Duration(milliseconds: 400),
                viewportFraction: 1,
              ),
              items: [
                SizedBox(
                  height: 150,
                  width: 1.sw,
                  child: InkWell(
                    onTap: () => Get.to(SingleQuote(image: image1),
                        transition: Transition.rightToLeft),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CacheImage(image: image1)),
                  ),
                ),
                SizedBox(
                  height: 150,
                  width: 1.sw,
                  child: InkWell(
                    onTap: () => Get.to(SingleQuote(image: image2),
                        transition: Transition.rightToLeft),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CacheImage(image: image2)),
                  ),
                ),
                SizedBox(
                  height: 150,
                  width: 1.sw,
                  child: InkWell(
                    onTap: () => Get.to(SingleQuote(image: image3),
                        transition: Transition.rightToLeft),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CacheImage(image: image3)),
                  ),
                )
              ]),
        ],
      ),
    );
  }
}
