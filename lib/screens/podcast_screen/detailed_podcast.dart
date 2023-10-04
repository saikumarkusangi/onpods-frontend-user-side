import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:provider/provider.dart';
import '../../utils/utils_exports.dart';
import '../../widgets/widgets_exports.dart';
import '../player/player_screen.dart';

class DetailedPodcast extends StatefulWidget {
  final String image;
  final String title;
  final String description;
  final List episodes;
  final double rating;

  const DetailedPodcast({
    Key? key,
    required this.image,
    required this.title,
    required this.description,
    required this.episodes,
    required this.rating,
  }) : super(key: key);

  @override
  State<DetailedPodcast> createState() => _DetailedPodcastState();
}

class _DetailedPodcastState extends State<DetailedPodcast> {
  late String firstHalf;
  late String secondHalf;
  PaletteGenerator? _paletteGenerator =
      PaletteGenerator.fromColors([PaletteColor(Colors.black, 2)]);

  bool flag = true;
  @override
  void initState() {
    generatePalette();
    super.initState();

    if (widget.description.length > 130) {
      firstHalf = widget.description.substring(0, 130);
      secondHalf = widget.description.substring(130, widget.description.length);
    } else {
      firstHalf = widget.description;
      secondHalf = "";
    }
  }

  Future<void> generatePalette() async {
    final provider = NetworkImage(widget.image);
    Future.delayed(const Duration(milliseconds: 250), () async {
      _paletteGenerator = await PaletteGenerator.fromImageProvider(provider);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    var fileDownloaderProvider =
        Provider.of<FileDownloaderProvider>(context, listen: false);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            backgroundColor: _paletteGenerator?.dominantColor?.color,
            expandedHeight: 250,
            leading: IconButton(
              iconSize: 28,
              onPressed: () => Get.back(),
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            ),
            pinned: true,
            snap: false,
            title: Text(
              widget.title,
              style: const TextStyle(
                fontSize: 22,
                color: Colors.white,
                fontWeight: FontWeight.w400,
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  // Image
                  CachedNetworkImage(
                    imageUrl: widget.image,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  // Gradient overlay
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          _paletteGenerator?.dominantColor?.color
                                  .withOpacity(1) ??
                              Colors.transparent,
                          scaffoldBackgroundColor
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 30,
                    left: 20,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: CachedNetworkImage(
                            imageUrl: widget.image,
                            height: 150,
                            width: 0.4.sw,
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                Image.asset(podcastPlaceHolder),
                            errorWidget: (context, url, error) =>
                                Image.asset(podcastPlaceHolder),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.title,
                                maxLines: 3,
                                style: const TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  color: Colors.white,
                                  fontSize: 26,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              RatingBar.builder(
                                glow: false,
                                ignoreGestures: true,
                                updateOnDrag: false,
                                itemSize: 22,
                                initialRating: widget.rating,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemPadding:
                                    const EdgeInsets.symmetric(horizontal: 4.0),
                                itemBuilder: (context, _) => const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                onRatingUpdate: (rating) {},
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 10.0,
                ),
                child: secondHalf.isEmpty
                    ? Text(
                        firstHalf,
                        style: TextStyle(color: Colors.grey.shade400),
                      )
                    : RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: flag
                                  ? ("$firstHalf...")
                                  : (firstHalf + secondHalf),
                              style: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 14,
                              ),
                            ),
                            TextSpan(
                              text: flag ? " show more" : " show less",
                              style: const TextStyle(color: blueColor),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  setState(() {
                                    flag = !flag;
                                  });
                                },
                            ),
                          ],
                        ),
                      ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  'All Episodes',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 18),
                ),
              )
            ]),
          ),
          if (widget.episodes.isEmpty)
            const SliverToBoxAdapter(
              child:EmptyPlaceHiolder(message: 'Episode',)
            )
          else
            SliverList.builder(
                itemCount: widget.episodes.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => Get.to(
                        PlayerScreen(
                            playlist: widget.episodes,
                            audioUrl: widget.episodes[index].songUrl!,
                            episode: widget.episodes[index].title!,
                            poster: widget.image,
                            title: widget.title),
                        transition: Transition.downToUp),
                    child: SizedBox(
                      width: double.maxFinite,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: ListTile(
                              leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: CacheImage(image: widget.image)),
                              title: Text(
                                'Episode ${index + 1}',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800),
                              ),
                              subtitle: Text(
                                widget.episodes[index].title!,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                            child: Text(
                              widget.episodes[index].title,
                              maxLines: 3,
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade400,
                                  overflow: TextOverflow.ellipsis),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.share,
                                        size: 24,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {},
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.download_for_offline,
                                        size: 28,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        fileDownloaderProvider
                                            .downloadFile(
                                                'https://samplelib.com/lib/preview/mp3/sample-3s.mp3r',
                                                "My File.mp3")
                                            .then((onValue) {});
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.play_circle,
                                        size: 28,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {},
                                    ),
                                  ],
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.more_vert,
                                    size: 28,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {},
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Divider(
                              color: Colors.grey.shade700,
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                })
        ],
      ),
    );
  }
}
