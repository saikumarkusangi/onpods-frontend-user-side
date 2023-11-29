import 'package:onpods/utils/exports.dart';

class BrowseAllCard extends StatefulWidget {
  const BrowseAllCard({super.key});

  @override
  State<BrowseAllCard> createState() => _BrowseAllCardState();
}

class _BrowseAllCardState extends State<BrowseAllCard> {
  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  fetchCategories() async {
    final categoryProvider =
        Provider.of<PodcastProvider>(context, listen: false);
    if(categoryProvider.podcastCategories.isEmpty){
  await categoryProvider.fetchCategories();
    }
  
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PodcastProvider>(context);
    return Padding(
      padding: const EdgeInsets.only(top: 15, bottom: 15),
      child: SizedBox(
        child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: provider.podcastCategories.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 16 / 10,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                crossAxisCount: 2),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => Get.to(
                    () => SinglePodcastCategory(
                          title: provider.podcastCategories[index].name,
                          categoryId:provider.podcastCategories[index].id
                        ),
                    transition: Transition.cupertino),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(4)),
                  child: Stack(
                    children: [
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              image: DecorationImage(
                                  image: NetworkImage(
                                    provider.podcastCategories[index].imageUrl,
                                  ),
                                  fit: BoxFit.contain)),
                          width: 100,
                          height: 70,
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            child: Text(
                              provider.podcastCategories[index].name,
                              maxLines: 2,
                              style: const TextStyle(
                                  fontSize: 20,
                                  overflow: TextOverflow.ellipsis,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}
