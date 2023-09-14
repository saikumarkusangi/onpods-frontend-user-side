import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onpods/providers/dummy_provider.dart';
import 'package:onpods/screens/home_screen/widgets/home_skeleton.dart';
import 'package:onpods/screens/podcast_screen/detailed_podcast.dart';
import 'package:onpods/screens/podcast_screen/widgets/list_skeleton.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';

import '../../providers/providers_exports.dart';
import '../../utils/utils_exports.dart';

class SinglePodcastCategory extends StatefulWidget {
  final String title;
  final String image;
  const SinglePodcastCategory(
      {super.key, required this.title, required this.image});

  @override
  State<SinglePodcastCategory> createState() => _SinglePodcastCategoryState();
}

class _SinglePodcastCategoryState extends State<SinglePodcastCategory> {
  @override
  void initState() {
    super.initState();
    final dummyProvider = Provider.of<DummyProvider>(context, listen: false);
    dummyProvider.fetchData();
  }

  @override
  Widget build(BuildContext context) {
    final dummyProvider = Provider.of<DummyProvider>(context);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          dummyProvider.fetchData();
        },
        child: CustomScrollView(slivers: [
          SliverAppBar.large(
            backgroundColor: scaffoldBackgroundColor,
            expandedHeight: 180,
            leading: IconButton(
              iconSize: 28,
              onPressed: () => Get.back(),
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            ),
            snap: false,
            title: Text(
              widget.title,
              style: const TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.w400),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  CachedNetworkImage(
                    width: double.maxFinite,
                    height: 230,
                    imageUrl: widget.image,
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                  ),
                  Container(
                    width: double.maxFinite,
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Colors.black87, Colors.black12],
                            begin: Alignment.bottomCenter,
                            end: Alignment.center)),
                  ),
                  Positioned(
                    bottom: 10,
                    left: 20,
                    child: Text(
                      widget.title,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      style: const TextStyle(
                          overflow: TextOverflow.ellipsis,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 42),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (dummyProvider.isLoading)
            const SliverToBoxAdapter(
              child: ListSkeleton(),
            )
          else if (dummyProvider.data.isEmpty)
            SliverToBoxAdapter(
              child: Center(
                child: Image.network(
                  'https://cdni.iconscout.com/illustration/premium/thumb/empty-box-4344460-3613888.png',
                ),
              ),
            )
          else
            SliverList.builder(
                itemCount: dummyProvider.data.length,
                itemBuilder: (context, index) {
                  final dummy = dummyProvider.data[index];
                  return GestureDetector(
                    onTap: () => Get.to(
                        DetailedPodcast(
                            description: dummy.description,
                            image: dummy.posterUrl,
                            episodes: dummy.episodes,
                            rating: double.parse(dummy.rating),
                            title: dummy.title),
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
                                  imageUrl: dummy.posterUrl),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.485,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  dummy.title,
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
                                  dummy.description,
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
    );
  }
}
