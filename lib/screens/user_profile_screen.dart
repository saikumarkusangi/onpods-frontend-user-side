import 'package:onpods/utils/exports.dart';

class UserProfileScreen extends StatefulWidget {
  final String userId;
  final String userName;

  const UserProfileScreen({
    super.key,
    required this.userId,
    this.userName = 'User',
  });

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen>
    with SingleTickerProviderStateMixin {
  Map<dynamic, dynamic> quotes = {};
  List podcasts = [];

  final ValueNotifier<bool> followed = ValueNotifier<bool>(false);
  final ValueNotifier<int> followersCount = ValueNotifier<int>(0);
  final ValueNotifier<int> followingCount = ValueNotifier<int>(0);
  final ValueNotifier<bool> loading = ValueNotifier<bool>(false);
  final ValueNotifier<bool> profileLoading = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _isLoadingMore = ValueNotifier<bool>(false);
  final ValueNotifier<bool> verified = ValueNotifier<bool>(false);
  late TabController _tabController;
  late Future<dynamic> _userDataFuture;
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    if (widget.userId != '') {
      _getUserData();
    }

    _tabController = TabController(length: 2, vsync: this);
    _initializeScrollController();
  }

  Future<void> _getUserData() async {
    profileLoading.value = true;
    loading.value = true;

    _userDataFuture = UserServices().userById(widget.userId).whenComplete(() {
      profileLoading.value = false;
    });

    final userQuotes = await UserServices().userQuotes(widget.userId, 1);
    // final userPodcasts = await PodcastService().podcastsByUserId(widget.userId);
    setState(() {
      quotes.addAll(userQuotes);
      // podcasts.add(userPodcasts);
    });

    loading.value = false;
  }

