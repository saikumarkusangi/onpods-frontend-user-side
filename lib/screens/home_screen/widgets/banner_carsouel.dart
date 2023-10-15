
import 'package:onpods/utils/exports.dart';


class BannerCarsouel extends StatefulWidget {
  const BannerCarsouel({super.key});

  @override
  State<BannerCarsouel> createState() => _BannerCarsouelState();
}

class _BannerCarsouelState extends State<BannerCarsouel> {
  final List data = [
    {
      "title": "You Feeling This",
      'des':
          'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.',
      "image": "https://m.media-amazon.com/images/I/513kSILW8TL._SL500_.jpg",
    },
    {
      "title": "Every Saturday",
      "image":
          "https://i.pinimg.com/564x/0b/57/33/0b5733691ea06af397291ffcd4277ddd.jpg",
      'des':
          'Lorem Ipsum is simply dummy text of the printing and typesetting industry. '
    },
    {
      "image":
          "https://i.pinimg.com/564x/75/a5/e1/75a5e13176189eaa14f9c930d605d3d3.jpg",
      "title": "All in the spotlight",
      "des":
          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book."
    },
    {
      "title": "Campus Diaries",
      "image":
          "https://i.pinimg.com/564x/4e/3f/c3/4e3fc3933b9cc7cce894778655e22bb1.jpg",
      "des":
          "Lorem Ipsum is simply dummy text of the printing and typesetting industry."
    },
    {
      "title": "The Mantawauk Caves",
      "des": "This is a different description for The Mantawauk Caves.",
      "image":
          "https://media-prod.fangoria.com/images/TheMantawaukCaves-Logo-FINAL3000x3000.width-800.jpg"
    },
    {
      "title": "Stuff You Should Know",
      "des":
          "Stuff You Should Know is a podcast that educates you on various topics.",
      "image":
          'https://upload.wikimedia.org/wikipedia/en/9/94/StuffYouShouldKnow.jpg',
    },
    {
      "title": "Sieu lua sieu lay",
      "des":
          "Stuff You Should Know is a podcast that educates you on various topics.",
      "image":
          'https://i.pinimg.com/564x/f7/0a/7a/f70a7a59ef85b00ee6ed489e47711a26.jpg',
    },
  ];

  ValueNotifier<int> currentIndexNotifier = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: MediaQuery.of(context).size.height * 0.6,
            autoPlay: true,
            autoPlayCurve: Curves.linear,
            enableInfiniteScroll: true,
            viewportFraction: 1,
            autoPlayAnimationDuration: const Duration(microseconds: 10),
            onPageChanged: (index, reason) {
              currentIndexNotifier.value = index;
            },
          ),
          items: data.map((e) {
            return _buildCarouselItem(e);
          }).toList(),
        ),
        _buildDotIndicators(),
      ],
    );
  }

  Widget _buildCarouselItem(Map<String, String> itemData) {
    return Stack(
      children: [
        CachedNetworkImage(
          fit: BoxFit.cover,
          width: double.maxFinite,
          height: double.maxFinite,
          errorWidget: (context, url, error) => Padding(
            padding: const EdgeInsets.all(60.0),
            child: Image.asset(
              podcastPlaceHolder,
              scale: 3,
            ),
          ),
          imageUrl: itemData['image']!,
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
                Colors.black.withOpacity(0.9),
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
                itemData['title']!,
                2,
                const TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  overflow: TextOverflow.ellipsis,
                )),
            _buildAnimatedText(
                itemData['des']!,
                3,
                TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade400,
                  overflow: TextOverflow.ellipsis,
                )),
            _buildButtonRow(),
          ],
        ),
      ],
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

  Widget _buildButtonRow() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {},
            child: const Column(
              children: [
                Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 30,
                ),
                Text(
                  'WishList',
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
          ),
          const SizedBox(width: 20),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(
              Icons.play_arrow,
              size: 24.0,
              color: Colors.black,
            ),
            label: const Text(
              'Play',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(width: 20),
          const Column(
            children: [
              Icon(
                Icons.share,
                color: Colors.white,
                size: 26,
              ),
              Text(
                'Share',
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
        ],
      ),
    ).animate().fadeIn(
        duration: const Duration(milliseconds: 800),
        delay: const Duration(milliseconds: 1000));
  }

  Widget _buildDotIndicators() {
    return ValueListenableBuilder<int>(
        valueListenable: currentIndexNotifier,
        builder: (context, currentIndex, _) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: data.map((e) {
              int index = data.indexOf(e);
              return Container(
                width: 8.0,
                height: 8.0,
                margin:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: currentIndexNotifier.value == index
                      ? Colors.white
                      : Colors.grey.shade800,
                ),
              );
            }).toList(),
          );
        });
  }
}
