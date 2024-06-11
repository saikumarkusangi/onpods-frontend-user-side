import 'package:flutter_hud/flutter_hud.dart';
import 'package:onpods/utils/exports.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool searched = false;
  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PodcastProvider>(context);
    return WillPopScope(
      onWillPop: () async {
    provider.searchData.clear();
    return true; // Allow the screen to be popped
  },
      child: WidgetHUD(
        showHUD: provider.podcastCategories.isEmpty,
        hud: HUD(
            progressIndicator: Image.asset(
          liveGif,
          color: blueColor,
          scale: 3,
        )),
        builder: (context, child) => Scaffold(
          bottomNavigationBar: const MiniPlayer(),
          appBar: AppBar(
              automaticallyImplyLeading: false,
              iconTheme: const IconThemeData(color: Colors.white),
              toolbarHeight: 80,
              backgroundColor: Colors.black,
              flexibleSpace: Padding(
                  padding: const EdgeInsets.only(top: 50, left: 10, right: 10),
                  child: CustomTextFormField(
                    controller: controller,
                    autofocus: false,
                    radius: 10,
                    prefix: const Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Icon(
                        Icons.search_rounded,
                        color: Colors.grey,
                        size: 26,
                      ),
                    ),
                    hintText: "Search Podcast , Episode , People..",
                    vertical: 12,
                    fillColor: darktextFieldColor,
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 18.sp),
                    textStyle: const TextStyle(color: Colors.white),
                    onChanged: (String data) {
                      if (data.length > 2) {
                        provider.search(data, 1, 1, 1,context);
                      }
                    },
                    onSubmit: (String data) {
                      if (data.length > 2) {
                        provider.search(data, 1, 1, 1,context);
                      } else {
                        setState(() {
                          searched = true;
                        });
                      }
                    },
                  ))),
          body: searched && controller.text.length < 3
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Image.asset(
                        noSearch,
                        scale: 2,
                      ),
                      Text(
                        'Result Not Found',
                        style: TextStyle(
                            fontSize: 32.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Whoops....this information related to search is not avaliable',
                        style: TextStyle(
                            fontSize: 18.sp, color: Colors.grey.shade600),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                )
              : BrowseCategories(
                  query: controller.text,
                ),
        ),
      ),
    );
  }
}
