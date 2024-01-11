import 'package:onpods/utils/exports.dart';

class SearchViewAllScreen extends StatefulWidget {
  final String title;
  final List data;
  final String query;
  const SearchViewAllScreen(
      {Key? key, required this.title, required this.data, required this.query})
      : super(key: key);

  @override
  State<SearchViewAllScreen> createState() => _SearchViewAllScreenState();
}

class _SearchViewAllScreenState extends State<SearchViewAllScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;
  void initState() {
    super.initState();
    _initializeScrollController();
    final provider = Provider.of<PodcastProvider>(context, listen: false);
    print(provider.searchData['podcasts']['total_pages']);
    print('#########################');
  }

  void _initializeScrollController() {
    _scrollController.addListener(() async {
      print(_scrollController.position.pixels);
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        final provider = Provider.of<PodcastProvider>(context, listen: false);
        print(provider.searchData);
        // try {
        //   if (provider.searchData['podcasts']['total_pages'] >
        //       provider.searchData['podcasts']['current_page']) {
        //     setState(() {
        //       _isLoadingMore = true;
        //     });
        //     print(
        //         '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ current page :${provider.searchData['podcasts']['current_page']}');
        //     print(
        //         '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ total page :${provider.searchData['podcasts']['current_page']}');
        //     await provider.search(widget.query, 1,
        //         provider.searchData['podcasts']['current_page'] + 1, 1);
        //   }
        // } catch (e) {
        //   throw Exception(e);
        // } finally {
        //   setState(() {
        //     _isLoadingMore = false;
        //   });
        // }
      }
    });
  }

  void dispose() {
    _scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const MiniPlayer(),
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: widget.data.length,
              itemBuilder: (context, index) {
                final podcast = widget.data[index];

                return GestureDetector(
                  onTap: () => Get.to(
                      DetailedPodcast(
                          podcastId: podcast['_id']!,
                          description: podcast['description'] ?? '',
                          image: podcast['posterUrl'] ?? '',
                          title: podcast['title'] ?? ''),
                      transition: Transition.downToUp),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 150,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              width: MediaQuery.of(context).size.width * 0.4,
                              imageUrl: podcast['posterUrl']!,
                              errorWidget: (context, url, error) =>
                                  Image.asset(podcastPlaceHolder),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.485,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                podcast['title'] ?? '',
                                maxLines: 3,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 18.sp,
                                    overflow: TextOverflow.ellipsis),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: RichText(
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 6,
                                    text: TextSpan(
                                      text: podcast['description'] ?? '',
                                      style: TextStyle(
                                        color: Colors.grey.shade400,
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
              },
            ),
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
    );
  }
}
