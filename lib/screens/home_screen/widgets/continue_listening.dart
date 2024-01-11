import 'package:onpods/utils/exports.dart';

class ContinueListening extends StatefulWidget {
  const ContinueListening({Key? key}) : super(key: key);

  @override
  State<ContinueListening> createState() => _ContinueListeningState();
}

class _ContinueListeningState extends State<ContinueListening> {
  @override
  // void initState() {
  //   super.initState();
  //   final podcastProvider =
  //       Provider.of<PodcastProvider>(context, listen: false);
  //   podcastProvider.fetchTrendingPodcasts();
  // }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PodcastProvider>(context);

    // return provider.isLoading
    //     ? const HomeSkeleton()
    //     : provider.isLoading & provider.trendingPodcasts.isEmpty
    //         ? const SizedBox()
    //         : Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               Padding(
    //                 padding: const EdgeInsets.all(8.0),
    //                 child: Container(
    //                   padding: const EdgeInsets.only(left: 10),
    //                   decoration: const BoxDecoration(
    //                       border: Border(
    //                           left:
    //                               BorderSide(color: blueColor, width: 4))),
    //                   child: Text(
    //                     'Continue Listening',
    //                     style: TextStyle(
    //                       color: Colors.white,
    //                       fontSize: 23.sp,
    //                       fontWeight: FontWeight.bold,
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //               const SizedBox(height: 10),
    //               Padding(
    //                 padding: const EdgeInsets.only(top: 8, bottom: 8),
    //                 child: SizedBox(
    //                   height: 0.26.sh,
    //                   child: ListView.builder(
    //                     shrinkWrap: true,
    //                     scrollDirection: Axis.horizontal,
    //                     itemCount: provider.trendingPodcasts[0].data!.length,
    //                     itemBuilder: (context, index) {
    //                       final data = provider.trendingPodcasts[0];
    //                       final itemData = data.data![index];
    //                       return GestureDetector(
    //                         onTap: () {
    //                           Get.to(
    //                               DetailedPodcast(
    //                                 podcastId: itemData.id!,
    //                                 image: itemData.posterUrl!,
    //                                 title: itemData.title!,
    //                                 description: itemData.description!,
    //                               ),
    //                               transition: Transition.downToUp);
    //                         },
    //                         child: Stack(
    //                           children: [
    //                             Padding(
    //                               padding: const EdgeInsets.only(left: 14),
    //                               child: Column(
    //                                 children: [
    //                                   ClipRRect(
    //                                     borderRadius: BorderRadius.circular(6),
    //                                     child: CachedNetworkImage(
    //                                       width: 0.4.sw,
    //                                       height: 0.2.sh,
    //                                       placeholder: (context, url) =>
    //                                           Image.asset(
    //                                         podcastPlaceHolder,
    //                                         scale: 3,
    //                                       ),
    //                                       imageUrl: itemData.posterUrl!,
    //                                       fit: BoxFit.cover,
    //                                       errorWidget: (context, url, error) =>
    //                                           Image.asset(
    //                                         podcastPlaceHolder,
    //                                         scale: 3,
    //                                       ),
    //                                     ),
    //                                   ),
    //                                   const SizedBox(height: 10),
    //                                   SizedBox(
    //                                     width: 0.4.sw,
    //                                     child: Text(
    //                                       itemData.title!,
    //                                       maxLines: 1,
    //                                       style: TextStyle(
    //                                         overflow: TextOverflow.ellipsis,
    //                                         color: Colors.white,
    //                                         fontSize: 16.sp,
    //                                         fontWeight: FontWeight.normal,
    //                                       ),
    //                                       textAlign: TextAlign.center,
    //                                     ),
    //                                   ),
    //                                 ],
    //                               ),
    //                             ),

    //                           ],
    //                         ),
    //                       );
    //                     },
    //                   ),
    //                 ),
    //               ),
    //             ],
    //           );
    return SizedBox();
  }
}
