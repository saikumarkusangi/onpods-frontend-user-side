
import 'package:onpods/utils/exports.dart';


class PodcastScreen extends StatefulWidget {
  const PodcastScreen({super.key});

  @override
  State<PodcastScreen> createState() => _PodcastScreenState();
}

class _PodcastScreenState extends State<PodcastScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
          toolbarHeight: 80,
          backgroundColor: Colors.black,
          flexibleSpace:   Padding(
              padding: const EdgeInsets.only(top: 50, left: 60, right: 10),
              child: CustomTextFormField(
                autofocus: false,
                radius: 10,
                prefix: const Icon(
                  Icons.search_rounded,
                  color: Colors.grey,
                  size: 26,
                ),
                hintText: "Search...",
                vertical: 16,
                fillColor: darktextFieldColor,
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                textStyle: const TextStyle(color: Colors.white), onSubmit: (String data) {  },
              ))),
      // floatingActionButton: const CustomFAB(toPage: RecordPodcastBoarding()),
      body: const SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // PodcastCardTemplate(categoryTitle: 'Recommanded For You'),
            BrowseCategories()
          ],
        ),
      ),
    );
  }
}
