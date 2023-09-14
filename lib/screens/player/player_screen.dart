import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:palette_generator/palette_generator.dart';

import '../../utils/utils_exports.dart';

class PlayerScreen extends StatefulWidget {
  final String poster;
  final String title;
  final String episode;
  final String audioUrl;

  const PlayerScreen({
    Key? key,
    required this.poster,
    required this.title,
    required this.episode,
    required this.audioUrl,
  }) : super(key: key);

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  PaletteGenerator? _paletteGenerator =
      PaletteGenerator.fromColors([PaletteColor(Colors.transparent, 1)]);
  final AudioPlayer player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    generatePalette();
    play();
  }

  Future<void> generatePalette() async {
    final provider = NetworkImage(widget.poster);
    Future.delayed(const Duration(milliseconds: 600), () async {
      _paletteGenerator = await PaletteGenerator.fromImageProvider(provider);
      setState(() {});
    });
  }

  Future<void> play() async {
    AudioSource.uri(
      Uri.parse(widget.audioUrl),
      tag: MediaItem(
        id: '1',
        album: widget.title,
        title: widget.episode,
        artUri: Uri.parse(widget.poster),
      ),
    );
    player.play();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.maxFinite,
            height: double.maxFinite,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _paletteGenerator?.dominantColor?.color.withOpacity(1) ??
                      Colors.transparent,
                  scaffoldBackgroundColor,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ).animate().fadeIn(delay: const Duration(milliseconds: 800)),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.18,
            left: MediaQuery.of(context).size.width * 0.15,
            child: Image.asset(
              cdGif,
              width: MediaQuery.of(context).size.width * 0.7,
            ),
          ).animate().moveY(
                delay: const Duration(milliseconds: 1400),
                begin: 130,
              ),
          Align(
            alignment: Alignment.center,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: CachedNetworkImage(
                imageUrl: widget.poster,
                width: MediaQuery.of(context).size.width * 0.8,
              ),
            ),
          ).animate().rotate(duration: const Duration(milliseconds: 500)),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 150),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Text(
                  widget.episode,
                  maxLines: 2,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 50,
            left: 15,
            child: CircleAvatar(
              backgroundColor: Colors.black45,
              radius: 25,
              child: IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                ),
              ),
            ),
          ).animate().fadeIn(delay: const Duration(milliseconds: 500)),
          Positioned(
            top: 50,
            right: 15,
            child: CircleAvatar(
              backgroundColor: Colors.black45,
              radius: 25,
              child: IconButton(
                onPressed: () {
                  _showBottomSheet();
                },
                icon: const Icon(
                  Icons.more_vert,
                  color: Colors.white,
                ),
              ),
            ),
          ).animate().fadeIn(delay: const Duration(milliseconds: 500)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 70),
            child: Align(
              alignment: Alignment.center,
              heightFactor: 6,
              child: Text(
                widget.title,
                maxLines: 1,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ).animate().fadeIn(delay: const Duration(milliseconds: 500)),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
                padding:
                    const EdgeInsets.only(bottom: 100, left: 20, right: 20),
                child: StreamBuilder<Duration?>(
                  stream: player.durationStream,
                  builder: (context, snapshot) {
                    final duration =
                        snapshot.data ?? const Duration(seconds: 0);
                    return ProgressBar(
                      timeLabelTextStyle: const TextStyle(color: Colors.white),
                      thumbGlowColor: Colors.white,
                      thumbColor: Colors.white,
                      bufferedBarColor: Colors.grey.shade600,
                      progressBarColor: Colors.white,
                      baseBarColor: Colors.white10,
                      thumbRadius: 6,
                      thumbGlowRadius: 8,
                      progress: player.position,
                      buffered: const Duration(milliseconds: 2000),
                      total: duration,
                      onSeek: (duration) {},
                    );
                  },
                )),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            heightFactor: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  iconSize: 48,
                  onPressed: () {},
                  icon: const Icon(
                    Icons.skip_previous,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  iconSize: 58,
                  onPressed: () {
                    if (player.playing) {
                      player.pause();
                    } else {
                      play();
                    }
                    setState(() {});
                  },
                  icon: Icon(
                    player.playing ? Icons.pause : Icons.play_arrow_rounded,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  iconSize: 48,
                  onPressed: () {},
                  icon: const Icon(
                    Icons.skip_next_sharp,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      backgroundColor: scaffoldBackgroundColor,
      context: context,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.2,
        maxChildSize: 1.0,
        builder: (context, controller) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('Your Bottom Sheet Content'),
            ],
          );
        },
      ),
    );
  }
}
