import 'package:onpods/models/podcast_category_model.dart';
import 'package:onpods/screens/podcast_screen/widgets/search_view_all.dart';
import 'package:onpods/utils/exports.dart';
import '../../screens_exports.dart';

class BrowseCategories extends StatefulWidget {
  const BrowseCategories({super.key, required this.query});
  final String query;

  @override
  State<BrowseCategories> createState() => _BrowseCategoriesState();
}

class _BrowseCategoriesState extends State<BrowseCategories> {
  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  fetchCategories() async {
    final categoryProvider =
        Provider.of<PodcastProvider>(context, listen: false);
    if (categoryProvider.podcastCategories.isEmpty) {
      await categoryProvider.fetchCategories();
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PodcastProvider>(context);
    final data = provider.searchData;
    final List<PodcastCategoryModel> filteredCategories = provider
        .podcastCategories
        .where((category) => category.data == true)
        .toList();

    if ( provider.searchData.isNotEmpty && provider.searchData['podcasts']['items'].isEmpty &&
        provider.searchData['episodes'].isEmpty &&
        provider.searchData['users']['items'].isEmpty ) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(

          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20,),
            Image.asset(noSearch,scale: 2,),
            Text('Result Not Found',style: TextStyle(
              fontSize: 32.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white
            ),),
            const SizedBox(height: 10,),
            Text('Whoops....this information related to search is not avaliable',style: TextStyle(
              fontSize: 18.sp,

              color: Colors.grey.shade600
            ),
            textAlign: TextAlign.center,
            )
          ],
        ),
      );
    }
    if (provider.searchData.isNotEmpty) {
      return GestureDetector(
        onTap: ()=>   FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (data['users']['items'].isNotEmpty) ...[
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'People',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Get.to(
                              ViewAllUsers(data: data['users']['items']),
                              transition: Transition.cupertino),
                          child: Text(
                            'View All',
                            style: TextStyle(
                              fontSize: 15.sp,
                              color: blueColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: double.maxFinite,
                    height: 0.2.sh,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: data['users']['items'].length > 10
                          ? 10
                          : data['users']['items'].length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final item = data['users']['items'][index];
                        return _buildUserItem(item);
                      },
                    ),
                  ),
                ],
                if (data['podcasts']['items'].isNotEmpty) ...[
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Podcasts',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {

                            Get.to(
                              SearchViewAllScreen(
                                title: 'Podcasts',
                                data: data['podcasts']['items'],
                                query: widget.query,
                              ),
                              transition: Transition.cupertino);
                          },
                          child: Text(
                            'View All',
                            style: TextStyle(
                              fontSize: 15.sp,
                              color: blueColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 0.26.sh,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: data['podcasts']['items'].length,
                      itemBuilder: (context, index) {
                        return _buildPodcastItem(
                            data['podcasts']['items'][index]);
                      },
                    ),
                  ),
                ],
                if (data['episodes'].isNotEmpty) ...[
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Text(
                      'Episodes',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: data['episodes'].length,
                    itemBuilder: (context, index) {
                      final item = data['episodes'][index];
                      return _buildEpisodeItem(item);
                    },
                  ),
                ],
              ],
            ),
          ),
        ),
      );
    } else {
      return provider.podcastCategories.isEmpty
          ? const PodcastCategoriesSkeleton()
          : (provider.podcastCategories.isEmpty
              ? const Center(
                  heightFactor: 3,
                  child: EmptyPlaceHolder(message: ''),
                )
              : SingleChildScrollView(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 10, left: 10, right: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Podcast Categories",
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15, bottom: 15),
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: filteredCategories.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              childAspectRatio: 16 / 10,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              crossAxisCount: 2,
                            ),
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () => Get.to(
                                    () => SinglePodcastCategory(
                                          title: filteredCategories[index].name,
                                          categoryId:
                                              filteredCategories[index].id,
                                        ),
                                    transition: Transition.cupertino),
                                child: _buildCategoryItem(
                                    filteredCategories[index]),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ));
    }
  }

  Widget _buildEpisodeItem(episodeItem) {
    return Column(
        children: (episodeItem['episodes'] as List<dynamic>).map<Widget>((e) {
      return GestureDetector(
        onTap: () {
          Get.to(PlayerScreen(
              poster: e['posterUrl'] ?? episodeItem['posterUrl'],
              title: episodeItem['title'] ?? e['title'],
              episode: e['_id'],
              playlist: [e],
              audioUrl: e['audioUrl'],
              startingIndex: 0,
              albumImage: episodeItem['posterUrl'],
              podcastId: episodeItem['_id'],
              episodeId: e['_id']));
        },
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: CachedNetworkImage(
                  width: 0.3.sw,
                  height: 0.15.sh,
                  fit: BoxFit.cover,
                  imageUrl: e['posterUrl'] ?? episodeItem['posterUrl'],
                  errorWidget: (context, url, error) =>
                      Image.asset(podcastPlaceHolder),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      e['title'] ?? '',
                      maxLines: 4,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 20.sp,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    RichText(
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                      softWrap: true,
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: e['description'] ?? '',
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 15.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }).toList());
  }

  Widget _buildUserItem(dynamic userItem) {
    String userId = userItem['id'];

    final CurrentuserId = UserSession.getUserId();
    return GestureDetector(
      onTap: () {
        Get.to(
          CurrentuserId != userId
              ? UserProfileScreen(
                  userId: userId,
                  userName: userItem['username'],
                )
              : const ProfileScreen(),
          transition: Transition.cupertino,
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Column(
          children: [
            Container(
              width: 0.25.sw,
              height: 0.12.sh,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 236, 184, 202),
                borderRadius: BorderRadius.circular(60),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(60),
                child: CachedNetworkImage(
                  imageUrl: userItem['profilePic'],
                  placeholder: (context, url) => Center(
                    child: Text(
                      userItem['username']?.substring(0, 1)?.toUpperCase() ??
                          '',
                      style: TextStyle(
                        fontSize: 28.sp,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Center(
                    child: Text(
                      userItem['username']?.substring(0, 1)?.toUpperCase() ??
                          '',
                      style: TextStyle(
                        fontSize: 28.sp,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              userItem['username'],
              style: TextStyle(color: Colors.white, fontSize: 16.sp),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPodcastItem(itemData) {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: GestureDetector(
        onTap: () {
          Get.to(
              DetailedPodcast(
                podcastId: itemData['_id'],
                image: itemData['posterUrl'],
                title: itemData['title'],
                description: itemData['description'],
              ),
              transition: Transition.downToUp);
        },
        child: SizedBox(
          width: 0.4.sw,
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  itemData['posterUrl']!,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                  width: 0.4.sw,
                  height: 0.2.sh,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                itemData['title']!,
                maxLines: 1,
                style: TextStyle(
                  overflow: TextOverflow.ellipsis,
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.normal,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryItem(PodcastCategoryModel category) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Color(int.parse('0xFF${category.color}')),
            ),
          ),
          Positioned(
            right: -10,
            bottom: -20,
            child: Transform.rotate(
              angle: 45 * 2 / 180,
              child: Container(
                width: 0.25.sw,
                height: 0.12.sh,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: NetworkImage(category.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          // Text
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: SizedBox(
                width: 0.35.sw,
                child: Text(
                  category.name,
                  maxLines: 3,
                  style: TextStyle(
                    fontSize: 22.sp,
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ViewAllUsers extends StatelessWidget {
  final List data;
  const ViewAllUsers({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const MiniPlayer(),
      appBar: AppBar(
        title: const Text(
          'People',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
      ),
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: data.length,
        itemBuilder: (context, index) {
          String userId = data[index]['id'];

          final CurrentuserId = UserSession.getUserId();
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: GestureDetector(
              onTap: () {
                Get.to(
                  CurrentuserId != userId
                      ? UserProfileScreen(
                          userId: userId,
                          userName: data[index]['username'],
                        )
                      : const ProfileScreen(),
                  transition: Transition.cupertino,
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 0.19.sw,
                    height: 0.09.sh,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 236, 184, 202),
                      borderRadius: BorderRadius.circular(60),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(60),
                      child: CachedNetworkImage(
                        imageUrl: data[index]['profilePic'],
                        placeholder: (context, url) => Center(
                          child: Text(
                            data[index]['username']
                                    ?.substring(0, 1)
                                    ?.toUpperCase() ??
                                '',
                            style: TextStyle(
                              fontSize: 20.sp,
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Center(
                          child: Text(
                            data[index]['username']
                                    ?.substring(0, 1)
                                    ?.toUpperCase() ??
                                '',
                            style: TextStyle(
                              fontSize: 28.sp,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Text(
                    data[index]['username'],
                    style: TextStyle(color: Colors.white, fontSize: 20.sp),
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
