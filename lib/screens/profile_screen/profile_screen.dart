import 'package:onpods/utils/exports.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  Map<dynamic, dynamic> quotes = {};
  bool loading = false;
  bool _isLoadingMore = false;
 static String userName = 'NIL';
 static String userEmail = 'NIL';
  String id = '';
  List intrests = [];
  bool verified = false;
  String userProfileImage = '';
  int followersCount = 0;
  int followingCount = 0;

  Future<void> _getUserData() async {
    setState(() {
      loading = true;
    });
    final userId = await UserSession.getUserId();
    final data = await UserServices().userById(userId);
    final userQuotes = await UserServices().userQuotes(userId, 1);

    setState(() {
      id = userId!;
      userEmail = data['email'];
      userName = data['username'];
      followersCount = data['followers'];
      followingCount = data['following'];
      userProfileImage = data['profilePic'];
      verified = data['verified'] ?? false;
      quotes.addAll(userQuotes);
      loading = false;
      intrests = data['interests'] ?? [];
    });
  }

  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    _getUserData();
    _tabController = TabController(length: 2, vsync: this);
    _initializeScrollController();
  }

  void _initializeScrollController() {
    _scrollController.addListener(() async {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !_isLoadingMore) {
        try {
          if (quotes['totalPages'] > quotes['page']) {
            setState(() {
              _isLoadingMore = true;
            });

            final userQuotes =
                await UserServices().userQuotes(id, quotes['page'] + 1);
            setState(() {
              quotes['page'] = userQuotes['page'];
              quotes['data'].addAll(userQuotes['data']);
              _isLoadingMore = false;
            });
          }
        } catch (e) {
          setState(() {
            _isLoadingMore = false;
          });
          throw Exception(e);
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
              loading
                  ? const SliverToBoxAdapter(child: ProfileSkeleton())
                  : SliverAppBar.large(
                      pinned: true,
                      iconTheme:
                          const IconThemeData(color: Colors.white, size: 26),
                      expandedHeight:
                          MediaQuery.of(context).size.shortestSide - 60,
                      backgroundColor: const Color.fromRGBO(0, 0, 0, 1),
                      actions: [
                        IconButton(
                            onPressed: () => _showBottomSheet(context),
                            icon: const Icon(
                              Icons.more_vert,
                              size: 35,
                            ))
                      ],
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            userName,
                            style: TextStyle(
                              fontSize: 26.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          verified
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
                        background: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 80),
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 236, 184, 202),
                                  borderRadius: BorderRadius.circular(60)),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(60),
                                child: CachedNetworkImage(
                                  imageUrl:userProfileImage,
                                  placeholder: (context, url) => Center(
                                    child: Text(
                                      userName.substring(0, 1).toUpperCase(),
                                      style: const TextStyle(fontSize: 32),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) => Center(
                                    child: Text(
                                      userName.substring(0, 1).toUpperCase(),
                                      style: const TextStyle(fontSize: 32),
                                    ),
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  userName,
                                  style: const TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                verified
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

                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 50, right: 50, top: 10, bottom: 10),
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                width: double.maxFinite,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: blueColor),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () => Get.to(
                                            FollowersScreen(
                                              count: followersCount,
                                              title: 'Followers',
                                              userId: id,
                                            ),
                                            transition: Transition.cupertino),
                                        child: RichText(
                                          textAlign: TextAlign.center,
                                          text: TextSpan(
                                            text: '$followersCount\n',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 25),
                                            children: const [
                                              TextSpan(
                                                text: 'Followers',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
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
                                              count: followingCount,
                                              title: 'Following',
                                              userId: id,
                                            ),
                                            transition: Transition.cupertino),
                                        child: RichText(
                                          textAlign: TextAlign.center,
                                          text: TextSpan(
                                            text: '$followingCount\n',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 25),
                                            children: const [
                                              TextSpan(
                                                text: 'Following',
                                                style: TextStyle(
                                                    color: Colors.white,
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
                        ),
                      ),
                    ),
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
                  ? loading
                      ? const SliverToBoxAdapter(child: ProfileQuotesSkeleton())
                      : SliverToBoxAdapter(
                          child: quotes['data'].length == 0
                              ? const Align(
                                  heightFactor: 2,
                                  alignment: Alignment.center,
                                  child: EmptyPlaceHolder(
                                    message: 'Quotes',
                                  ),
                                )
                              : Padding(
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
                                        onTap: () {
                                        
                                          Get.to(
                                            SingleQuote(
                                              postId: item['_id'],
                                              image: item['imageUrl'],
                                              userId: id,
                                            ),
                                            transition: Transition.cupertino);
                                        },
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
                        future: PodcastService().podcastsByUserId(id),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: ProfileQuotesSkeleton(),
                            );
                          } else if (snapshot.hasError ||
                              !snapshot.hasData ||
                              snapshot.data.isEmpty) {
                            // Handle error
                            return const Align(
                                heightFactor: 2,
                                alignment: Alignment.center,
                                child: EmptyPlaceHolder(message: ''));
                          } else {
                            // Data loaded successfully, display the list
                            return GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2, childAspectRatio: 0.8),
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) {
                                final podcast = snapshot.data;

                                return Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10),
                                  child: GestureDetector(
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
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(6),
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
                                          style: TextStyle(
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

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      constraints: BoxConstraints.tight(const Size(double.maxFinite, 550)),
      isScrollControlled: true,
      context: context,
      showDragHandle: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      builder: (context) => DraggableScrollableSheet(
          initialChildSize: 1,
          expand: true,
          builder: (context, controller) => ProfileActionList(
                profilePic: userProfileImage,
                userName: userName,
                userId: id,
                intrests:intrests
              )),
    );
  }
}
