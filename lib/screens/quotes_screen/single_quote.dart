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
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.3),
                  borderRadius: const BorderRadius.only(
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
                            onTap: _showBottomSheet,
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
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          trailing: Container(
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
                          ),
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
          ],
        ),
      )),
    );
  }

  void _showBottomSheet() {
    showModalBottomSheet(
        context: context,
        showDragHandle: true,
        constraints: const BoxConstraints(maxHeight: 275),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: const Color.fromARGB(255, 48, 47, 47),
        builder: (context) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ListTile(
                leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.blue.shade200,
                        borderRadius: BorderRadius.circular(40)),
                    child: const Icon(
                      Icons.share,
                      color: Colors.black,
                    )),
                title: const Text(
                  'Share',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
              ListTile(
                leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.purple.shade200,
                        borderRadius: BorderRadius.circular(40)),
                    child: const Icon(
                      Icons.download,
                      color: Colors.white,
                    )),
                title: const Text(
                  'Download',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
              ListTile(
                leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.redAccent.shade200,
                        borderRadius: BorderRadius.circular(40)),
                    child: const Icon(
                      Icons.report,
                      color: Colors.white,
                    )),
                title: const Text(
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
