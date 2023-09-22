import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:onpods/providers/dummy_provider.dart';
import 'package:onpods/screens/podcast_screen/detailed_podcast.dart';
import 'package:onpods/screens/podcast_screen/widgets/list_skeleton.dart';
import 'package:onpods/screens/quotes_screen/single_quote.dart';
import 'package:provider/provider.dart';
import '../../utils/utils_exports.dart';

class SingleCategoryQuote extends StatefulWidget {
  final String title;
  final String image;
  const SingleCategoryQuote(
      {super.key, required this.title, required this.image});

  @override
  State<SingleCategoryQuote> createState() => _SingleCategoryQuoteState();
}

class _SingleCategoryQuoteState extends State<SingleCategoryQuote> {
  //  @override
  // void initState() {
  //   super.initState();
  //   final dummyProvider =
  //       Provider.of<DummyProvider>(context, listen: false);
  //   dummyProvider.fetchData();
  // }

  List data = [
    'https://i.pinimg.com/236x/41/57/b9/4157b9cc432058081970c0aa350ab08a.jpg',
    'https://cdn-0.therandomvibez.com/wp-content/uploads/2021/03/Love-Quotes-For-Him-Pictures.jpg',
    'https://www.heloplus.com/wp-content/uploads/2023/01/love-quotes-for-husband-in-english.jpg',
    'https://funkylife.in/wp-content/uploads/2021/08/love-quotes-3.jpg',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRahhd-F81iC4ATLWZZFaLRIiTs6-iFHEhtow&usqp=CAU',
    'https://englishstudyonline.org/wp-content/uploads/2023/03/love-quotes-1.png',
    'https://hips.hearstapps.com/hmg-prod/images/romantic-quote6-1607544968.png?resize=480:*'
  ];

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
                child:Image.asset(
                 emptyImage,
                ),
              ),
            )
          else
            SliverToBoxAdapter(
                child: StaggeredGrid.count(
                    crossAxisCount: 2,
                    children: data
                        .map((e) => GestureDetector(
                          onTap: ()=>Get.to(SingleQuote(image: e),
                          transition: Transition.rightToLeftWithFade),
                          child: Padding(
                                padding: const EdgeInsets.all(4),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Image.network(e),
                                ),
                              ),
                        ))
                        .toList()))
        ]),
      ),
    );
  }
}
