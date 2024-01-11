import 'package:onpods/screens/podcast_screen/widgets/view_all_screen.dart';
import 'package:onpods/utils/exports.dart';

class PodcastCardTemplate extends StatefulWidget {
  final String categoryTitle;

  const PodcastCardTemplate({Key? key, required this.categoryTitle})
      : super(key: key);

  @override
  State<PodcastCardTemplate> createState() => _PodcastCardTemplateState();
}

class _PodcastCardTemplateState extends State<PodcastCardTemplate> {

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PodcastProvider>(context);

    return provider.trendingPodcasts.isEmpty
        ? const HomeSkeleton()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(left: 10),
                          decoration: const BoxDecoration(
                              border: Border(
                                  left:
                                      BorderSide(color: blueColor, width: 4))),
                          child: Text(
                            widget.categoryTitle,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 23.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Get.to(
                              ViewAllScreen(
                                title: widget.categoryTitle,
                                data: provider.trendingPodcasts[0].data,
                              ),
                              transition: Transition.cupertino),
                          child: Text(
                            'View All',
                            style: TextStyle(
                              fontSize: 18.sp,
                              color: blueColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: SizedBox(
                      height: 0.26.sh,
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: provider.trendingPodcasts[0].data!.length,
                        itemBuilder: (context, index) {
                          final data = provider.trendingPodcasts[0];
                          final itemData = data.data![index];
                          return GestureDetector(
                            onTap: () {
                              Get.to(
                                  DetailedPodcast(
                                    podcastId: itemData.id!,
                                    image: itemData.posterUrl!,
                                    title: itemData.title!,
                                    description: itemData.description!,
                                  ),
                                  transition: Transition.downToUp);
                            },
                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 14),
                                  child: Column(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(6),
                                        child: CachedNetworkImage(
                                          width: 0.4.sw,
                                          height: 0.2.sh,
                                          placeholder: (context, url) =>
                                              Image.asset(
                                            podcastPlaceHolder,
                                            scale: 3,
                                          ),
                                          imageUrl: itemData.posterUrl!,
                                          fit: BoxFit.cover,
                                          errorWidget: (context, url, error) =>
                                              Image.asset(
                                            podcastPlaceHolder,
                                            scale: 3,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      SizedBox(
                                        width: 0.4.sw,
                                        child: Text(
                                          itemData.title!,
                                          maxLines: 1,
                                          style: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            color: Colors.white,
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.normal,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (widget.categoryTitle ==
                                    'Trending Podcast') ...[
                                  Positioned(
                                    right: 0,
                                    child: Container(
                                        width: 0.4.sw,
                                        height: 0.2.sh,
                                        decoration: const BoxDecoration(
                                            gradient: LinearGradient(
                                                colors: [
                                              Colors.black87,
                                              Colors.black45,
                                              Colors.black26,
                                              Colors.transparent
                                            ],
                                                begin: Alignment.bottomRight,
                                                end: Alignment.centerRight))),
                                  ),
                                  Positioned(
                                    bottom: 20,
                                    right: 0,
                                    child: Text(
                                      '${index + 1}'.toString(),
                                      style: TextStyle(
                                          fontSize: 90.sp,fontWeight: FontWeight.bold, color: Colors.white),
                                    ),
                                  ),
                                ]
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
  }
}
