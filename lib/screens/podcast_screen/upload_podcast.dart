import 'dart:io';
import 'package:onpods/utils/exports.dart';

class PodcastUploadPage extends StatefulWidget {
  const PodcastUploadPage({super.key});

  @override
  State<PodcastUploadPage> createState() => _PodcastUploadPageState();
}

class _PodcastUploadPageState extends State<PodcastUploadPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  'Add to previous podcast',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: 2,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: ListTile(
                        leading: Image.asset(podcastPlaceHolder),
                        title: const Text(
                          'Podcast Title',
                          maxLines: 2,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              overflow: TextOverflow.ellipsis),
                        ),
                        trailing: IconButton(
                            iconSize: 32,
                            onPressed: () => Get.to(
                                const FinalUploadPage(
                                  index: 0,
                                ),
                                transition: Transition.cupertino),
                            icon: const Icon(
                              Icons.add,
                              color: Colors.white,
                            )),
                      ),
                    );
                  }),
              const SizedBox(
                height: 20,
              ),
              const Center(
                child: Text(
                  'OR',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.maxFinite, 50),
                      backgroundColor: blueColor),
                  onPressed: () => Get.to(
                      const FinalUploadPage(
                        index: 1,
                      ),
                      transition: Transition.cupertino),
                  child: const Text(
                    'Create New Podcast',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

class FinalUploadPage extends StatefulWidget {
  const FinalUploadPage({super.key, required this.index});

  final int index;
  @override
  FinalUploadPageState createState() => FinalUploadPageState();
}

class FinalUploadPageState extends State<FinalUploadPage> {
  String selectedChipIndex = '';
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String imagePath = '';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FocusNode titleFocusNode = FocusNode();
  FocusNode descriptionFocusNode = FocusNode();
  String poster = '';

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    titleFocusNode.dispose();
    descriptionFocusNode.dispose();
    super.dispose();
  }

  void handleUpload() {
    String title = titleController.text;
    String description = descriptionController.text;
    if (_formKey.currentState!.validate()) {
      if (widget.index == 1) {
        if (selectedChipIndex != '') {
        } else {
          Fluttertoast.showToast(msg: 'Please Select Category');
        }
      }
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        imagePath = pickedFile.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<QuoteProvider>(context, listen: false);
    List<Widget> chipWidgets =
        provider.quotesCategories.asMap().entries.map((entry) {
      final index = entry.value.id;
      final category = entry.value;

      // Define BorderRadius for the chip
      BorderRadiusGeometry borderRadius = BorderRadius.circular(40);

      return ChoiceChip(
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius, // Use the defined BorderRadius here
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
      body: Padding(
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
                        child: imagePath.isNotEmpty
                            ? Image.file(
                                File(imagePath),
                                height: 200,
                                width: double.maxFinite,
                                fit: BoxFit.contain,
                              )
                            : Image.asset(
                             podcastPlaceHolder,
                                height: 200,
                                width: double.maxFinite,
                                fit: BoxFit.contain,
                              )),
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
                            onPressed: _pickImage,
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
                    FocusScope.of(context).requestFocus(descriptionFocusNode);
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
                            style: TextStyle(color: Colors.white, fontSize: 20),
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
                    child: const Text(
                      'Upload',
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