  void _initializeScrollController() {
    _scrollController.addListener(() async {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !_isLoadingMore.value) {
        try {
          if (quotes['totalPages'] > quotes['page']) {
            setState(() {
              _isLoadingMore.value = true;
            });

            final userQuotes = await UserServices()
                .userQuotes(widget.userId, quotes['page'] + 1);
            setState(() {
              quotes['page'] = userQuotes['page'];
              quotes['data'].addAll(userQuotes['data']);
            });
          }
        } catch (e) {
          throw Exception(e);
        } finally {
          _isLoadingMore.value = false;
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
    _scrollController.dispose();
  }

  Color getRandomColor() {
    final random = Random();
    return placeholderColors[random.nextInt(placeholderColors.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       bottomNavigationBar: const MiniPlayer(),
      extendBodyBehindAppBar: true,
      body: DefaultTabController(
          length: 2,
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverAppBar.large(
                      pinned: true,
                      iconTheme:
                          const IconThemeData(color: Colors.white, size: 26),
                      expandedHeight: 370,
                      backgroundColor: const Color.fromRGBO(0, 0, 0, 1),
                      actions: [
                        PopupMenuButton<String>(
                          position: PopupMenuPosition.over,
                          color: const Color.fromARGB(255, 51, 49, 49),
                          icon:
                              const Icon(Icons.more_vert, color: Colors.white),
                          itemBuilder: (BuildContext context) {
                            return <PopupMenuEntry<String>>[
                              const PopupMenuItem<String>(
                                value: 'option1',
                                child: Text(
                                  'Report account',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                              ),
                            ];
                          },
                          onSelected: (String value) {
                            // Handle the selected option here
                          },
                        )
                      ],
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            widget.userName,
                            style:  TextStyle(
                              fontSize: 26.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          verified.value
                              ? const Icon(
                                  Icons.verified,
                                  color: blueColor,
                                  size: 20,
                                )
                              : const SizedBox()
                        ],
                      ),
                      flexibleSpace: FlexibleSpaceBar(
                          collapseMode: CollapseMode.none,
                          background: FutureBuilder(
                              future: _userDataFuture,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                    child: ProfileSkeleton(),
                                  );
                                } else if (snapshot.hasError) {
                                  // Handle error
                                  return const Center(
                                    child: Text('Error loading User'),
                                  );
                                } else if (!snapshot.hasData ||
                                    snapshot.data.isEmpty) {
                                  // Handle no data scenario
                                  return const Center(
                                    child: Text('No Data available'),
                                  );
                                } else {
                                  followed.value = snapshot.data['followed'];
                                  followersCount.value =
                                      snapshot.data['followers'];
                                  followingCount.value =
                                      snapshot.data['following'];
                                  verified.value = snapshot.data['verified'];
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const SizedBox(height: 80),
                                      Container(
                                        width: 100,
                                        height: 100,
                                        decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                255, 236, 184, 202),
                                            borderRadius:
                                                BorderRadius.circular(60)),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(60),
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                snapshot.data['profilePic'],
                                            placeholder: (context, url) =>
                                                Center(
                                              child: Text(
                                                snapshot.data['username']
                                                    .substring(0, 1)
                                                    .toUpperCase(),
                                                style: const TextStyle(
                                                    fontSize: 32),
                                              ),
                                            ),
                                            errorWidget:
                                                (context, url, error) => Center(
                                              child: Text(
                                                snapshot.data['username']
                                                    .substring(0, 1)
                                                    .toUpperCase(),
                                                style: const TextStyle(
                                                    fontSize: 32),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            widget.userName,
                                            style: const TextStyle(
                                              fontSize: 26,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          verified.value
                                              ? const Icon(
                                                  Icons.verified,
                                                  color: blueColor,
                                                  size: 20,
                                                )
                                              : const SizedBox()
                                        ],
                                      ),
                                      // Text(
                                      //   userEmail,
                                      //   style: const TextStyle(
                                      //     fontSize: 18,
                                      //     color: Colors.grey,
                                      //   ),
                                      // ),
                                      const SizedBox(height: 10),
                                      Center(
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.white),
                                          onPressed: () async {
                                            followed.value = !followed.value;

                                            if (followed.value) {
                                              followersCount.value =
                                                  followersCount.value + 1;
                                              await UserServices()
                                                  .followUser(widget.userId);
                                            } else {
                                              followersCount.value =
                                                  followersCount.value - 1;
                                              await UserServices()
                                                  .unFollowUser(widget.userId);
                                            }
                                          },
                                          child: ValueListenableBuilder<bool>(
                                              valueListenable: followed,
                                              builder: (context, value, child) {
                                                return Text(
                                                  followed.value
                                                      ? 'Following'
                                                      : 'Follow',
                                                  style: const TextStyle(
                                                      color: blueColor,
                                                      fontSize: 18),
                                                );
                                              }),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 50,
                                            right: 50,
                                            top: 10,
                                            bottom: 10),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10),
                                          width: double.maxFinite,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: blueColor),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                ValueListenableBuilder(
                                                  valueListenable:
                                                      followersCount,
                                                  builder:
                                                      (context, value, child) =>
                                                          GestureDetector(
                                                    onTap: () => Get.to(
                                                        FollowersScreen(
                                                          count: followersCount
                                                              .value,
                                                          title: 'Followers',
                                                          userId: widget.userId,
                                                        ),
                                                        transition: Transition
                                                            .cupertino),
                                                    child: RichText(
                                                      textAlign:
                                                          TextAlign.center,
                                                      text: TextSpan(
                                                        text: '$value\n',
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 25),
                                                        children: const [
                                                          TextSpan(
                                                            text: 'Followers',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 16),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 20),
                                                  child: Container(
                                                    color: Colors.white,
                                                    height: 50,
                                                    width: 1,
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () => Get.to(
                                                      FollowersScreen(
                                                          count: followingCount
                                                              .value,
                                                          title: 'Following',
                                                          userId:
                                                              widget.userId),
                                                      transition:
                                                          Transition.cupertino),
                                                  child: RichText(
                                                    textAlign: TextAlign.center,
                                                    text: TextSpan(
                                                      text:
                                                          '${followingCount.value}\n',
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 25),
                                                      children: const [
                                                        TextSpan(
                                                          text: 'Following',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 16),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ]),
                                        ),
                                      ),
                                    ],
                                  );
                                }
                              }))),
              SliverToBoxAdapter(
                child: Center(
                  child: TabBar(
                    controller: _tabController,
                    onTap: (value) {
                      _tabController.index = value;
                      setState(() {});
                    },
                    tabAlignment: TabAlignment.center,
                    dividerColor: Colors.black,
                    unselectedLabelColor: Colors.white,
                    labelColor: blueColor,
                    indicatorColor: blueColor,
                    labelStyle: const TextStyle(fontSize: 18),
                    tabs: const [
                      Tab(
                        text: 'Quotes',
                      ),
                      Tab(
                        text: 'Podcasts',
                      )
                    ],
                  ),
                ),
              ),
              _tabController.index == 0
                  ? loading.value
                      ? const SliverToBoxAdapter(
                          child: ProfileQuotesSkeleton(),
                        )
                      : widget.userId == '' || quotes['data'].length == 0
                          ? const SliverToBoxAdapter(
                              child: EmptyPlaceHolder(
                              message: 'Quotes',
                            ))
                          : SliverToBoxAdapter(
                              child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10, top: 40),
                                  child: StaggeredGrid.count(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 14.0,
                                    crossAxisSpacing: 10.0,
                                    children: List.generate(
                                        quotes['data'].length, (index) {
                                      var item = quotes['data'][index];

                                      return GestureDetector(
                                        onTap: () => Get.to(
                                            SingleQuote(
                                              postId: item['id'],
                                              image: item['imageUrl'],
                                              userId: widget.userId,
                                            ),
                                            transition: Transition.cupertino),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: CachedNetworkImage(
                                            imageUrl: item['imageUrl'],
                                            placeholder: (context, url) =>
                                                Center(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: getRandomColor(),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                width: 100,
                                                height: 100,
                                              ),
                                            ),
                                            errorWidget: (context, url,
                                                    error) =>
                                                Image.asset(imagePlaceHolder),
                                          ),
                                        ),
                                      );
                                    }),
                                  )),
                            )
                  :

                  // Podcasts Tab Content
                      SliverToBoxAdapter(
                      child: FutureBuilder(
                        future: PodcastService().podcastsByUserId(widget.userId),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return  const ProfileQuotesSkeleton();
                          } else if (snapshot.hasError ||
                              !snapshot.hasData ||
                              snapshot.data.isEmpty) {
                            // Handle error
                            return const EmptyPlaceHolder(message: '');
                          } else {
                            // Data loaded successfully, display the list
                            return GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 0.8),
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) {
                                final podcast = snapshot.data;

                                return GestureDetector(
                                  onTap: () => Get.to(
                                    DetailedPodcast(
                                      podcastId: podcast[index]['podcastId'],
                                      description:
                                          podcast[index]['description'] ?? '',
                                      image:
                                          podcast[index]['posterUrl'] ?? '',
                                      title: podcast[index]['title'] ?? '',
                                    ),
                                    transition: Transition.downToUp,
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.only(left: 10,right: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        ClipRRect(
                                              borderRadius: BorderRadius.circular(6),
                                          child: CachedNetworkImage(
                                            fit: BoxFit.cover,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.45,
                                            height: 160,
                                            imageUrl: podcast[index]
                                                ['posterUrl'],
                                            errorWidget: (context, url,
                                                    error) =>
                                                Image.asset(podcastPlaceHolder),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          podcast[index]['title'] ?? '',
                                          maxLines: 2,
                                          style:  TextStyle(
                                            color: Colors.white,

                                            fontSize: 16.sp,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                        },
                      ),
                    ),

                ],
          )),
    );
  }
}
