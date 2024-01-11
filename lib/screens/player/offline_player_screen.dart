import 'dart:io';
import 'dart:math';

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
import '../../models/audio_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:marquee/marquee.dart';

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

class PositionData {
  const PositionData(this.position, this.bufferPosition, this.duration);
  final Duration position;
  final Duration bufferPosition;
  final Duration duration;
}

class OfflinePlayerScreen extends StatefulWidget {
  final String poster;
  final String title;
  final String episode;
  final String audioUrl;
  final List playlist;
  final int startingIndex;
  final String albumImage;
  final String podcastId;
  final String episodeId;

  const OfflinePlayerScreen({
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
  State<OfflinePlayerScreen> createState() => _OfflinePlayerScreenState();
}

class _OfflinePlayerScreenState extends State<OfflinePlayerScreen> {
  PaletteGenerator? _paletteGenerator =
      PaletteGenerator.fromColors([PaletteColor(Colors.transparent, 1)]);

  late AudioPlayer _player;

  @override
  void initState() {
    super.initState();
    generatePalette();

    _player = AudioPlayer();
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
    _player.dispose();
  }

  List rearrangePlaylist(List playlist, int startingIndex) {
    return [
      ...playlist.sublist(startingIndex),
      ...playlist.sublist(0, startingIndex),
    ];
  }

  Future<void> _init() async {
    final rearrangedPlaylist =
        rearrangePlaylist(widget.playlist, widget.startingIndex);
    
    final playList = ConcatenatingAudioSource(
      children: rearrangedPlaylist.map((e) {
        return AudioSource.uri(
          Uri.parse(e.audioUrl),
          tag: MediaItem(
            id: e.title,
            album: widget.title,
            title: e.title,
            artist: '',
            artUri: Uri.parse(e.posterUrl ?? widget.albumImage),
          ),
        );
      }).toList(),
    );

    // Use the provider to set the current audio

    await _player.setAudioSource(playList);
    _player.play();
  }

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          _player.positionStream,
          _player.bufferedPositionStream,
          _player.durationStream,
          (position, bufferPosition, duration) => PositionData(
              position, bufferPosition, duration ?? Duration.zero));

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
                  darkscaffoldBackgroundColor,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ).animate().fadeIn(delay: const Duration(milliseconds: 800)),
          StreamBuilder<PlayerState>(
              stream: _player.playerStateStream,
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
         
         Padding(
                  padding: const EdgeInsets.only(bottom: 60),
                  child: Align(
                          alignment: Alignment.center,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: Image.file(
                                File(widget.poster),
                                width: MediaQuery.of(context).size.width * 0.7,
                                height: 240,
                                fit: BoxFit.cover,
                              )))
                      .animate()
                      .rotate(duration: const Duration(milliseconds: 300)),
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
              padding: const EdgeInsets.symmetric(vertical: 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: StreamBuilder<SequenceState?>(
                        stream: _player.sequenceStateStream,
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
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 20,
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
                        stream: _positionDataStream,
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
                            onSeek: _player.seek,
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
                            if (_player.position > Duration.zero) {
                              Duration newPosition = _player.position -
                                  const Duration(seconds: 10);

                              newPosition = newPosition.isNegative
                                  ? Duration.zero
                                  : newPosition;

                              // Perform the seek
                              _player.seek(newPosition);
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
                            if (!_player.hasPrevious) {
                              _player.seek(Duration.zero,
                                  index: widget.playlist.length - 1);
                              //  ScaffoldMessenger.of(context).showSnackBar(
                              //   const SnackBar(
                              //     duration: Duration(milliseconds: 1000),
                              //     content: Text(
                              //         'You are listening to the first episode.'),
                              //   ),
                              // );
                            }

                            _player.seekToPrevious();
                          },
                          icon: const Icon(
                            Icons.skip_previous,
                            color: Colors.white,
                            size: 52,
                          ),
                        ),
                        StreamBuilder<PlayerState>(
                          stream: _player.playerStateStream,
                          builder: (context, snapshot) {
                            final playerState = snapshot.data;
                            final processingState =
                                playerState?.processingState;
                            final playing = playerState?.playing;

                            if (!(playing ?? false)) {
                              return IconButton(
                                  onPressed: () {
                                    _player.play();
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
                                    _player.pause();
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
                            if (!_player.hasNext) {
                              _player.seek(Duration.zero, index: 0);
                              // ScaffoldMessenger.of(context).showSnackBar(
                              //   const SnackBar(
                              //     duration: Duration(milliseconds: 1000),
                              //     content: Text(
                              //         'You are listening to the last episode.'),
                              //   ),
                              // );
                            }
                            _player.seekToNext();
                          },
                          icon: const Icon(
                            Icons.skip_next_sharp,
                            color: Colors.white,
                            size: 52,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            _player.seek(
                                _player.position + const Duration(seconds: 10));
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
