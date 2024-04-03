import 'dart:io';

import 'package:onpods/utils/exports.dart';

class SingleQuote extends StatefulWidget {
  final String image;
  final String userId;
  final String postId;
  const SingleQuote(
      {super.key,
      required this.image,
      required this.userId,
      required this.postId});

  @override
  State<SingleQuote> createState() => _SingleQuoteState();
}

class _SingleQuoteState extends State<SingleQuote> {
  late String userId;
  @override
  void initState() {
    super.initState();
    _getUserId();
  }

  _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('user_id')!;
  }

  @override
  Widget build(BuildContext context) {
     final quoteProvider = Provider.of<QuoteProvider>(context, listen: false);
    return Scaffold(
      bottomNavigationBar: const MiniPlayer(),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20))),
              child: Column(
                children: [
                  InkWell(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        ClipRRect(
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20)),
                            child: CachedNetworkImage(
                                width: double.maxFinite,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                imageUrl: widget.image)),
                        Positioned(
                          left: 10,
                          top: 10,
                          child: InkWell(
                            onTap: () => Get.back(),
                            child: Container(
                                width: 45,
                                height: 45,
                                decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.4),
                                    borderRadius: BorderRadius.circular(50)),
                                child: const Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Icon(
                                      Icons.arrow_back_ios,
                                      color: Colors.white,
                                      size: 28,
                                    ))),
                          ),
                        ),
                        Positioned(
                          right: 10,
                          top: 10,
                          child: InkWell(
                            onTap: () => _showBottomSheet(widget.image),
                            child: Container(
                                width: 45,
                                height: 45,
                                decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.4),
                                    borderRadius: BorderRadius.circular(50)),
                                child: const Icon(
                                  Icons.more_vert,
                                  color: Colors.white,
                                  size: 28,
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  FutureBuilder(
                      future: UserServices().userById(widget.userId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const SizedBox();
                        }
                        return ListTile(
                          leading: GestureDetector(
                            onTap: () {
                              Get.to(
                                  userId != widget.userId
                                      ? UserProfileScreen(
                                          userId: widget.userId,
                                          userName: snapshot.data['username'],
                                        )
                                      : const ProfileScreen(),
                                  transition: Transition.cupertino);
                            },
                            child: Container(
                              width: 45,
                              height: 45,
                              decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 236, 184, 202),
                                  borderRadius: BorderRadius.circular(60)),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(60),
                                child: CachedNetworkImage(
                                  imageUrl: snapshot.data['profilePic'],
                                  placeholder: (context, url) => Center(
                                    child: Text(
                                      snapshot.data['username']
                                          .substring(0, 1)
                                          .toUpperCase(),
                                      style: const TextStyle(fontSize: 24),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) => Center(
                                    child: Text(
                                      snapshot.data['username']
                                          .substring(0, 1)
                                          .toUpperCase(),
                                      style: const TextStyle(fontSize: 24),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          title: GestureDetector(
                            onTap: () => Get.to(
                                UserProfileScreen(
                                  userId: widget.userId,
                                  userName: snapshot.data['username'],
                                ),
                                transition: Transition.cupertino),
                            child: Text(
                              snapshot.data['username'] ?? '',
                              maxLines: 1,
                              style: const TextStyle(
                                  color: Colors.white,
                                  overflow: TextOverflow.ellipsis,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20),
                            ),
                          ),
                          trailing: widget.userId != userId
                              ? Container(
                                  width: 80,
                                  height: 40,
                                  decoration: BoxDecoration(
                                      color: blueColor,
                                      borderRadius: BorderRadius.circular(40)),
                                  child: const Center(
                                    child: Text(
                                      'Follow',
                                      maxLines: 1,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          overflow: TextOverflow.ellipsis,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                )
                              : null,
                        );
                      })
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 10, left: 10, top: 20),
              child: Text(
                'Similar Quotes',
                style: TextStyle(color: Colors.white, fontSize: 23),
              ),
            ),
            const SizedBox(height: 20,),
            SizedBox(
              width: double.maxFinite,
             
              child: GridView.builder(
                itemCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(Radius.circular(6)),
                        child: CachedNetworkImage(imageUrl:quoteProvider.quotes[0].datas[0].imageUrl,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) => Image.asset(imagePlaceHolder),
                        placeholder: (context, imageProvider) => Shimmer.fromColors(baseColor: Colors.grey.shade200, highlightColor: Colors.grey.shade400, child: const SizedBox(width: 200,height: 300,)),
                        ),
                      ),
                    );
                  }),
            )
          ],
        ),
      )),
    );
  }

  void _showBottomSheet(imageUrl) {
    showModalBottomSheet(
        context: context,
        showDragHandle: true,
        constraints: const BoxConstraints(maxHeight: 250),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: const Color.fromARGB(255, 48, 47, 47),
        builder: (context) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () async {
                  Get.back();
                  final bytes = await NetworkAssetBundle(Uri.parse(imageUrl))
                      .load(imageUrl);

                  final tempDir = await getTemporaryDirectory();
                  final tempFile = File('${tempDir.path}/temp_image.jpg');
                  await tempFile.writeAsBytes(bytes.buffer.asUint8List());
                  await Share.shareFiles(
                    [tempFile.path],
                    text:
                        'https://chat.openai.com/c/592c71e8-43aa-48fe-acf3-0f6d3f0b6d19',
                    subject: 'Share Quote',
                  );
                },
                child: const ListTile(
                  leading: Icon(
                    Icons.share,
                    color: Colors.white,
                    size: 28,
                  ),
                  title: Text(
                    'Share',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ),
              ),
              const ListTile(
                leading: Icon(
                  Icons.download,
                  color: Colors.white,
                  size: 28,
                ),
                title: Text(
                  'Download',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
              const ListTile(
                leading: Icon(
                  Icons.report,
                  color: Colors.white,
                  size: 28,
                ),
                title: Text(
                  'Report',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
              widget.userId == userId
                  ? ListTile(
                      onTap: () async {
                        Get.back();
                        final result = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor:
                                const Color.fromARGB(255, 46, 45, 45),
                            title: const Text(
                              'Are you sure?',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            content: const Text(
                              'This action will permanently delete this post',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text(
                                  'Cancel',
                                  style:
                                      TextStyle(color: blueColor, fontSize: 18),
                                ),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text(
                                  'Delete',
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 18),
                                ),
                              ),
                            ],
                          ),
                        );

                        if (result == null || !result) {
                          return;
                        } else {
                          final res =
                              await QuoteService().deleteQuotes(widget.postId);
                          if (res) {
                            showSnackbar('Success', 'Post Deleted Sucessfully');
                          } else {
                            showSnackbar('Failed', 'Something went wrong');
                          }
                        }
                      },
                      leading: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.red.shade200,
                              borderRadius: BorderRadius.circular(40)),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                          )),
                      title: const Text(
                        'Delete',
                        style: TextStyle(color: Colors.white, fontSize: 24),
                      ),
                    )
                  : const SizedBox()
            ],
          );
        });
  }
}
