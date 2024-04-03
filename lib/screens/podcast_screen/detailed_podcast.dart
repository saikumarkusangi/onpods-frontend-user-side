import 'dart:io';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_hud/flutter_hud.dart';
import 'package:onpods/providers/local_downloads_provider.dart';
import 'package:onpods/screens/podcast_screen/edit_page.dart';
import 'package:onpods/screens/podcast_screen/widgets/rating_screen.dart';
import 'package:onpods/utils/dynamic_links.dart';
import 'package:onpods/utils/exports.dart';
import 'package:onpods/utils/notification_service.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class DetailedPodcast extends StatefulWidget {
  final String image;
  final String title;
  final String description;
  final String podcastId;
  

  const DetailedPodcast(
      {Key? key,
      this.image = '',
      this.title = '',
      this.description = '',
      required this.podcastId})
      : super(key: key);

  @override
  State<DetailedPodcast> createState() => _DetailedPodcastState();
}

class _DetailedPodcastState extends State<DetailedPodcast> {
  late String firstHalf;
  late String secondHalf;
  late String userId;
  PaletteGenerator? _paletteGenerator =
      PaletteGenerator.fromColors([PaletteColor(Colors.black, 2)]);
  bool flag = true;
  String? currentDownloadId;


  @override
  void initState() {
    super.initState();
    _getUserId();
    generatePalette();

    if (widget.description.length > 130) {
      firstHalf = widget.description.substring(0, 130);
      secondHalf = widget.description.substring(130, widget.description.length);
    } else {
      firstHalf = widget.description;
      secondHalf = "";
    }

    final podcastProvider =
        Provider.of<PodcastProvider>(context, listen: false);
    podcastProvider.fetchPodcastsById(widget.podcastId);
  }

