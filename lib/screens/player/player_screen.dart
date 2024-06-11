import 'dart:io';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:onpods/providers/local_downloads_provider.dart';
import 'package:onpods/resources/podcast_service.dart';
import 'package:onpods/screens/podcast_screen/widgets/rating_screen.dart';
import 'package:onpods/utils/colors.dart';
import 'package:onpods/utils/dynamic_links.dart';
import 'package:onpods/utils/exports.dart';
import 'package:onpods/utils/images.dart';
import 'package:onpods/utils/notification_service.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:marquee/marquee.dart';
import 'package:share_plus/share_plus.dart';
import '../../providers/mini_player_provider.dart';
import '../../utils/snack_bar.dart';
import '../podcast_screen/edit_page.dart';

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
  final String description;
  final String uploaderId;
  final bool animate;

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
    required this.description,
    required this.uploaderId,
    this.animate = true,
  }) : super(key: key);

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  PaletteGenerator? _paletteGenerator =
      PaletteGenerator.fromColors([PaletteColor(Colors.transparent, 1)]);

  // late AudioPlayer _player;
  late String userId;
  String? currentDownloadId;

  @override
  void initState() {
    super.initState();
    generatePalette();

    // _player = AudioPlayer();

    _init();
    callApi();
    _getUserId();
  }

  _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('user_id')!;
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

  final ValueNotifier<bool> loading = ValueNotifier<bool>(false);
  Future<void> _init() async {
    final provider = Provider.of<MiniPlayerProvider>(context, listen: false);
    // provider.clearEpisodes();
    final rearrangedPlaylist =
        rearrangePlaylist(widget.playlist, widget.startingIndex);
    print('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');

    try {
      provider.update(
          widget.title,
          rearrangedPlaylist[0].title,
          rearrangedPlaylist[0].posterUrl != ''
              ? rearrangedPlaylist[0].posterUrl
              : widget.albumImage,
          rearrangedPlaylist,
          widget.uploaderId,
          widget.description);
    } catch (e) {
      provider.update(
          widget.title,
          rearrangedPlaylist[0]['title'],
          rearrangedPlaylist[0]['posterUrl'] != ''
              ? rearrangedPlaylist[0]['posterUrl']
              : widget.albumImage,
          rearrangedPlaylist,
          widget.uploaderId,
          widget.description);
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
    final localDownloadProvider = Provider.of<LocalDownloadProvider>(context);
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
                    child: widget.animate
                        ? Image.asset(
                            playing! ? cdGif : cdGifPng,
                            width: MediaQuery.of(context).size.width * 0.6,
                          ).animate().moveY(
                              delay: const Duration(milliseconds: 800),
                              begin: 100,
                            )
                        : Image.asset(
                            playing! ? cdGif : cdGifPng,
                            width: MediaQuery.of(context).size.width * 0.6,
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

                return widget.animate
                    ? Align(
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
                                child: Image.asset(splashLogo,
                                    fit: BoxFit.contain),
                              ),
                            ),
                          ),
                        ),
                      ).animate().rotate(
                          duration: const Duration(milliseconds: 300),
                        )
                    : Align(
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
                                child: Image.asset(splashLogo,
                                    fit: BoxFit.contain),
                              ),
                            ),
                          ),
                        ),
                      ).animate();
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
                            miniPlayerProvider.updateId(miniPlayerProvider
                                    .episodes[
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
    final localDownloadProvider =
        Provider.of<LocalDownloadProvider>(context, listen: false);
    var fileDownloaderProvider =
        Provider.of<FileDownloaderProvider>(context, listen: false);
    final isDownloaded = localDownloadProvider
        .checkForDownload('${widget.title}~e${widget.episode}');
    showModalBottomSheet(
      constraints: const BoxConstraints(minWidth: double.infinity),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      backgroundColor: const Color.fromARGB(255, 44, 44, 44),
      context: context,
      builder: (context) => SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 40,
              ),
              ListTile(
                leading: Icon(
                  Icons.share,
                  size: 32.sp,
                  color: const Color.fromARGB(255, 158, 156, 156),
                ),
                title: Text(
                  'Share',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w600),
                ),
                onTap: () async {
                  Get.back();
                  loading.value = true;
                  DynamicLinkProvider()
                      .createLink(widget.title)
                      .then((value) async {
                    final podcastTitle = widget.title;
                    final podcastDescription = widget.description;
                    final podcastUrl = value;
                    final limitedDescription = podcastDescription.length > 100
                        ? '${podcastDescription.substring(0, 120)}...'
                        : podcastDescription;
      
                    final text =
                        '🎧 Check out this amazing podcast: "$podcastTitle" 🎙️\n $limitedDescription\n🔗 $podcastUrl';
      
                    final imageUrl = widget.poster;
                    final bytes =
                        await NetworkAssetBundle(Uri.parse(imageUrl))
                            .load(imageUrl);
      
                    final tempDir = await getTemporaryDirectory();
                    final tempFile = File('${tempDir.path}/temp_image.jpg');
                    await tempFile.writeAsBytes(bytes.buffer.asUint8List());
                    loading.value = false;
                    await Share.shareFiles(
                      [tempFile.path],
                      text: text,
                      subject: 'Share Podcast',
                    );
                  });
                },
              ),
              ListTile(
                leading: Icon(
                  isDownloaded ? Icons.delete : Icons.download,
                  size: 32.sp,
                  color: const Color.fromARGB(255, 158, 156, 156),
                ),
                title: Text(
                  isDownloaded ? 'Delete From Downloads' : 'Download',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w600),
                ),
                onTap: () async {
                  if (isDownloaded) {
                    showDeleteConfirmationDialog(
                        context, widget.title, widget.episode);
                  } else {
                    currentDownloadId = widget.episodeId;
      
                    NotificationService.showNotification(
                      title: 'Downloading..',
                      body: widget.episode,
                      locked: true,
                      bigPicture: widget.poster.isNotEmpty
                          ? widget.poster
                          : widget.albumImage,
                      notificationLayout: NotificationLayout.ProgressBar,
                      payload: {'navigate': 'true', 'to': 'downloads'},
                    );
      
                    await fileDownloaderProvider
                        .downloadFileWithPoster(
                            widget.audioUrl,
                            widget.poster.isNotEmpty
                                ? widget.poster
                                : widget.albumImage,
                            '${widget.title}~e${widget.episode}',
                            widget.albumImage)
                        .then((onValue) {
                      localDownloadProvider.loadLocalDownloads();
                      NotificationService.dismissAllNotifications();
                      NotificationService.showNotification(
                        title: 'Download Completed',
                        body: widget.episode,
                        locked: false,
                        bigPicture: widget.poster.isNotEmpty
                            ? widget.poster
                            : widget.albumImage,
                        notificationLayout: NotificationLayout.BigPicture,
                        payload: {'navigate': 'true', 'to': 'downloads'},
                      );
                      currentDownloadId =
                          null; // Clear current download ID after download completes
                    });
                  }
                },
              ),
              userId != widget.uploaderId
                  ? ListTile(
                      leading: Icon(
                        Icons.star,
                        size: 32.sp,
                        color: const Color.fromARGB(255, 158, 156, 156),
                      ),
                      title: Text(
                        'Rate',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w600),
                      ),
                      onTap: () {
                        Navigator.pop(context);
      
                        Get.to(
                            RateDialog(
                              id: widget.podcastId,
                              color: _paletteGenerator?.dominantColor?.color
                                      .withOpacity(1) ??
                                  Colors.transparent,
                              podcastTitle: widget.title,
                              podcastImageUrl: widget.albumImage == ''
                                  ? podcastPlaceHolder
                                  : widget.poster,
                              title: 'Podcast',
                            ),
                            transition: Transition.downToUp);
                      },
                    )
                  : ListTile(
                      leading: Icon(
                        Icons.delete,
                        size: 32.sp,
                        color: const Color.fromARGB(255, 158, 156, 156),
                      ),
                      title: Text(
                        'Delete',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w600),
                      ),
                      onTap: () async {
                        try {
                          loading.value = true;
                          Navigator.pop(context);
                          final res = await PodcastService()
                              .deletePodcast(widget.podcastId);
      
                          if (res) {
                            showSnackbar(
                                'Success', 'Podcast Deleted Successfully',ContentType.success,context);
                            Navigator.of(context).pop();
                          } else {
                            showSnackbar('Failed', 'Something went wrong',ContentType.failure,context);
                          }
                        } finally {
                          loading.value = false;
                        }
                      }),
              userId != widget.uploaderId
                  ? ListTile(
                      leading: Icon(
                        Icons.report,
                        size: 32.sp,
                        color: const Color.fromARGB(255, 158, 156, 156),
                      ),
                      title: Text(
                        'Report',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w600),
                      ),
                      onTap: () async {
                        Navigator.pop(context);
                        await _showReportBottomSheet(
                            context, widget.episodeId);
                      },
                    )
                  : const SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> _showReportBottomSheet(
    BuildContext context, String podcastId) async {
  await showModalBottomSheet(
    context: context,
    showDragHandle: true,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    backgroundColor: const Color.fromARGB(255, 39, 38, 38),
    builder: (BuildContext context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _buildReportOption(context, podcastId, 'Sexual content'),
          _buildReportOption(
              context, podcastId, 'Violent or repulsive content'),
          _buildReportOption(context, podcastId, 'Hateful or abusive content'),
          _buildReportOption(context, podcastId, 'Harmful or dangerous acts'),
          _buildReportOption(context, podcastId, 'misleading'),
          _buildReportOption(context, podcastId, 'Stolen Content'),
          // Add more report options as needed
        ],
      );
    },
  );
}

