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
  @override
  void initState() {
    super.initState();
    final podcastProvider =
        Provider.of<PodcastProvider>(context, listen: false);
    podcastProvider.fetchPodcastsByCategory(widget.categoryId, 1);
  }

  @override
  Widget build(BuildContext context) {
    final podcastProvider = Provider.of<PodcastProvider>(context);

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          podcastProvider.fetchPodcastsByCategory(
             widget.categoryId, 1);
        },
        child: SingleChildScrollView(
          child: Column(children: [
            if (podcastProvider.isLoading)
              const ListSkeleton()
            else if (podcastProvider.podcasts[0].count == 0)
              const Center(
                child: EmptyPlaceHiolder(
                  message: 'Podcasts',
                ),
              )
            else
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: podcastProvider.podcasts[0].count,
                  itemBuilder: (context, index) {
               
                    final podcast = podcastProvider.podcasts[0].data![index];
                    return GestureDetector(
                      onTap: () => Get.to(
                           DetailedPodcast(
                              description: podcast.description ?? '',
                              image: podcast.posterUrl ?? '',
                              episodes: [],
                              // rating: double.parse(podcast.rating),
                              rating: 2,
                              title: podcast.title ?? ''),
                          transition: Transition.downToUp),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 150,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: CachedNetworkImage(
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    imageUrl: podcast.posterUrl ?? 'https://media.istockphoto.com/id/1283532997/vector/podcast-concept-thin-line-icon-abstract-icon-abstract-gradient-background-modern-sound-wave.jpg?s=612x612&w=0&k=20&c=YLg7rHeSuYqeIuGRAcvf2a7J8X8Sx-IkmqYHXIJGPYQ='),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.485,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                   Text(
                                    podcast.title ?? '',
                                    maxLines: 4,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 18,
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                   podcast.description ?? '',
                                    maxLines: 3,
                                    style: TextStyle(
                                        color: Colors.grey.shade400,
                                        fontSize: 14,
                                        overflow: TextOverflow.ellipsis),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  })
          ]),
        ),
      ),
    );
  }
}
