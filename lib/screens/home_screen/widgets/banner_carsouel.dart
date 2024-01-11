import 'dart:io';
import 'package:onpods/utils/dynamic_links.dart';
import 'package:onpods/utils/exports.dart';

class BannerCarsouel extends StatefulWidget {
  const BannerCarsouel({super.key});

  @override
  State<BannerCarsouel> createState() => _BannerCarsouelState();
}

class _BannerCarsouelState extends State<BannerCarsouel> {
  ValueNotifier<int> currentIndexNotifier = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    final podcastProvider = Provider.of<PodcastProvider>(context);
    return Column(
      children: [
        podcastProvider.suggestpodcasts.isEmpty
            ? Column(
                children: [
                  const SizedBox(
                    height: 100,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(50),
                    child: Image.asset(
                      podcastPlaceHolder,
                      scale: 3,
                    ),
                  ),
                  Shimmer.fromColors(
                      baseColor: const Color(0xff19232F),
                      highlightColor: const Color.fromARGB(255, 43, 52, 64),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: 180,
                              height: 24,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: 150,
                              height: 15,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          Container(
                            width: 200,
                            height: 15,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey,
                            ),
                          )
                        ],
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Icon(
                              color: Colors.white,
                              size: 26.sp,
                              Icons.bookmark_outline,
                            ),
                            Text(
                              'My List',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 16.sp),
                            ),
                          ],
                        ),
                        const SizedBox(width: 20),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: ElevatedButton.icon(
                            onPressed: () {},
                            icon: Icon(
                              Icons.play_arrow,
                              size: 28.sp,
                              color: Colors.black,
                            ),
                            label: Text(
                              'Play',
                              style: TextStyle(
                                  color: Colors.black, fontSize: 16.sp),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Column(
                          children: [
                            Icon(
                              Icons.share,
                              color: Colors.white,
                              size: 26.sp,
                            ),
                            Text(
                              'Share',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 16.sp),
                            )
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              )
            : CarouselSlider(
                options: CarouselOptions(
                  height: 0.6.sh,
                  autoPlay: true,
                  autoPlayCurve: Curves.linear,
                  enableInfiniteScroll: true,
                  viewportFraction: 1,
                  autoPlayAnimationDuration: const Duration(microseconds: 10),
                  onPageChanged: (index, reason) {
                    currentIndexNotifier.value = index;
                  },
                ),
                items: podcastProvider.suggestpodcasts.map((e) {
                  return _buildCarouselItem(e);
                }).toList(),
              ),
        ValueListenableBuilder<int>(
          valueListenable: currentIndexNotifier,
          builder: (context, currentIndex, _) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(podcastProvider.suggestpodcasts.length,
                  (index) {
                return Container(
                  width: 20.0,
                  height: 4.0,
                  margin: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 2.0),
                  decoration: BoxDecoration(
                    color: currentIndex == index
                        ? Colors.white
                        : Colors.grey.shade800,
                  ),
                );
              }),
            );
          },
        )
      ],
    );
  }

  Widget _buildCarouselItem(itemData) {
    final ValueNotifier<bool> listed =
        ValueNotifier<bool>(itemData.addedToMyList ?? false);

    return GestureDetector(
      onTap: () {
        Get.to(
            DetailedPodcast(
              podcastId: itemData.id,
              image: itemData.posterUrl,
              title: itemData.title,
              description: itemData.description,
            ),
            transition: Transition.downToUp);
      },
      child: Stack(
        children: [
          CachedNetworkImage(
            fit: BoxFit.cover,
            width: double.maxFinite,
            height: 0.598.sh,
            errorWidget: (context, url, error) => Padding(
              padding: const EdgeInsets.all(60.0),
              child: Image.asset(
                podcastPlaceHolder,
                scale: 3,
              ),
            ),
            imageUrl: itemData.posterUrl,
          ).animate().fadeIn(
              duration: const Duration(
                milliseconds: 800,
              ),
              delay: const Duration(milliseconds: 100)),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.center,
                colors: [
                  Colors.black.withOpacity(0.96),
                  Colors.black.withOpacity(0.6),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildAnimatedText(
                  itemData.title,
                  2,
                  TextStyle(
                    fontSize: 28.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    overflow: TextOverflow.ellipsis,
                  )),
              _buildAnimatedText(
                  itemData.description,
                  3,
                  TextStyle(
                    fontSize: 16.sp,
                    color: Colors.grey.shade400,
                    overflow: TextOverflow.ellipsis,
                  )),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ValueListenableBuilder(
                      valueListenable: listed,
                      builder: (context, value, child) {
                        return GestureDetector(
                          onTap: () async {
                            if (listed.value) {
                              await UserServices()
                                  .updateMyList([itemData.id], 'remove');
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  duration: Duration(milliseconds: 500),
                                  content: Text('Removed from your List'),
                                ),
                              );
                              listed.value = false;
                            } else {
                              await UserServices()
                                  .updateMyList([itemData.id], 'add');
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  duration: Duration(milliseconds: 500),
                                  content: Text('Added to your List'),
                                ),
                              );
                              listed.value = true;
                            }
                          },
                          child: Column(
                            children: [
                              Icon(
                                color: Colors.white,
                                size: 32.sp,
                                listed.value
                                    ? Icons.bookmark
                                    : Icons.bookmark_outline,
                              ),
                              Text(
                                'My List',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18.sp),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 20),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Get.to(
                              DetailedPodcast(
                                podcastId: itemData.id,
                                image: itemData.posterUrl,
                                title: itemData.title,
                                description: itemData.description,
                              ),
                              transition: Transition.downToUp);
                        },
                        icon: Icon(
                          Icons.play_arrow,
                          size: 32.sp,
                          color: Colors.black,
                        ),
                        label: Text(
                          'Play',
                          style:
                              TextStyle(color: Colors.black, fontSize: 18.sp),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    GestureDetector(
                      onTap: () async {
                        DynamicLinkProvider()
                            .createLink(itemData.title)
                            .then((value) async {
                          final podcastTitle = itemData.title;
                          final podcastDescription = itemData.description;
                          final podcastUrl = value;
                          // final limitedDescription =
                          //     LineSplitter.split(podcastDescription).take(2).join('');
                          final text =
                              '🎧 Check out this amazing podcast: "$podcastTitle" 🎙️\n\n🔗 $podcastUrl';

                          final imageUrl = itemData.posterUrl;
                          final bytes =
                              await NetworkAssetBundle(Uri.parse(imageUrl))
                                  .load(imageUrl);

                          final tempDir = await getTemporaryDirectory();
                          final tempFile =
                              File('${tempDir.path}/temp_image.jpg');
                          await tempFile
                              .writeAsBytes(bytes.buffer.asUint8List());

                          await Share.shareFiles(
                            [tempFile.path],
                            text: text,
                            subject: 'Share Podcast',
                          );
                        });
                      },
                      child: Column(
                        children: [
                          Icon(
                            Icons.share,
                            color: Colors.white,
                            size: 30.sp,
                          ),
                          Text(
                            'Share',
                            style:
                                TextStyle(color: Colors.white, fontSize: 18.sp),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(
                  duration: const Duration(milliseconds: 800),
                  delay: const Duration(milliseconds: 1000))
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedText(
      String text, int delayInMilliseconds, TextStyle style) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: Text(
        text,
        maxLines: 2,
        textAlign: TextAlign.center,
        style: style,
      ).animate().fadeIn(
            duration: const Duration(milliseconds: 800),
            delay: Duration(milliseconds: 300 * delayInMilliseconds),
          ),
    );
  }
}
