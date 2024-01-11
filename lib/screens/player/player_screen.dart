import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/route_manager.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:onpods/resources/podcast_service.dart';
import 'package:onpods/utils/colors.dart';
import 'package:onpods/utils/images.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:provider/provider.dart';
import 'package:marquee/marquee.dart';
import '../../providers/mini_player_provider.dart';

class Episode {
  final String audioUrl;
  final String title;
  final String album;
  final String artist;
  final String artUri;
  final int startingIndex;

  Episode({
    required this.audioUrl,
    required this.startingIndex,
    required this.title,
    required this.album,
    required this.artist,
    required this.artUri,
  });
}

class PlayerScreen extends StatefulWidget {
  final String poster;
  final String title;
  final String episode;
  final String audioUrl;
  final List playlist;
  final int startingIndex;
  final String albumImage;
  final String podcastId;
  final String episodeId;

  const PlayerScreen({
    Key? key,
    required this.poster,
    required this.title,
    required this.episode,
    required this.playlist,
    required this.audioUrl,
    required this.startingIndex,
    required this.albumImage,
    required this.podcastId,
    required this.episodeId,
  }) : super(key: key);

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  PaletteGenerator? _paletteGenerator =
      PaletteGenerator.fromColors([PaletteColor(Colors.transparent, 1)]);

  // late AudioPlayer _player;

  @override
  void initState() {
    super.initState();
    generatePalette();

    // _player = AudioPlayer();

    _init();
    callApi();
  }

  Future<void> generatePalette() async {
    final provider = NetworkImage(widget.poster);
    Future.delayed(const Duration(milliseconds: 600), () async {
      _paletteGenerator = await PaletteGenerator.fromImageProvider(provider);
      setState(() {});
    });
  }

  callApi() {
    PodcastService().listenEpisode(widget.podcastId, widget.episodeId);
  }

  @override
  void dispose() {
    super.dispose();
    // _player.dispose();
  }

  List rearrangePlaylist(List playlist, int startingIndex) {
    return [
      ...playlist.sublist(startingIndex),
      ...playlist.sublist(0, startingIndex),
    ];
  }

  Future<void> _init() async {
    final provider = Provider.of<MiniPlayerProvider>(context, listen: false);
    // provider.clearEpisodes();
    final rearrangedPlaylist =
        rearrangePlaylist(widget.playlist, widget.startingIndex);
    print('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');

    try {
      provider.update(
          rearrangedPlaylist[0].title,
          rearrangedPlaylist[0].posterUrl != ''
              ? rearrangedPlaylist[0].posterUrl
              : widget.albumImage,
          rearrangedPlaylist);
    } catch (e) {
      provider.update(
          rearrangedPlaylist[0]['title'],
          rearrangedPlaylist[0]['posterUrl'] != ''
              ? rearrangedPlaylist[0]['posterUrl']
              : widget.albumImage,
          rearrangedPlaylist);
    }
    print('######################################################');
    print(widget.episodeId);
    print(provider.podcastId);
    if (widget.episodeId != provider.podcastId) {
      provider.play();
      provider.updateId(widget.episodeId);
    } else {
      // provider.updateId(widget.episodeId);
    }

    //   StreamBuilder<SequenceState?>(
    //       stream: provider.player.sequenceStateStream,
    //       builder: (context, snapshot) {
    //         final state = snapshot.data;
    //         if (state?.sequence.isEmpty ?? true) {
    //           return const SizedBox();
    //         }
    //         final metadata = state!.currentSource!.tag as MediaItem;
    //         if (metadata.id == provider.podcastId) {
    //              provider.play();
    //         } else {
    //           provider.clearEpisodes();
    //           provider.play();
    //         }
    //         return const SizedBox();
    //       });
    // }
  }

