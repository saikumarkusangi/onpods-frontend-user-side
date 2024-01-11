import 'package:onpods/utils/exports.dart';


class FollowersScreen extends StatefulWidget {
  final String title;
  final String userId;
  final int count;
  const FollowersScreen(
      {super.key,
      required this.title,
      required this.userId,
      required this.count});

  @override
  State<FollowersScreen> createState() => _FollowersScreenState();
}

class _FollowersScreenState extends State<FollowersScreen> {
  bool loading = false;
  bool _isLoadingMore = false;
  Map data = {};

  Future<void> _getUserFollowers() async {
    setState(() {
      loading = true;
    });
    final response = await UserServices().userFollowers(
        widget.userId, 1, widget.title.toLowerCase());

    setState(() {
      data.addAll(response);
      loading = false;
    });
  }

  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    if (widget.count != 0) {
      _getUserFollowers();
    }

    _initializeScrollController();
  }

  void _initializeScrollController() {
    _scrollController.addListener(() async {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !_isLoadingMore) {
        try {
          if (data['totalPages'] > data['page']) {
            setState(() {
              _isLoadingMore = true;
            });

            final userQuotes =
                await UserServices().userQuotes(widget.userId, data['page'] + 1);
            setState(() {
              data['page'] = userQuotes['page'];
              data['data'].addAll(userQuotes['data']);
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
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       bottomNavigationBar: const MiniPlayer(),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            pinned: true,
            centerTitle: true,
            iconTheme: const IconThemeData(color: Colors.white),
            backgroundColor: Colors.black,
            title: Text(
              widget.title,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          loading
              ? SliverToBoxAdapter(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    width: MediaQuery.of(context).size.width,
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: blueColor,
                      ),
                    ),
                  ),
                )
              : widget.count == 0
                  ? SliverToBoxAdapter(
                      child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.7,
                          width: MediaQuery.of(context).size.width,
                          child: EmptyPlaceHolder(message: widget.title,)))
                  : SliverList.builder(
                      itemCount: data['data'].length,
                      itemBuilder: (context, index) {
                        final user = data['data'][index];

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            onTap: () async {
                              final preps =
                                  await SharedPreferences.getInstance();
                              Get.to(
                                  preps.getString('user_id') != user['userId']
                                      ? UserProfileScreen(
                                          userId: user['userId'],
                                          userName: user['userName'],

                                        )
                                      : const ProfileScreen());
                            },
                            title: Text(
                              user['userName'] ?? 'User',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 22),
                            ),
                            leading: Container(
                              width: 55,
                              height: 55,
                              decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 236, 184, 202),
                                  borderRadius: BorderRadius.circular(60)),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(60),
                                child: CachedNetworkImage(
                                  imageUrl: 'https://onpods.s3.amazonaws.com/profile-pics/${user['userId']}.jpg',
                                  placeholder: (context, url) => Center(
                                    child: Text(
                                      (user['userName'] != null &&
                                              user['userName'].isNotEmpty)
                                          ? user['userName']
                                              .substring(0, 1)
                                              .toUpperCase()
                                          : 'U',
                                      style: const TextStyle(fontSize: 24),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) => Center(
                                    child: Text(
                                      (user['userName'] != null &&
                                              user['userName'].isNotEmpty)
                                          ? user['userName']
                                              .substring(0, 1)
                                              .toUpperCase()
                                          : 'U',
                                      style: const TextStyle(fontSize: 24),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
          SliverToBoxAdapter(
              child: _isLoadingMore
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: blueColor,
                      ),
                    )
                  : null)
        ],
      ),
    );
  }
}
