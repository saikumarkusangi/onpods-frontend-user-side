import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/route_manager.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:onpods/utils/colors.dart';
import 'package:onpods/utils/images.dart';
import 'package:palette_generator/palette_generator.dart';
import '../../models/audio_model.dart';
import 'package:rxdart/rxdart.dart';

class Episode {
  final String audioUrl;
  final String title;
  final String album;
  final String artist;
  final String artUri;

  Episode({
    required this.audioUrl,
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

class PlayerScreen extends StatefulWidget {
  final String poster;
  final String title;
  final String episode;
  final String audioUrl;
  final List playlist;

  const PlayerScreen({
    Key? key,
    required this.poster,
    required this.title,
    required this.episode,
    required this.playlist,
    required this.audioUrl,
  }) : super(key: key);

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  PaletteGenerator? _paletteGenerator =
      PaletteGenerator.fromColors([PaletteColor(Colors.transparent, 1)]);

  late AudioPlayer _player;

  @override
  void initState() {
    super.initState();
    generatePalette();

    _player = AudioPlayer();
    _init();
  }

  Future<void> generatePalette() async {
    final provider = NetworkImage(widget.poster);
    Future.delayed(const Duration(milliseconds: 600), () async {
      _paletteGenerator = await PaletteGenerator.fromImageProvider(provider);
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _player.dispose();
  }

  Future<void> _init() async {
    final playList = ConcatenatingAudioSource(
      children: widget.playlist.map((e) {
        return AudioSource.uri(
          Uri.parse(e.songUrl),
          tag: MediaItem(
            id: '1', // Use a unique ID for each episode
            album: widget.title,
            title: e.title,
            artist: '',
            artUri: Uri.parse(widget.poster),
          ),
        );
      }).toList(),
    );


   
    print('@@@@@@@@@@@@@@@@@@@@@@@@@@@${_player.currentIndex}');
    final currentMediaItem = playList.sequence[_player.currentIndex ?? 0];

// Get the title from the current MediaItem's tag
    final currentAudioTitle = currentMediaItem.tag.title ?? "Unknown Title";

    // Create an AudioModel and set it as the currently playing audio
    final currentAudio = AudioModel(
      title: currentAudioTitle,
      artist: "Your Artist Name",
      playbackState: _player.processingState,
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
                          delay: const Duration(milliseconds: 1400),
                          begin: 100,
                        ),
                  ),
                );
              }),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 60),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: CachedNetworkImage(
                  imageUrl: widget.poster,
                  width: MediaQuery.of(context).size.width * 0.7,
                ),
              ),
            ),
          ).animate().rotate(duration: const Duration(milliseconds: 300)),
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
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  StreamBuilder<SequenceState?>(
                      stream: _player.sequenceStateStream,
                      builder: (context, snapshot) {
                        final state = snapshot.data;
                        if (state?.sequence.isEmpty ?? true) {
                          return const SizedBox();
                        }
                        final metadata = state!.currentSource!.tag as MediaItem;
                        return Text(
                          metadata.title,
                          maxLines: 2,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                              overflow: TextOverflow.ellipsis),
                        );
                      }),
                  const SizedBox(
                    height: 30,
                  ),
                  StreamBuilder<PositionData>(
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
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          iconSize: 48,
                          onPressed: () => _player.seekToPrevious(),
                          icon: const Icon(
                            Icons.skip_previous,
                            color: Colors.white,
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
                                    size: 48,
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
                                    size: 48,
                                  ));
                            }
                            return const Icon(
                              Icons.play_arrow_rounded,
                              color: Colors.white,
                              size: 48,
                            );
                          },
                        ),
                        IconButton(
                          iconSize: 48,
                          onPressed: () => _player.seekToNext(),
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
            ),
          )
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