  @override
  Widget build(BuildContext context) {
    final miniPlayerProvider = Provider.of<MiniPlayerProvider>(context);

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
                  darkscaffoldBackgroundColor,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ).animate().fadeIn(delay: const Duration(milliseconds: 800)),
          StreamBuilder<PlayerState>(
              stream: miniPlayerProvider.player.playerStateStream,
              builder: (context, snapshot) {
                final playerState = snapshot.data;
                final playing = playerState?.playing;
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 250),
                    child: Image.asset(
                      playing! ? cdGif : cdGifPng,
                      width: MediaQuery.of(context).size.width * 0.6,
                    ).animate().moveY(
                          delay: const Duration(milliseconds: 800),
                          begin: 100,
                        ),
                  ),
                );
              }),
          StreamBuilder<SequenceState?>(
              stream: miniPlayerProvider.player.sequenceStateStream,
              builder: (context, snapshot) {
                final state = snapshot.data;
                if (state?.sequence.isEmpty ?? true) {
                  return const SizedBox();
                }
                final metadata = state!.currentSource!.tag as MediaItem;

                return Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 60),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: CachedNetworkImage(
                        imageUrl: metadata.artUri.toString().isNotEmpty
                            ? metadata.artUri.toString()
                            : widget.poster,
                        width: MediaQuery.of(context).size.width * 0.7,
                        height: MediaQuery.of(context).size.height * 0.3,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) => Container(
                          padding: const EdgeInsets.all(30),
                          color: const Color.fromARGB(255, 40, 37, 37),
                          child: Image.asset(splashLogo, fit: BoxFit.contain),
                        ),
                      ),
                    ),
                  ),
                ).animate().rotate(duration: const Duration(milliseconds: 300));
              }),
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
              heightFactor: 5.5,
              child: Text(
                widget.title,
                maxLines: 1,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 6 * MediaQuery.of(context).devicePixelRatio,
                  fontWeight: FontWeight.w800,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ).animate().fadeIn(delay: const Duration(milliseconds: 500)),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: StreamBuilder<SequenceState?>(
                        stream: miniPlayerProvider.player.sequenceStateStream,
                        builder: (context, snapshot) {
                          final state = snapshot.data;
                          if (state?.sequence.isEmpty ?? true) {
                            return const SizedBox();
                          }
                          final metadata =
                              state!.currentSource!.tag as MediaItem;
                          return SizedBox(
                            height: 40,
                            width: MediaQuery.of(context).size.width,
                            child: Marquee(
                              text: metadata.title,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize:
                                    7 * MediaQuery.of(context).devicePixelRatio,
                              ),
                              scrollAxis: Axis.horizontal,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              blankSpace: 100.0,
                              velocity: 50.0,
                              pauseAfterRound: const Duration(seconds: 1),
                              startPadding: 10.0,
                              accelerationDuration: const Duration(seconds: 1),
                              accelerationCurve: Curves.linear,
                              decelerationDuration:
                                  const Duration(milliseconds: 500),
                              decelerationCurve: Curves.easeOut,
                            ),
                          );
                        }),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: StreamBuilder<PositionData>(
                        stream: miniPlayerProvider.positionDataStream,
                        builder: (context, snapshot) {
                          final positionData = snapshot.data;
                          return ProgressBar(
                            timeLabelPadding: 12,
                            timeLabelTextStyle:
                                const TextStyle(color: Colors.white),
                            thumbGlowColor: Colors.white,
                            thumbColor: Colors.white,
                            bufferedBarColor: Colors.grey.shade600,
                            progressBarColor: Colors.white,
                            baseBarColor: Colors.white10,
                            thumbRadius: 6,
                            thumbGlowRadius: 8,
                            progress: positionData?.position ?? Duration.zero,
                            buffered:
                                positionData?.bufferPosition ?? Duration.zero,
                            total: positionData?.duration ?? Duration.zero,
                            onSeek: miniPlayerProvider.player.seek,
                          );
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20, top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          onPressed: () {
                            if (miniPlayerProvider.player.position >
                                Duration.zero) {
                              Duration newPosition =
                                  miniPlayerProvider.player.position -
                                      const Duration(seconds: 10);

                              newPosition = newPosition.isNegative
                                  ? Duration.zero
                                  : newPosition;

                              // Perform the seek
                              miniPlayerProvider.player.seek(newPosition);
                            }
                          },
                          icon: const Icon(
                            Icons.replay_10,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            if (!miniPlayerProvider.player.hasPrevious) {
                              miniPlayerProvider.player.seek(Duration.zero,
                                  index: widget.playlist.length - 1);
                              //  ScaffoldMessenger.of(context).showSnackBar(
                              //   const SnackBar(
                              //     duration: Duration(milliseconds: 1000),
                              //     content: Text(
                              //         'You are listening to the first episode.'),
                              //   ),
                              // );
                            }

                            miniPlayerProvider.player.seekToPrevious();
                          },
                          icon: const Icon(
                            Icons.skip_previous,
                            color: Colors.white,
                            size: 52,
                          ),
                        ),
                        StreamBuilder<PlayerState>(
                          stream: miniPlayerProvider.player.playerStateStream,
                          builder: (context, snapshot) {
                            final playerState = snapshot.data;
                            final processingState =
                                playerState?.processingState;
                            final playing = playerState?.playing;

                            if (!(playing ?? false)) {
                              return IconButton(
                                  onPressed: () {
                                    miniPlayerProvider.player.play();
                                  },
                                  icon: const Icon(
                                    Icons.play_arrow_rounded,
                                    color: Colors.white,
                                    size: 52,
                                  ));
                            } else if (processingState !=
                                ProcessingState.completed) {
                              return IconButton(
                                  onPressed: () {
                                    miniPlayerProvider.player.pause();
                                  },
                                  icon: const Icon(
                                    Icons.pause,
                                    color: Colors.white,
                                    size: 52,
                                  ));
                            }
                            return const Icon(
                              Icons.play_arrow_rounded,
                              color: Colors.white,
                              size: 52,
                            );
                          },
                        ),
                        IconButton(
                          onPressed: () {
                            if (!miniPlayerProvider.player.hasNext) {
                              miniPlayerProvider.player
                                  .seek(Duration.zero, index: 0);
                              // ScaffoldMessenger.of(context).showSnackBar(
                              //   const SnackBar(
                              //     duration: Duration(milliseconds: 1000),
                              //     content: Text(
                              //         'You are listening to the last episode.'),
                              //   ),
                              // );
                            }
                            miniPlayerProvider.player.seekToNext();
                            miniPlayerProvider.updateId(
                                miniPlayerProvider.episodes[
                                    miniPlayerProvider.player.currentIndex!]['id']);
                          },
                          icon: const Icon(
                            Icons.skip_next_sharp,
                            color: Colors.white,
                            size: 52,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            miniPlayerProvider.player.seek(
                                miniPlayerProvider.player.position +
                                    const Duration(seconds: 10));
                          },
                          icon: const Icon(
                            Icons.forward_10,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      backgroundColor: Colors.black,
      context: context,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.2,
        maxChildSize: 1.0,
        builder: (context, controller) {
          return const Column(
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
