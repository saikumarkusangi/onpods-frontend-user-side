import 'package:flutter_hud/flutter_hud.dart';
import 'package:onpods/utils/exports.dart';

class RateDialog extends StatefulWidget {
  final String podcastTitle;
  final String podcastImageUrl;
  final Color color;
  final String id;
  final String title;

  const RateDialog({
    super.key,
    required this.podcastTitle,
    required this.podcastImageUrl,
    required this.color,
    required this.id,
    required this.title,
  });

  @override
  _RateDialogState createState() => _RateDialogState();
}

class _RateDialogState extends State<RateDialog> {
  ValueNotifier<double> rating = ValueNotifier<double>(0.0);
  bool isloading = false;

  @override
  Widget build(BuildContext context) {
    return WidgetHUD(
      showHUD: isloading,
      hud: HUD(
          progressIndicator: Image.asset(
        liveGif,
        color: blueColor,
        scale: 3,
      )),
      builder: (context, child) => Scaffold(
        body: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    widget.color.withOpacity(0.8),
                    widget.color.withOpacity(0.4),
                    widget.color.withOpacity(0.2),
                    widget.color.withOpacity(0.1),
                    Colors.transparent,
                    darkscaffoldBackgroundColor
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(left: 10, top: 30),
                child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 34.sp,
                    )),
              ),
            ),
            Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: ValueListenableBuilder<double>(
                    valueListenable: rating,
                    builder: (context, value, child) {
                      String imageUrl = '';

                      if (value > 0) {
                        if (value < 2) {
                          imageUrl =
                              'https://emojiisland.com/cdn/shop/products/Emoji_Icon_-_Sad_Emoji_large.png?v=1571606093';
                        } else if (value >= 2 && value < 3) {
                          imageUrl =
                              'https://emojiisland.com/cdn/shop/products/Slightly_Smiling_Emoji_Icon_34f238ed-d557-4161-b966-779d8f37b1ac_large.png?v=1571606093';
                        } else if (value >= 3 && value <= 4) {
                          imageUrl =
                              'https://emojiisland.com/cdn/shop/products/Smliing_Emoji_Icon_688b57c3-ccff-4619-b1ac-a0e6edf7b665_large.png?v=1571606114';
                        } else if (value >= 4.5) {
                          imageUrl =
                              'https://emojiisland.com/cdn/shop/products/Happy_Emoji_Icon_5c9b7b25-b215-4457-922d-fef519a08b06_large.png?v=1571606090';
                        }
                        return Image.network(
                          imageUrl,
                          scale: 6,
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                )),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.only(top: 0.2.sh),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        widget.podcastImageUrl,
                        height: 0.2.sh,
                        width: 0.2.sh,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 10),
                      child: Text(
                        widget.podcastTitle,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 10),
                        child: RichText(
                          text: TextSpan(
                            text: 'How was the ${widget.title} ?',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22.sp,
                            ),
                          ),
                        )),
                    const SizedBox(height: 16),
                    RatingBar.builder(
                      glow: true,
                      ignoreGestures: false,
                      updateOnDrag: true,
                      itemSize: 52.sp,
                      initialRating: 0,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      unratedColor: Colors.white.withOpacity(0.3),
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rate) {
                        rating.value = rate;
                      },
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: CustomElevatedButton(
                    onTap: () async => {
                          setState(() {
                            isloading = true;
                          }),
                          await PodcastService()
                              .ratePodcast(widget.id, rating.value)
                              .whenComplete(() => Navigator.pop(context))
                        },
                    buttonColor: blueColor,
                    buttonTextStyle:
                        TextStyle(color: Colors.white, fontSize: 22.sp),
                    text: 'Submit'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
