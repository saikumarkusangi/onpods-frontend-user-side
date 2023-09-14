import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../utils/utils_exports.dart';

class SingleQuote extends StatefulWidget {
  final String image;
  const SingleQuote({super.key, required this.image});

  @override
  State<SingleQuote> createState() => _SingleQuoteState();
}

class _SingleQuoteState extends State<SingleQuote> {
  bool isLiked = false;
  bool isHeartAnimating = false;
  @override
  Widget build(BuildContext context) {
    List<Widget> listTile = <Widget>[
      Padding(
        padding: const EdgeInsets.all(4),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.network(
              "https://i.pinimg.com/236x/85/25/80/8525803a3bc75602b03ede2b011b5067.jpg"),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(4),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.network(
              "https://i.pinimg.com/474x/8b/57/a8/8b57a85616fcad535ecd85ee1b87b129.jpg"),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(4),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.network(
              "https://img.freepik.com/free-vector/calligraphic-background-motivational-quote_52683-16294.jpg?w=2000"),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(4),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.network(
              "https://i0.wp.com/avemateiu.com/wp-content/uploads/2019/05/quote-271.png?fit=1080%2C1080&ssl=1"),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(4),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.network(
              "https://i0.wp.com/avemateiu.com/wp-content/uploads/2019/05/quote-271.png?fit=1080%2C1080&ssl=1"),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(4),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.network(
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTSTqlJevy58P-lkO7dj6kNB1zelqDpgVfHCA&usqp=CAU"),
        ),
      ),
    ];

    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.3),
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20))),
              child: Column(
                children: [
                  InkWell(
                    onDoubleTap: () {
                      setState(() {
                        isHeartAnimating = true;
                        isLiked = true;
                      });
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        ClipRRect(
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20)),
                            child: CachedNetworkImage(
                                placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                imageUrl: widget.image)),
                        SvgPicture.asset(
                          isLiked ? lovedIcon : '',
                          width: 100,
                        ),
                        Positioned(
                          left: 10,
                          top: 10,
                          child: InkWell(
                            onTap: () => Get.back(),
                            child: Container(
                                width: 45,
                                height: 45,
                                decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.4),
                                    borderRadius: BorderRadius.circular(50)),
                                child: const Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Icon(
                                      Icons.arrow_back_ios,
                                      color: Colors.white,
                                      size: 28,
                                    ))),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  SvgPicture.asset(
                                    isLiked ? lovedIcon : loveIcon,
                                    height: 45,
                                  ),
                                  const Text(
                                    '20',
                                    style: TextStyle(color: whiteColor),
                                  )
                                ],
                              ),
                            ),
                            // Padding(
                            //   padding: const EdgeInsets.all(8.0),
                            //   child: Column(
                            //     children: [
                            //       Image.asset(
                            //         chatIcon,
                            //         scale: 14,
                            //       ),
                            //       const Text(
                            //         '20',
                            //         style: TextStyle(color: whiteColor),
                            //       )
                            //     ],
                            //   ),
                            // ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Image.asset(
                                    sendIcon,
                                    scale: 14,
                                  ),
                                  const Text(
                                    '',
                                    style: TextStyle(color: whiteColor),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        const Column(
                          children: [
                           Icon(Icons.download),
                            Text(
                              '',
                              style: TextStyle(color: whiteColor),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    leading: Container(
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                          color: textFieldColor,
                          borderRadius: BorderRadius.circular(60),
                          image: const DecorationImage(
                              image: NetworkImage(
                                  'https://i.pinimg.com/280x280_RS/7f/13/be/7f13be39c851d992863c412e9ee1c7a5.jpg'))),
                    ),
                    title: const Text(
                      'Sai kumar Kusangi',
                      maxLines: 1,
                      style: TextStyle(
                          color: Colors.white,
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.w800),
                    ),
                    subtitle: const Text(
                      '25 follwers',
                      maxLines: 1,
                      style: TextStyle(
                        color: Colors.white,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    trailing: Container(
                      width: 80,
                      height: 40,
                      decoration: BoxDecoration(
                          color: blueColor,
                          borderRadius: BorderRadius.circular(40)),
                      child: const Center(
                        child: Text(
                          'Follow',
                          maxLines: 1,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 10, left: 10, top: 20),
              child: Text(
                'Similar Quotes',
                style: TextStyle(color: Colors.white, fontSize: 23),
              ),
            ),
            StaggeredGridTemplete(listTile: listTile)
          ],
        ),
      )),
    );
  }
}
