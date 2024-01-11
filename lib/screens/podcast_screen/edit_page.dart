import 'dart:io';

import 'package:onpods/utils/exports.dart';
import 'package:webview_flutter/webview_flutter.dart';

class EditPage extends StatefulWidget {
   EditPage(
      {super.key,
      required this.index,
      required this.imagePath,
      required this.podcastId,
      required this.title,
      required this.description,
      required this.episodeId,
      required this.selectedChipIndex});
  final String podcastId;
  final String episodeId;

  final int index;
  final String imagePath;
  final String title;
  final String description;
  String selectedChipIndex;
  @override
  EditPageState createState() => EditPageState();
}

class EditPageState extends State<EditPage> {
  bool loading = false;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FocusNode titleFocusNode = FocusNode();
  FocusNode descriptionFocusNode = FocusNode();
  String pickedImage = '';
  @override
  void initState() {
    super.initState();
    fetchData();

    titleController.text = widget.title;
    descriptionController.text = widget.description;
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

  Future<void> handleUpdate() async {
    final provider = Provider.of<PodcastProvider>(context, listen: false);
    provider.currentPodcast.clear();

    String title = titleController.text;
    String description = descriptionController.text;
    if (_formKey.currentState!.validate()) {
      if (widget.index == 1) {
        if (widget.selectedChipIndex != '') {
          setState(() {
            loading = true;
          });
          try {
            final res = await PodcastService().updatePodcast(
                title, description,widget.podcastId,widget.selectedChipIndex, pickedImage);

            if (res) {
              showSnackbar('Successful', 'Podcast Uploaded Successfully');
              provider.fetchPodcastsById(widget.podcastId);
              Navigator.of(context).pop();
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
          final res = await PodcastService().updateEpisode(title, description,
              widget.podcastId, widget.episodeId, pickedImage);
          if (res) {
            showSnackbar('Successful', 'Updated Successfully');
            provider.fetchPodcastsById(widget.podcastId);
            Navigator.of(context).pop();
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
               bottomNavigationBar: const MiniPlayer(),
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

    List<Widget> chipWidgets = widget.index == 1
        ? provider.podcastCategories.asMap().entries.map((entry) {
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
                  color:
                      widget.selectedChipIndex == index ? Colors.white : Colors.black),
              selected: widget.selectedChipIndex == index,
              onSelected: (bool selected) {
                setState(() {
                  if (selected) {
                    if (widget.selectedChipIndex == '') {
                      widget.selectedChipIndex = index;
                    } else if (widget.selectedChipIndex != '') {
                      widget.selectedChipIndex = index;
                    }
                  }
                });
              },
            );
          }).toList()
        : [];
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: blueColor,
        title: Text(
          widget.index == 0 ? 'Edit Episode' : 'Edit Podcast',
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
                  const Text(
                    'Updating...',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 28,
                        fontWeight: FontWeight.w500),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                    child: Text(
                      'Your podcast is updating to cloud,Please wait it will take few seconds..',
                      style: TextStyle(
                        color: Colors.black38,
                        fontSize: 18,
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
                reverse: true,
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
                                      height: 200,
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
                          if (value!.isEmpty) {
                            return 'Please Enter Description';
                          }
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
                                const Text(
                                  'Select Category',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
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
                          onPressed: handleUpdate,
                          style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(10.0),
                              backgroundColor: blueColor),
                          child: const Text(
                            'Update',
                            style: TextStyle(color: Colors.white, fontSize: 20),
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