Future<void> showDeleteConfirmationDialog(
    BuildContext context, String title, String episodeTitle) async {
  final localDownloadProvider =
      Provider.of<LocalDownloadProvider>(context, listen: false);
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierColor: const Color.fromARGB(170, 0, 0, 0),
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: const Color.fromARGB(255, 34, 33, 33),
        title: const Text(
          'Delete From Downloads?',
          style: TextStyle(color: Colors.white),
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                'Do you want to delete the episode from downloads: $episodeTitle?',
                style:
                    const TextStyle(color: Color.fromARGB(217, 246, 240, 240)),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Directory appDocDir = await getApplicationDocumentsDirectory();
              String appDocPath = appDocDir.path;
              String audioFolderPath = appDocPath;

              var files = Directory(audioFolderPath).listSync();

              for (var file in files) {
                if (file is File) {
                  var splitParts = file.path.split('~e');

                  if (splitParts.length > 1 &&
                      splitParts[1].split('.')[0] == episodeTitle) {
                    
                    await file.delete();
                    showSnackbar('Deleted Successfully', 'Deleted successfully from downloads.',ContentType.success,context);
                  }
                }
              }
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red // Set the button color
                ),
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      );
    },
  );
}

Widget _buildReportOption(
    BuildContext context, String episodeId, String reportReason) {
  return ListTile(
    title: Text(
      reportReason,
      style: const TextStyle(color: Colors.white),
    ),
    onTap: () async {
      await _reportPodcast(context, episodeId, reportReason, 'podcast');
      Navigator.pop(context); // Close the bottom sheet after reporting
    },
  );
}

Future<void> _reportPodcast(BuildContext context, String podcastId,
    String reportReason, String type) async {
  try {
    final res =
        await PodcastService().reportPodcast(podcastId, reportReason, type);
    if (res) {
      showSnackbar('Success', 'Report Sent Successfully',ContentType.success,context);
    } else {
      showSnackbar('Failed', 'Something went wrong',ContentType.failure,context);
    }
  } catch (e) {
    print('Error reporting podcast: $e');
    showSnackbar('Error', 'Failed to report podcast',ContentType.failure,context);
  }
}