  _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('user_id')!;
  }

  Future<void> generatePalette() async {
    final provider = NetworkImage(widget.image);
    Future.delayed(const Duration(milliseconds: 250), () async {
      _paletteGenerator = await PaletteGenerator.fromImageProvider(provider);
      setState(() {});
    });
  }

  final ValueNotifier<bool> flagNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<bool> listed = ValueNotifier<bool>(false);
  final ValueNotifier<bool> loading = ValueNotifier<bool>(false);
  final ValueNotifier<bool> sort = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    final currentPodcastProvider = Provider.of<PodcastProvider>(context);
    final localDownloadProvider = Provider.of<LocalDownloadProvider>(context);
    final ValueNotifier<bool> followed = ValueNotifier<bool>(
        currentPodcastProvider.currentPodcast.isNotEmpty
            ? currentPodcastProvider.currentPodcast[0].following
            : false);
    final ValueNotifier<bool> listed = ValueNotifier<bool>(
        currentPodcastProvider.currentPodcast.isNotEmpty
            ? currentPodcastProvider.currentPodcast[0].addedToMyList
            : false);
    var fileDownloaderProvider = Provider.of<FileDownloaderProvider>(context);
    return ValueListenableBuilder(
      valueListenable: loading,
      builder: (context, value, child) => WidgetHUD(
        showHUD: value,
        hud: HUD(
            progressIndicator: Image.asset(
          liveGif,
          color: blueColor,
          scale: 3,
        )),
        builder: (context, child) => Scaffold(
          bottomNavigationBar: const MiniPlayer(),
          body: CustomScrollView(
            slivers: [
              SliverAppBar.large(
                centerTitle: true,
                backgroundColor: darkscaffoldBackgroundColor,
                expandedHeight: 0.6.sh,
                leading: IconButton(
                  iconSize: 32.sp,
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                ),
                actions: [
                  IconButton(
                    iconSize: 32.sp,
                    onPressed: () => _showBottomSheetPodcast(
                      currentPodcastProvider.currentPodcast[0].user.id,
                      widget.podcastId,
                      currentPodcastProvider.currentPodcast[0].categoryId,
                    ),
                    icon: const Icon(Icons.more_vert_outlined,
                        color: Colors.white),
                  ),
                ],
                pinned: true,
                title: Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 22.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  stretchModes: const [
                    StretchMode.fadeTitle,
                    StretchMode.blurBackground
                  ],
                  background: Stack(
                    children: [
                      // Image
                      CachedNetworkImage(
                        imageUrl: widget.image,
                        width: double.infinity,
                        height: 0.5.sh,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Image.asset(
                          podcastPlaceHolder,
                          scale: 3,
                        ),
                        errorWidget: (context, url, error) => Image.asset(
                          podcastPlaceHolder,
                          scale: 3,
                        ),
                      ),
                      // Gradient overlay
                      Container(
                        width: double.infinity,
                        height: 0.51.sh,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              darkscaffoldBackgroundColor.withOpacity(1),
                              darkscaffoldBackgroundColor.withOpacity(0.4),
                              darkscaffoldBackgroundColor.withOpacity(0.2),
                              Colors.transparent
                            ],
                            end: Alignment.center,
                            begin: Alignment.bottomCenter,
                          ),
                        ),
                      ),

                      currentPodcastProvider.currentPodcast.isNotEmpty
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // ClipRRect(
                                //   borderRadius: BorderRadius.circular(6),
                                //   child: CachedNetworkImage(
                                //     imageUrl: widget.image,
                                //     height: 0.26.sh,
                                //     width: 0.6.sw,
                                //     fit: BoxFit.cover,
                                //     placeholder: (context, url) =>
                                //         Image.asset(podcastPlaceHolder,scale: 3,),
                                //     errorWidget: (context, url, error) =>
                                //         Image.asset(podcastPlaceHolder),
                                //   ),
                                // ),

                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 5),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${currentPodcastProvider.currentPodcast[0].certificate} Rated   |  ',
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 16.sp),
                                      ),
                                      Text(
                                        '${currentPodcastProvider.currentPodcast[0].totalListens} Plays   |  ',
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 16.sp),
                                      ),
                                      Text(
                                        '${currentPodcastProvider.currentPodcast[0].followers} Subscribers',
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 16.sp),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: SizedBox(
                                    height: 60,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        ValueListenableBuilder(
                                          valueListenable: listed,
                                          builder: (context, value, child) {
                                            return IconButton(
                                                color: Colors.white,
                                                iconSize: 32,
                                                onPressed: () async {
                                                  if (listed.value) {
                                                    loading.value = true;
                                                    await UserServices()
                                                        .updateMyList(
                                                            [widget.podcastId],
                                                            'remove');
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                        duration: Duration(
                                                            milliseconds: 500),
                                                        content: Text(
                                                            'Removed from your List'),
                                                      ),
                                                    );
                                                    listed.value = false;
                                                    loading.value = false;
                                                  } else {
                                                    loading.value = true;
                                                    await UserServices()
                                                        .updateMyList(
                                                            [widget.podcastId],
                                                            'add');
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                        duration: Duration(
                                                            milliseconds: 500),
                                                        content: Text(
                                                            'Added to your List'),
                                                      ),
                                                    );
                                                    listed.value = true;
                                                    loading.value = false;
                                                  }
                                                },
                                                icon: Icon(listed.value
                                                    ? Icons.bookmark
                                                    : Icons.bookmark_outline));
                                          },
                                        ),
                                        CustomElevatedButton(
                                          width: 0.5.sw,
                                          height: 50,
                                          text: 'Latest Episode',
                                          leftIcon: Icon(
                                            Icons.play_arrow_rounded,
                                            color: Colors.white,
                                            size: 32.sp,
                                          ),
                                          onTap: () {
                                            final episodes =
                                                currentPodcastProvider
                                                    .currentPodcast[0].episodes;
                                            Get.to(
                                                PlayerScreen(
                                                  albumImage: widget.image,
                                                  playlist: episodes,
                                                  audioUrl:
                                                      episodes.last.audioUrl,
                                                  episode: episodes.last.title,
                                                  poster: episodes.last
                                                          .posterUrl.isNotEmpty
                                                      ? episodes.last.posterUrl
                                                      : widget.image,
                                                  title: widget.title,
                                                  startingIndex:
                                                      episodes.length - 1,
                                                  podcastId: widget.podcastId,
                                                  episodeId: episodes.last.id,
                                                ),
                                                transition:
                                                    Transition.downToUp);
                                          },
                                          buttonColor: blueColor,
                                          buttonTextStyle: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16.sp),
                                        ),
                                        ValueListenableBuilder<bool>(
                                            valueListenable: followed,
                                            builder: (context, value, child) {
                                              return IconButton(
                                                  color: Colors.white,
                                                  iconSize: 32,
                                                  onPressed: () async {
                                                    followed.value =
                                                        !followed.value;
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(SnackBar(
                                                            duration:
                                                                const Duration(
                                                                    milliseconds:
                                                                        500),
                                                            content: Text(followed
                                                                    .value
                                                                ? 'Subscribed Podcast'
                                                                : 'Unsubscribed Podcast')));
                                                    await PodcastService()
                                                        .podcastFollow(
                                                            widget.podcastId);
                                                  },
                                                  icon: Icon(!followed.value
                                                      ? Icons
                                                          .notification_add_outlined
                                                      : Icons
                                                          .notifications_active_rounded));
                                            })
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : const SizedBox(),

                      // !currentPodcastProvider.isLoading
                      //     ? Align(
                      //         alignment: Alignment.bottomLeft,
                      //         child: Padding(
                      //           padding:
                      //               const EdgeInsets.symmetric(horizontal: 12),
                      //           child: Row(
                      //             children: [
                      //               Text(
                      //                 'Author :',
                      //                 style: TextStyle(
                      //                     color: Colors.white60,
                      //                     fontSize: 16.sp,
                      //                     fontWeight: FontWeight.w600),
                      //               ),
                      //               GestureDetector(
                      //                 onTap: () => Get.to(
                      //                   userId !=
                      //                           currentPodcastProvider
                      //                               .currentPodcast[0].user.id
                      //                       ? UserProfileScreen(
                      //                           userId: currentPodcastProvider
                      //                               .currentPodcast[0].user.id,
                      //                           userName: currentPodcastProvider
                      //                               .currentPodcast[0]
                      //                               .user
                      //                               .username,
                      //                         )
                      //                       : const ProfileScreen(),
                      //                   transition: Transition.cupertino,
                      //                 ),
                      //                 child: Padding(
                      //                   padding: const EdgeInsets.symmetric(
                      //                       horizontal: 12),
                      //                   child: Row(children: [
                      //                     Container(
                      //                       width: 0.08.sw,
                      //                       height: 0.04.sh,
                      //                       decoration: BoxDecoration(
                      //                         color: const Color.fromARGB(
                      //                             255, 236, 184, 202),
                      //                         borderRadius:
                      //                             BorderRadius.circular(60),
                      //                       ),
                      //                       child: ClipRRect(
                      //                         borderRadius:
                      //                             BorderRadius.circular(60),
                      //                         child: CachedNetworkImage(
                      //                           imageUrl: currentPodcastProvider
                      //                               .currentPodcast[0]
                      //                               .user
                      //                               .profilePic,
                      //                           placeholder: (context, url) =>
                      //                               Center(
                      //                             child: Text(
                      //                               currentPodcastProvider
                      //                                       .currentPodcast[0]
                      //                                       .user
                      //                                       .username
                      //                                       ?.substring(0, 1)
                      //                                       ?.toUpperCase() ??
                      //                                   '',
                      //                               style: TextStyle(
                      //                                 fontSize: 20.sp,
                      //                               ),
                      //                             ),
                      //                           ),
                      //                           errorWidget:
                      //                               (context, url, error) =>
                      //                                   Center(
                      //                             child: Text(
                      //                               currentPodcastProvider
                      //                                       .currentPodcast[0]
                      //                                       .user
                      //                                       .username
                      //                                       ?.substring(0, 1)
                      //                                       ?.toUpperCase() ??
                      //                                   '',
                      //                               style: TextStyle(
                      //                                 fontSize: 20.sp,
                      //                               ),
                      //                             ),
                      //                           ),
                      //                         ),
                      //                       ),
                      //                     ),
                      //                     const SizedBox(
                      //                       width: 10,
                      //                     ),
                      //                     Text(
                      //                       currentPodcastProvider
                      //                           .currentPodcast[0].user.username,
                      //                       maxLines: 1,
                      //                       overflow: TextOverflow.ellipsis,
                      //                       style: TextStyle(
                      //                         color: Colors.white,
                      //                         fontWeight: FontWeight.w600,
                      //                         fontSize: 20.sp,
                      //                       ),
                      //                     ),
                      //                   ]),
                      //                 ),
                      //               ),
                      //             ],
                      //           ),
                      //         ))
                      //     : const SizedBox(),
                      widget.image == ''
                          ? Align(
                              heightFactor: 9,
                              alignment: Alignment.bottomCenter,
                              child: Text(
                                widget.title,
                                maxLines: 3,
                                style: TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  color: Colors.white,
                                  fontSize: 32.sp,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            )
                          : const SizedBox(),
                      currentPodcastProvider.currentPodcast.isNotEmpty
                          ? Positioned(
                              bottom: 100,
                              left: 0.25.sw,
                              child: Align(
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    RatingBar.builder(
                                      glow: false,
                                      ignoreGestures: true,
                                      updateOnDrag: false,
                                      itemSize: 32.sp,
                                      unratedColor: Colors.grey,
                                      initialRating: currentPodcastProvider
                                          .currentPodcast[0].rating,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      itemPadding: const EdgeInsets.symmetric(
                                          horizontal: 4.0),
                                      itemBuilder: (context, _) => const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      onRatingUpdate: (rating) {},
                                    ),
                                    Text(
                                      '(${currentPodcastProvider.currentPodcast[0].rated})',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 14.sp),
                                    )
                                  ],
                                ),
                              ),
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 14.0,
                      ),
                      child: secondHalf.isEmpty
                          ? Text(
                              firstHalf,
                              style: TextStyle(color: Colors.grey.shade400),
                            )
                          : ValueListenableBuilder<bool>(
                              valueListenable: flagNotifier,
                              builder: (BuildContext context, bool flag,
                                  Widget? child) {
                                return RichText(
                                  text: TextSpan(
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: !flag
                                            ? ("$firstHalf...")
                                            : (firstHalf + secondHalf),
                                        style: TextStyle(
                                            color: Colors.grey.shade400,
                                            fontSize: 16.sp,
                                            height: 1.4),
                                      ),
                                      TextSpan(
                                        text:
                                            flag ? " show less" : " show more",
                                        style: TextStyle(
                                            color: blueColor,
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.w600),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            flagNotifier.value =
                                                !flagNotifier.value;
                                          },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            )),
                  ValueListenableBuilder(
                    valueListenable: sort,
                    builder: (context, value, child) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(left: 10),
                          margin: const EdgeInsets.only(left: 15),
                          decoration: const BoxDecoration(
                              border: Border(
                                  left:
                                      BorderSide(color: blueColor, width: 4))),
                          child: Text(
                            'All Episodes',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 22.sp,
                            ),
                          ),
                        ),
                        TextButton.icon(
                            onPressed: () {
                              sort.value = !sort.value;
                              setState(() {});
                            },
                            icon: const Icon(
                              Icons.swap_vert,
                              color: blueColor,
                            ),
                            label: const Text(
                              'Sort',
                              style: TextStyle(color: Colors.white),
                            ))
                      ],
                    ),
                  )
                ]),
              ),
              if (currentPodcastProvider.currentPodcast.isEmpty)
                SliverToBoxAdapter(
                    child: Center(
                        child: Image.asset(
                  liveGif,
                  color: blueColor,
                  scale: 3,
                )))
              else if (currentPodcastProvider
                  .currentPodcast[0].episodes.isEmpty)
                const SliverToBoxAdapter(
                    child: EmptyPlaceHolder(
                  message: 'Episode',
                ))
              else
                SliverList.builder(
                    itemCount: currentPodcastProvider
                        .currentPodcast[0].episodes.length,
                    itemBuilder: (context, index) {
                      final episodes = sort.value
                          ? currentPodcastProvider
                              .currentPodcast[0].episodes.reversed
                              .toList()
                          : currentPodcastProvider.currentPodcast[0].episodes;
                      final isDownloaded =
                          localDownloadProvider.checkForDownload(
                              '${widget.title}~e${episodes[index].title}');
                      return GestureDetector(
                          onTap: () => Get.to(
                              PlayerScreen(
                                albumImage: widget.image,
                                playlist: episodes,
                                audioUrl: episodes[index].audioUrl,
                                episode: episodes[index].title,
                                poster: episodes[index].posterUrl.isNotEmpty
                                    ? episodes[index].posterUrl
                                    : widget.image,
                                title: widget.title,
                                startingIndex: index,
                                podcastId: widget.podcastId,
                                episodeId: episodes[index].id,
                              ),
                              transition: Transition.downToUp),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 12, right: 12, top: 10),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(6),
                                      child: CachedNetworkImage(
                                        width: 0.3.sw,
                                        height: 0.14.sh,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) =>
                                            Image.asset(
                                          podcastPlaceHolder,
                                          scale: 3,
                                        ),
                                        imageUrl:
                                            episodes[index].posterUrl.isNotEmpty
                                                ? episodes[index].posterUrl
                                                : widget.image,
                                        errorWidget: (context, url, error) =>
                                            Image.asset(
                                          podcastPlaceHolder,
                                          scale: 3,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 0.05.sw),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            episodes[index].title,
                                            maxLines: 2,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w800,
                                                fontSize: 20.sp,
                                                overflow:
                                                    TextOverflow.ellipsis),
                                          ),
                                          Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 5),
                                              child: RichText(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 5,
                                                  softWrap: true,
                                                  text: TextSpan(
                                                      children: <TextSpan>[
                                                        TextSpan(
                                                          text: episodes[index]
                                                              .description,
                                                          style: TextStyle(
                                                            color: Colors
                                                                .grey.shade400,
                                                            fontSize: 16.sp,
                                                          ),
                                                        ),
                                                      ])))
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: Icon(
                                            Icons.share,
                                            size: 32.sp,
                                            color: Colors.white,
                                          ),
                                          onPressed: () {},
                                        ),
                                     IconButton(
  icon: isDownloaded
      ? Icon(Icons.download_done, size: 32.sp,)
      : (currentDownloadId != null && currentDownloadId == episodes[index].id)
          ? CircularPercentIndicator(
              radius: 16.0,
              lineWidth: 2.0,
              percent: fileDownloaderProvider.downloadPercentage / 100,
              center: Text(
                '${fileDownloaderProvider.downloadPercentage}%',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                ),
              ),
              progressColor: blueColor,
            )
          : Icon(Icons.download_for_offline, size: 32.sp,),

  color: Colors.white,
  onPressed: () async {
    if (currentDownloadId != null ) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Another download is already in progress.'),
        ),
      );
      return;
    }

    if (isDownloaded) {
      showDeleteConfirmationDialog(context, episodes[index].title);
    } else {
      currentDownloadId = episodes[index].id; // Set current download ID

      NotificationService.showNotification(
        title: 'Downloading..',
        body: episodes[index].title,
        locked: true,
        bigPicture: episodes[index].posterUrl.isNotEmpty
            ? episodes[index].posterUrl
            : widget.image,
        notificationLayout: NotificationLayout.ProgressBar,
        payload: {'navigate': 'true', 'to': 'downloads'},
      );

      await fileDownloaderProvider
          .downloadFileWithPoster(
              episodes[index].audioUrl,
              episodes[index].posterUrl.isNotEmpty
                  ? episodes[index].posterUrl
                  : widget.image,
              '${widget.title}~e${episodes[index].title}')
          .then((onValue) {
        localDownloadProvider.loadLocalDownloads();
        NotificationService.dismissAllNotifications();
        currentDownloadId = null; // Clear current download ID after download completes
      });
    }
  },
), IconButton(
                                          icon: Icon(
                                            Icons.play_circle,
                                            size: 32.sp,
                                            color: Colors.white,
                                          ),
                                          onPressed: () => Get.to(
                                              PlayerScreen(
                                                albumImage: widget.image,
                                                playlist: episodes,
                                                audioUrl:
                                                    episodes[index].audioUrl,
                                                episode: episodes[index].title,
                                                poster: episodes[index]
                                                        .posterUrl
                                                        .isEmpty
                                                    ? widget.image
                                                    : episodes[index].posterUrl,
                                                title: widget.title,
                                                startingIndex: index,
                                                podcastId: widget.podcastId,
                                                episodeId: episodes[index].id,
                                              ),
                                              transition: Transition.downToUp),
                                        ),
                                      ],
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.more_vert,
                                        size: 32.sp,
                                        color: Colors.white,
                                      ),
                                      onPressed: () => _showBottomSheet(
                                          currentPodcastProvider
                                              .currentPodcast[0].user.id,
                                          widget.podcastId,
                                          episodes[index].id,
                                          episodes[index].title,
                                          episodes[index].description,
                                          episodes[index].posterUrl.isEmpty
                                              ? widget.image
                                              : episodes[index].posterUrl,
                                          ''),
                                    ),
                                  ],
                                ),
                              ),
                              currentPodcastProvider.currentPodcast[0].episodes
                                              .length -
                                          1 !=
                                      index
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15, right: 15),
                                      child: Divider(
                                        color: Colors.grey.shade700,
                                      ),
                                    )
                                  : const SizedBox()
                            ],
                          ));
                    })
            ],
          ),
        ),
      ),
    );
  }

  void _showBottomSheetPodcast(uploaderId, podcastId, categoryId) {
    final podcastProvider =
        Provider.of<PodcastProvider>(context, listen: false);
    showModalBottomSheet(
      showDragHandle: true,
      barrierColor: const Color.fromARGB(170, 0, 0, 0),
      constraints: const BoxConstraints(maxHeight: 300),
      backgroundColor: const Color.fromARGB(255, 34, 33, 33),
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
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

                  final imageUrl = widget.image;
                  final bytes = await NetworkAssetBundle(Uri.parse(imageUrl))
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
                Icons.download,
                size: 32.sp,
                color: const Color.fromARGB(255, 158, 156, 156),
              ),
              title: Text(
                'Download',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w600),
              ),
              onTap: () {},
            ),
            userId != uploaderId
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
                            id: podcastId,
                            color: _paletteGenerator?.dominantColor?.color
                                    .withOpacity(1) ??
                                Colors.transparent,
                            podcastTitle: widget.title,
                            podcastImageUrl: widget.image == ''
                                ? podcastPlaceHolder
                                : widget.image,
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
                        final res =
                            await PodcastService().deletePodcast(podcastId);

                        if (res) {
                          showSnackbar(
                              'Success', 'Podcast Deleted Successfully');
                          Navigator.of(context).pop();
                        } else {
                          showSnackbar('Failed', 'Something went wrong');
                        }
                      } finally {
                        loading.value = false;
                      }
                    }),
            userId != uploaderId
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
                    onTap: () {},
                  )
                : ListTile(
                    leading: Icon(
                      Icons.edit,
                      size: 32.sp,
                      color: const Color.fromARGB(255, 158, 156, 156),
                    ),
                    title: Text(
                      'Edit',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w600),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Get.to(EditPage(
                        index: 1,
                        imagePath: widget.image,
                        podcastId: podcastId,
                        title: widget.title,
                        description: widget.description,
                        episodeId: '',
                        selectedChipIndex: categoryId,
                      ));
                    },
                  )
          ],
        ),
      ),
    );
  }

  void _showBottomSheet(
      uploaderId, podcastId, episodeId, title, description, image, categoryId) {
    final podcastProvider =
        Provider.of<PodcastProvider>(context, listen: false);
    showModalBottomSheet(
      showDragHandle: true,
      barrierColor: const Color.fromARGB(170, 0, 0, 0),
      constraints: const BoxConstraints(maxHeight: 300),
      backgroundColor: const Color.fromARGB(255, 34, 33, 33),
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
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
              onTap: () {},
            ),
            ListTile(
              leading: Icon(
                Icons.download,
                size: 32.sp,
                color: const Color.fromARGB(255, 158, 156, 156),
              ),
              title: Text(
                'Download',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w600),
              ),
              onTap: () {},
            ),
            userId != uploaderId
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
                            id: podcastId,
                            color: _paletteGenerator?.dominantColor?.color
                                    .withOpacity(1) ??
                                Colors.transparent,
                            podcastTitle: title,
                            title: 'Episode',
                            podcastImageUrl:
                                image == '' ? podcastPlaceHolder : image,
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
                      podcastProvider.currentPodcast.clear();
                      Navigator.pop(context);
                      final res = await PodcastService()
                          .deleteEpisode(podcastId, episodeId);
                      if (res) {
                        showSnackbar('Success', 'Episode Deleted Successfully');
                      } else {
                        showSnackbar('Failed', 'Something went wrong');
                      }
                      podcastProvider.fetchPodcastsById(widget.podcastId);
                    },
                  ),
            userId != uploaderId
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
                    onTap: () {},
                  )
                : ListTile(
                    leading: Icon(
                      Icons.edit,
                      size: 32.sp,
                      color: const Color.fromARGB(255, 158, 156, 156),
                    ),
                    title: Text(
                      'Edit',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w600),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Get.to(
                          EditPage(
                            index: 0,
                            imagePath: image,
                            podcastId: podcastId,
                            title: title,
                            episodeId: episodeId,
                            description: description,
                            selectedChipIndex: categoryId,
                          ),
                          transition: Transition.rightToLeft);
                    },
                  )
          ],
        ),
      ),
    );
  }
}

Future<void> showDeleteConfirmationDialog(
    BuildContext context, String episodeTitle) async {
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
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog after deleting
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
