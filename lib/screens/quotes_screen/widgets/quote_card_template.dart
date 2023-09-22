import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onpods/screens/quotes_screen/single_quote.dart';
import 'package:onpods/utils/utils_exports.dart';

class QuoteCardTemplate extends StatelessWidget {
  final String categoryTitle;
  const QuoteCardTemplate({super.key, required this.categoryTitle});

  @override
  Widget build(BuildContext context) {
    List data = [
      'https://quotefancy.com/media/wallpaper/3840x2160/1142581-Marguerite-Young-Quote-Life-has-no-beginning-middle-or-end.jpg',
      'https://quotefancy.com/media/wallpaper/3840x2160/6408566-Penny-Reid-Quote-You-re-my-beginning-middle-and-end.jpg',
      'https://www.marthastewart.com/thmb/nUsmREx6Sb4AGT6iFPY8Y9IPilo=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/love-quotes-beatles-0715_vert16-2000-2f004dfe9f1e412ca7cc012a65e505c9.jpg',
      'https://inspiremykids.com/wp-content/uploads/2021/09/Stand-Out-Quote-1024x759.png'
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                categoryTitle,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 22),
              ),
              GestureDetector(
                // onTap: () => Get.to(
                //     ViewAllScreen(
                //       title: categoryTitle,
                //     ),
                //     transition: Transition.cupertino),
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
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 150,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: data.length,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.only(left: 10),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                      onTap: () => Get.to(
                          SingleQuote(
                            image: data[index],
                          ),
                          transition: Transition.cupertino),
                      child: CacheImage(image: data[index]))),
            ),
          ),
        )
      ],
    );
  }
}
