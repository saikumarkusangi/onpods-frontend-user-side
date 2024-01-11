import 'package:onpods/utils/exports.dart';


class BackGroundImages extends StatefulWidget {
  const BackGroundImages({Key? key}) : super(key: key);
  @override
  State<BackGroundImages> createState() => _BackGroundImagesState();
}

class _BackGroundImagesState extends State<BackGroundImages> {
  @override
  Widget build(BuildContext context) {
    int page = Random().nextInt(10) + 1;
    final bgProvider = Provider.of<BackGroundProvider>(context);
    final bgOpacityProvider = Provider.of<BackGroundProvider>(context);

    return SafeArea(
      child: Scaffold(
         bottomNavigationBar: const MiniPlayer(),
        backgroundColor: Colors.black,
        appBar: AppBar(
          toolbarHeight: 80,
          backgroundColor: Colors.black,
          automaticallyImplyLeading: false,
          title: CustomTextFormField(
            onSubmit: (query) {
              bgProvider.fetchBackGroundImages(query, page);
            },
            autofocus: false,
            radius: 10,
            prefix: const Icon(
              Icons.search_rounded,
              color: Colors.grey,
              size: 26,
            ),
            hintText: "Search category, name & more...",
            vertical: 16,
            fillColor: darktextFieldColor,
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
            textStyle: const TextStyle(color: Colors.white),
          ),
        ),
        resizeToAvoidBottomInset: false,
        body: bgProvider.isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: blueColor,
                ),
              )
            : bgProvider.data.isEmpty
                ? Center(
                    child: SvgPicture.asset(
                      backgoundImageSearchLogo,
                      color: Colors.white,
                      width: MediaQuery.of(context).size.width * 0.8,
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: bgProvider.data[0].photos.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10),
                    itemBuilder: (context, index) {
                      String images =
                          bgProvider.data[0].photos[index].src.original;
                      return InkWell(
                          onTap: () {
                            bgOpacityProvider.updateLastSelected(3);
                            Get.back(result: images);
                          },
                          child: CacheImage(image: images));
                    }),
      ),
    );
  }

  // Future<void> _scrollListiner() async {
  //     final bgProvider = Provider.of<BackGroundProvider>(context);
  //   if (_scrollController.position.pixels ==
  //       _scrollController.position.maxScrollExtent) {
  //     setState(() {
  //       isLoading = true;
  //     });
  //     await    bgProvider.fetchBackGroundImages('rain', page);
  //     page = page + 1;
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }
}
