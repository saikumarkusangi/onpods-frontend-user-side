import 'package:onpods/utils/exports.dart';

class ViewAllScreen extends StatelessWidget {
  final String title;
  final data;
  const ViewAllScreen({Key? key, required this.title, required this.data})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const MiniPlayer(),
      appBar: AppBar(
        title: Text(
          title,
          style: TextStyle(color: Colors.white, fontSize: 24.sp),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
      ),
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: data.length,
        itemBuilder: (context, index) {
          final podcast = data[index];

          return GestureDetector(
            onTap: () => Get.to(
                DetailedPodcast(
                    podcastId: podcast.id!,
                    description: podcast.description ?? '',
                    image: podcast.posterUrl ?? '',
                    title: podcast.title ?? ''),
                transition: Transition.downToUp),
            child: Container(
               padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      SizedBox(
                        height: 150,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.width * 0.4,
                            imageUrl: podcast.posterUrl!,
                            placeholder: (context, url) => Image.asset(
                              podcastPlaceHolder,
                              scale: 3,
                            ),
                            errorWidget: (context, url, error) =>
                                Image.asset(podcastPlaceHolder),
                          ),
                        ),
                      ),
                      if (title == 'Trending Podcast') ...[
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
                          bottom: -20,
                          right: 0,
                          child: Text(
                            '${index + 1}'.toString(),
                            style:
                                TextStyle( fontSize: 90.sp,fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                      ]
                    ],
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.485,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          podcast.title ?? '',
                          maxLines: 3,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 22.sp,
                              overflow: TextOverflow.ellipsis),
                        ),
                        Row(

                          children: [
                            const Icon(Icons.star,color: Colors.yellow,),
                            const SizedBox(width: 10,),
                            Text('4.2',style: TextStyle(color: Colors.grey.shade500,fontSize: 16.sp),),
                            const SizedBox(width: 10,),
                            Text('| 200 plays',style: TextStyle(color: Colors.grey.shade500,fontSize: 16.sp),)
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: RichText(
                              overflow: TextOverflow.ellipsis,
                              maxLines: 6,
                              text: TextSpan(
                                text: podcast.description ?? '',
                                style: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 16.sp,
                                ),
                              )),
                        ),

                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
