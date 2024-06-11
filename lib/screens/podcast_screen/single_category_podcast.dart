import 'package:onpods/utils/exports.dart';

class SinglePodcastCategory extends StatefulWidget {
  final String title;
  final String categoryId;
  const SinglePodcastCategory(
      {super.key, required this.title, required this.categoryId});

  @override
  State<SinglePodcastCategory> createState() => _SinglePodcastCategoryState();
}

class _SinglePodcastCategoryState extends State<SinglePodcastCategory> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;
  String _sortBy = 'listenCount';
  @override
  void initState() {
    super.initState();
    _initializeScrollController();
    _fetchPodcasts();
  }

  Future<void> _fetchPodcasts() async {
    final podcastProvider =
        Provider.of<PodcastProvider>(context, listen: false);
    podcastProvider.fetchPodcastsByCategory(widget.categoryId, 1,_sortBy);
  }

  void _initializeScrollController() {
    _scrollController.addListener(() async {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        final provider = Provider.of<PodcastProvider>(context, listen: false);

        try {
          if (provider.podcasts[0].totalPages! > provider.podcasts[0].page!) {
            setState(() {
              _isLoadingMore = true;
            });
            print(
                '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ current page :${provider.podcasts[0].page}');
            print(
                '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ total page :${provider.podcasts[0].totalPages}');
            await provider.fetchPodcastsByCategory(
                widget.categoryId, provider.podcasts[0].page! + 1,_sortBy);
          }
        } catch (e) {
          throw Exception(e);
        } finally {
          setState(() {
            _isLoadingMore = false;
          });
        }
      }
    });
  }

  void dispose() {
    _scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final podcastProvider = Provider.of<PodcastProvider>(context);

    return Scaffold(
      bottomNavigationBar: const MiniPlayer(),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.white, fontSize: 24.sp),
        ),
        actions: [
          PopupMenuButton<String>(
            color: const Color(0xFF242323),
            icon: const Icon(
              Icons.filter_list,
              color: Colors.white,
              size: 32,
            ),
            
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'rating',
                child: Text(
                  'Most Rated',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'listenCount',
                child: Text(
                  'Most Listen',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'recentUpload',
                child: Text(
                  'Recent Upload',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ],
            onSelected: (String value) {
              setState(() {
                _sortBy = value;
              });
               podcastProvider.podcasts.clear();
                podcastProvider.setCategory();
                 podcastProvider.fetchPodcastsByCategory(widget.categoryId, 1,_sortBy);
            },
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          podcastProvider.podcasts.clear();
          podcastProvider.setCategory();
          podcastProvider.fetchPodcastsByCategory(widget.categoryId, 1,_sortBy);
        },
        child: podcastProvider.isLoading &&
                podcastProvider.categoryId != widget.categoryId
            ? const ListSkeleton()
            : podcastProvider.podcasts[0].count == 0
                ? const Center(
                    child: EmptyPlaceHolder(
                      message: 'Podcasts',
                    ),
                  )
                : CustomScrollView(
                    controller: _scrollController,
                    slivers: [
                      SliverToBoxAdapter(
                        child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: podcastProvider.podcasts[0].data!.length,
                            itemBuilder: (context, index) {
                              final podcast =
                                  podcastProvider.podcasts[0].data![index];
                              return GestureDetector(
                                onTap: () {
                                  Get.to(
                                      DetailedPodcast(
                                          podcastId: podcast.id!,
                                          description:
                                              podcast.description ?? '',
                                          image: podcast.posterUrl ?? '',
                                          title: podcast.title ?? ''),
                                      transition: Transition.downToUp);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 0.19.sh,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          child: CachedNetworkImage(
                                            fit: BoxFit.cover,
                                            width: 0.4.sw,
                                            height: 0.19.sh,
                                            imageUrl: podcast.posterUrl!,
                                            errorWidget: (context, url,
                                                    error) =>
                                                Image.asset(podcastPlaceHolder),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.485,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              podcast.title ?? '',
                                              maxLines: 3,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: 20.sp,
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                            ),
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.star,
                                                  color: Colors.yellow,
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  podcast.rating.toString(),
                                                  style: TextStyle(
                                                      color:
                                                          Colors.grey.shade500,
                                                      fontSize: 16.sp),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                podcast.totalListens != '0'
                                                    ? Text(
                                                        '| ${podcast.totalListens} plays',
                                                        style: TextStyle(
                                                            color: Colors
                                                                .grey.shade500,
                                                            fontSize: 16.sp),
                                                      )
                                                    : const SizedBox()
                                              ],
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 5),
                                              child: RichText(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 6,
                                                  text: TextSpan(
                                                    text: podcast.description ??
                                                        '',
                                                    style: TextStyle(
                                                      color:
                                                          Colors.grey.shade500,
                                                      fontSize: 16.sp,
                                                    ),
                                                  )),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ),
                      _isLoadingMore
                          ? const SliverToBoxAdapter(
                              child: Padding(
                                padding: EdgeInsets.all(20),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: blueColor,
                                  ),
                                ),
                              ),
                            )
                          : const SliverToBoxAdapter(child: SizedBox())
                    ],
                  ),
      ),
    );
  }
}
