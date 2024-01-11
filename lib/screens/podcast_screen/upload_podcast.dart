import 'dart:io';
import 'package:flutter_hud/flutter_hud.dart';
import 'package:onpods/utils/exports.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PodcastUploadPage extends StatefulWidget {
  final String audio;
  const PodcastUploadPage({super.key, required this.audio});

  @override
  State<PodcastUploadPage> createState() => _PodcastUploadPageState();
}

class _PodcastUploadPageState extends State<PodcastUploadPage> {
  List data = [];
  bool isloading = false;
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  fetchData() async {
    try {
      final userId = await UserSession.getUserId();
      setState(() {
        isloading = true;
        PodcastService().podcastsByUserId(userId).then((result) {
          setState(() {
            data = result;
          });
        }).catchError((error) {
          print("Error fetching data: $error");
        });
      });
    } finally {
      setState(() {
        isloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bottomNavigationBar: const MiniPlayer(),
      appBar: AppBar(
        backgroundColor: blueColor,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Select Podcast',
          style: TextStyle(color: Colors.white, fontSize: 26.sp),
        ),
      ),
      body: WidgetHUD(
        showHUD: isloading,
        hud: HUD(
            progressIndicator: Image.asset(
          liveGif,
          color: blueColor,
          scale: 3,
        )),
        builder: (context, child) => SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (data.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      'Add to previous podcast',
                      style: TextStyle(color: Colors.white, fontSize: 24.sp),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ConstrainedBox(
                    constraints: BoxConstraints.loose(Size(double.maxFinite,
                        MediaQuery.of(context).size.height * 0.6)),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: ListTile(
                            leading: CachedNetworkImage(
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                              imageUrl: data[index]['posterUrl'],
                              errorWidget: (context, url, error) =>
                                  Image.asset(podcastPlaceHolder),
                            ),
                            title: Text(
                              data[index]['title'],
                              maxLines: 2,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.sp,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            trailing: IconButton(
                              iconSize: 38.sp,
                              onPressed: () => Get.to(
                                FinalUploadPage(
                                  imagePath: data[index]['posterUrl'],
                                  index: 0,
                                  audio: widget.audio,
                                  podcastId: data[index]['podcastId'],
                                  title: data[index]['title']
                                ),
                                transition: Transition.cupertino,
                              ),
                              icon: const Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Text(
                      'OR',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 20.sp),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
                if (!isloading) ...[
                  Center(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize: Size(0.8.sw, 50),
                            backgroundColor: blueColor),
                        onPressed: () => Get.to(
                            FinalUploadPage(
                              index: 1,
                              imagePath: '',
                              podcastId: '',
                              audio: widget.audio,
                              title: '',
                            ),
                            transition: Transition.cupertino),
                        child: Text(
                          'Create New Podcast',
                          style:
                              TextStyle(color: Colors.white, fontSize: 20.sp),
                        )),
                  )
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FinalUploadPage extends StatefulWidget {
  const FinalUploadPage(
      {super.key,
      required this.index,
      required this.imagePath,
      required this.audio,
      required this.title,
      required this.podcastId});
  final String audio;
  final String podcastId;
  final int index;
  final String title;
  final String imagePath;
  @override
  FinalUploadPageState createState() => FinalUploadPageState();
}

class FinalUploadPageState extends State<FinalUploadPage> {
  String selectedChipIndex = '';
  bool loading = false;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FocusNode titleFocusNode = FocusNode();
  FocusNode descriptionFocusNode = FocusNode();
  String selectedMaturityRating = 'U';
  String pickedImage = '';
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  fetchData() async {
    final provider = Provider.of<PodcastProvider>(context, listen: false);
    if (provider.podcastCategories.isEmpty) {
      await provider.fetchCategories();
      setState(() {});
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    titleFocusNode.dispose();
    descriptionFocusNode.dispose();
    super.dispose();
  }

  Future<void> handleUpload() async {
    String title = titleController.text;
    String description = descriptionController.text;

    if (_formKey.currentState!.validate()) {
      if (widget.index == 1) {
        if (selectedChipIndex != '') {
          setState(() {
            loading = true;
          });
          try {
            final res = await PodcastService().uploadPodcast(title, description,
                selectedChipIndex, pickedImage, selectedMaturityRating);

            if (res['status'] == 'success') {
              showSnackbar('Successful', 'Podcast Uploaded Successfully');
              Navigator.pop(context);
              await Get.to(FinalUploadPage(
                  index: 0,
                  title: title,
                  imagePath: res['posterUrl'],
                  audio: widget.audio,
                  podcastId: res['podcastId']));
            } else {
              showSnackbar('Fail', 'Something went wrong');
            }
          } finally {
            setState(() {
              loading = false;
            });
          }
        } else {
          Fluttertoast.showToast(msg: 'Please Select Category');
        }
      } else {
        setState(() {
          loading = true;
        });
        try {
          final res = await PodcastService().uploadEpisode(
              title, description, widget.audio, widget.podcastId, pickedImage);
          if (res) {
            showSnackbar('Successful', 'Episode Uploaded Successfully');
            Get.off(const Layout());
            PodcastService().newEpisodeNotification(widget.title,title, widget.podcastId);
          } else {
            showSnackbar('Fail', 'Something went wrong');
          }
        } finally {
          setState(() {
            loading = false;
          });
        }
      }
    }
  }

  // Create a webview controller
  final _controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setNavigationDelegate(
      NavigationDelegate(
        onPageStarted: (String url) {},
        onPageFinished: (String url) {},
        onWebResourceError: (WebResourceError error) {},
        onNavigationRequest: (NavigationRequest request) {
          return NavigationDecision.navigate;
        },
      ),
    )
    ..loadRequest(Uri.parse("https://www.canva.com/book-covers/templates/"));

  void _showWebView() {
    Get.to(() => WillPopScope(
          onWillPop: () async {
            // Check if the WebView can go back
            if (await _controller.canGoBack()) {
              // If it can, go back and prevent the default behavior
              _controller.goBack();
              return false;
            }
            // If the WebView cannot go back, allow the default behavior (close the WebView)
            return true;
          },
          child: SafeArea(
            child: Scaffold(
                body: WebViewWidget(
              controller: _controller,
            )),
          ),
        ));
  }

  void _buttomSheet() {
    showModalBottomSheet(
        showDragHandle: true,
        barrierColor: const Color.fromARGB(170, 0, 0, 0),
        constraints:
            const BoxConstraints(maxHeight: 250, minWidth: double.maxFinite),
        backgroundColor: const Color.fromARGB(255, 34, 33, 33),
        context: context,
        shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(10)),
        builder: (context) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ListTile(
                    onTap: () {
                      _pickImage();
                      Get.back();
                    },
                    leading: Image.asset(
                      galleryIcon,
                      color: Colors.white,
                      scale: 12,
                    ),
                    title: const Text(
                      'Pick From Gallery',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Get.back();
                      _showWebView();
                    },
                    leading: Image.asset(
                      designIcon,
                      scale: 2.2,
                    ),
                    title: const Text(
                      'Create New',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  )
                ])));
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        pickedImage = pickedFile.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PodcastProvider>(context, listen: false);

    List<Widget> chipWidgets =
        provider.podcastCategories.asMap().entries.map((entry) {
      final index = entry.value.id;
      final category = entry.value;

      BorderRadiusGeometry borderRadius = BorderRadius.circular(40);

      return ChoiceChip(
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius,
        ),
        label: Text(category.name),
        checkmarkColor: Colors.white,
        selectedColor: blueColor,
        labelStyle: TextStyle(
            color: selectedChipIndex == index ? Colors.white : Colors.black),
        selected: selectedChipIndex == index,
        onSelected: (bool selected) {
          setState(() {
            if (selected) {
              if (selectedChipIndex == '') {
                selectedChipIndex = index;
              } else if (selectedChipIndex != '') {
                selectedChipIndex = index;
              }
            }
          });
        },
      );
    }).toList();
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: blueColor,
        title: Text(
          widget.index == 0 ? 'Episode Details' : 'Podcast Details',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: loading
          ? Container(
              color: Colors.white,
              width: double.maxFinite,
              height: double.maxFinite,
              child: Column(
                children: [
                  Image.asset(uploadingGif),
                  Text(
                    'Uploading...',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 32.sp,
                        fontWeight: FontWeight.w500),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                    child: Text(
                      'Your podcast is uploading to cloud,Please wait it will take few seconds..',
                      style: TextStyle(
                        color: Colors.black38,
                        fontSize: 20.sp,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      const SizedBox(
                        height: 20,
                      ),
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: pickedImage.isNotEmpty
                                ? Image.file(
                                    File(pickedImage),
                                    height: 200,
                                    width: double.maxFinite,
                                    fit: BoxFit.contain,
                                  )
                                : CachedNetworkImage(
                                    imageUrl: widget.imagePath,
                                    errorWidget: (context, url, error) =>
                                        Image.asset(
                                      podcastPlaceHolder,
                                      width: double.maxFinite,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              margin: const EdgeInsets.all(4),
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                  color: blueColor,
                                  borderRadius: BorderRadius.circular(100)),
                              child: IconButton(
                                  color: blueColor,
                                  onPressed: _buttomSheet,
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                  )),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        focusNode: titleFocusNode,
                        style: const TextStyle(color: Colors.white),
                        controller: titleController,
                        decoration: const InputDecoration(
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: blueColor)),
                          labelStyle: TextStyle(color: Colors.white),
                          labelText: 'Title',
                          border: OutlineInputBorder(),
                        ),
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(descriptionFocusNode);
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Enter Titlle';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        focusNode: descriptionFocusNode,
                        style: const TextStyle(color: Colors.white),
                        controller: descriptionController,
                        maxLines: 4,
                        decoration: const InputDecoration(
                          labelStyle: TextStyle(color: Colors.white),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: blueColor)),
                          labelText: 'Description',
                          border: OutlineInputBorder(),
                        ),
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).unfocus();
                        },
                        validator: (value) {
                          return null;
                        },
                      ),
                      widget.index == 1
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  'Maturity Rating',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 22.sp),
                                ),
                                RadioListTile<String>(
                                  activeColor: blueColor,
                                  title: Text('U',
                                      style: TextStyle(
                                          fontSize: 16.sp,
                                          color: Colors.white)),
                                  value: 'U',
                                  groupValue: selectedMaturityRating,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedMaturityRating = value!;
                                    });
                                  },
                                ),
                                RadioListTile<String>(
                                  activeColor: blueColor,
                                  title: Text('U/A 13+',
                                      style: TextStyle(
                                          fontSize: 16.sp,
                                          color: Colors.white)),
                                  value: 'U/A 13+',
                                  groupValue: selectedMaturityRating,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedMaturityRating = value!;
                                    });
                                  },
                                ),
                                RadioListTile<String>(
                                  activeColor: blueColor,
                                  title: Text('U/A 16+',
                                      style: TextStyle(
                                          fontSize: 16.sp,
                                          color: Colors.white)),
                                  value: 'U/A 16+',
                                  groupValue: selectedMaturityRating,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedMaturityRating = value!;
                                    });
                                  },
                                ),
                                RadioListTile<String>(
                                  activeColor: blueColor,
                                  title: Text('A 18+',
                                      style: TextStyle(
                                          fontSize: 16.sp,
                                          color: Colors.white)),
                                  value: 'A 18+',
                                  groupValue: selectedMaturityRating,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedMaturityRating = value!;
                                    });
                                  },
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  'Select Category',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 22.sp),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Wrap(
                                  spacing: 10,
                                  runSpacing: 10,
                                  children: chipWidgets,
                                ),
                              ],
                            )
                          : const SizedBox(),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: ElevatedButton(
                          onPressed: handleUpload,
                          style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(10.0),
                              backgroundColor: blueColor),
                          child: Text(
                            'Upload',
                            style:
                                TextStyle(color: Colors.white, fontSize: 22.sp),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
