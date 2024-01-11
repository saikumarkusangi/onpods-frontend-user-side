import 'dart:convert';
import 'package:onpods/utils/exports.dart';

class MyListScreen extends StatefulWidget {
  const MyListScreen({Key? key}) : super(key: key);

  @override
  State<MyListScreen> createState() => _MyListScreenState();
}

class _MyListScreenState extends State<MyListScreen> {
  ValueNotifier<List<String>> selectedIndexes = ValueNotifier<List<String>>([]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const MiniPlayer(),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: darkscaffoldBackgroundColor,
        title: const Text(
          'My List',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          ValueListenableBuilder<List<String>>(
            valueListenable: selectedIndexes,
            builder: (context, value, child) {
              if (value.isNotEmpty) {
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: IconButton(
                    iconSize: 32,
                    onPressed: () {
                      _deleteSelectedPodcasts();
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  ),
                );
              } else {
                return const SizedBox();
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _getSavedPodcasts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Image.asset(
                liveGif,
                scale: 3,
                color: blueColor,
              ),
            );
          } else if (snapshot.hasError) {
            print(snapshot.error);
            return const Center(
              child: Text(
                'Error loading data',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            );
          } else if (snapshot.hasData && snapshot.data!.isEmpty) {
            return const Center(
              child: EmptyPlaceHolder(message: 'Nothing to show'),
            );
          } else {
            return ValueListenableBuilder(
              valueListenable: selectedIndexes,
              builder: (context, value, child) => GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                ),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final podcast = snapshot.data![index];
                  final isSelected = value.contains(podcast['id']);

                  return GestureDetector(
                    onTap: () {
                      if (isSelected) {
                        selectedIndexes.value =
                            List<String>.from(selectedIndexes.value)
                              ..remove(podcast['id']);
                      } else if (value.isNotEmpty) {
                        selectedIndexes.value =
                            List<String>.from(selectedIndexes.value)
                              ..add(podcast['id']);
                      } else {
                        Get.to(
                          DetailedPodcast(
                            title: podcast['title'],
                            image: podcast['posterUrl'],
                            description: podcast['description'],
                            podcastId: podcast['id'],
                          ),
                        );
                      }
                    },
                    onLongPress: () {
                      selectedIndexes.value =
                          List<String>.from(selectedIndexes.value)
                            ..add(podcast['id']);
                    },
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Column(
                            children: [
                              Ink(
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Colors.grey.withOpacity(0.5)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: CachedNetworkImage(
                                  imageUrl: podcast['posterUrl'] ?? '',
                                  imageBuilder: (context, imageProvider) =>
                                      ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      podcast['posterUrl'],
                                      width: 0.45.sw,
                                      height: 200,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Image.asset(
                                    podcastPlaceHolder,
                                    scale: 4,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                podcast['title'],
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isSelected) ...[
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          const Align(
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.check,
                              size: 42,
                              color: Colors.white,
                            ),
                          ),
                        ]
                      ],
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }

  Future<List<dynamic>> _getSavedPodcasts() async {
    final result = await UserServices().fetchMyList();
    print(result['myList']);
    return Future.value(result['myList']);
  }

  void _deleteSelectedPodcasts() async {
    final ids = selectedIndexes.value;

    try {
      final result = await UserServices().updateMyList(ids, 'remove');
      print(result);
   setState(() {
     
   });
      // Clear the selected indexes
    } catch (e) {
      print('$e');
      // Handle error
    } finally {
      selectedIndexes.value = [];
    }
  }
}
