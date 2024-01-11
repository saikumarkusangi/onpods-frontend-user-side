import 'dart:io';

import 'package:flutter_hud/flutter_hud.dart';
import 'package:onpods/screens/profile_screen/widgets/built_action_item.dart';
import 'package:onpods/utils/exports.dart';

class EditProfileScreen extends StatefulWidget {
  String profilePic;
  final String userName;
  final String userId;
  final List intrests;

  EditProfileScreen(
      {super.key,
      required this.profilePic,
      required this.userName,
      required this.userId,
      required this.intrests});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _userNameController;

  @override
  void initState() {
    super.initState();
    init();
    _userNameController = TextEditingController(text: widget.userName);
  }

  File? selectedPic = null;

  Widget _buildField(controller, hintText) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            hintText,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const SizedBox(
            height: 10,
          ),
          CustomTextFormField(
            controller: controller,
            autofocus: false,
            radius: 10,
            hintText: hintText,
            vertical: 16,
            fillColor: darktextFieldColor,
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 20),
            textStyle: const TextStyle(color: Colors.white, fontSize: 20),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter $hintText';
              }

              return null;
            },
          ),
        ],
      ),
    );
  }


  bool loading = false;
  init() async {
    final provider = Provider.of<PodcastProvider>(context, listen: false);
    if (provider.podcastCategories.isEmpty) {
      setState(() {
        loading = true;
      });
      await provider.fetchCategories().whenComplete(() {
        setState(() {
          loading = false;
        });
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
            color: widget.intrests.contains(index)
                ? Colors.white
                : Colors.black),
        selected: widget.intrests.contains(index),
        onSelected: (bool selected) {
          setState(() {
            if (selected) {
              if (widget.intrests.length < 3) {
                widget.intrests.add(index);
              } else {
                Fluttertoast.showToast(msg: 'Max 3 categories are allowed');
              }
            } else {
              widget.intrests.remove(index);
            }
          });
        },
      );
    }).toList();
    print(widget.profilePic);
    return WidgetHUD(
      showHUD: loading,
      hud: HUD(
          progressIndicator: Image.asset(
        liveGif,
        color: blueColor,
        scale: 3,
      )),
      builder: (context, child) => Scaffold(
        bottomNavigationBar: const MiniPlayer(),
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Colors.black,
          title: const Text(
            'Edit Profile',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
                onPressed: () async {
                  setState(() {
                    loading = true;
                  });
                  await UserServices()
                      .updateUser(selectedPic == null ? '' : selectedPic!.path,
                          _userNameController.text, widget.intrests)
                      .whenComplete(() {
                    setState(() {
                      loading = false;
                    });
                    Get.back();
                  });
                },
                child: const Text(
                  'SAVE',
                  style: TextStyle(color: blueColor, fontSize: 18),
                ))
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 40,
              ),
              Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 236, 184, 202),
                      borderRadius: BorderRadius.circular(100)),
                  child: selectedPic != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.file(
                            selectedPic!,
                            fit: BoxFit.cover,
                          ))
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(60),
                          child: CachedNetworkImage(
                            imageUrl: widget.profilePic,
                            placeholder: (context, url) => Center(
                              child: Text(
                                widget.userName.substring(0, 1).toUpperCase(),
                                style: const TextStyle(fontSize: 32),
                              ),
                            ),
                            errorWidget: (context, url, error) => Center(
                              child: Text(
                                widget.userName.substring(0, 1).toUpperCase(),
                                style: const TextStyle(fontSize: 32),
                              ),
                            ),
                          ),
                        ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Center(
                child: ElevatedButton(
                    onPressed: () => _showBottomSheet(context),
                    style: ElevatedButton.styleFrom(backgroundColor: blueColor),
                    child: const Text(
                      'Edit',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    )),
              ),
              const SizedBox(
                height: 40,
              ),
              _buildField(_userNameController, 'User Name'),
              const SizedBox(
                height: 10,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Your Interests',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: chipWidgets,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        showDragHandle: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: bottomSheetColor,
        constraints: const BoxConstraints(maxHeight: 250),
        builder: (context) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildActionItem(Icons.photo_sharp, 'From Gallery', () async {
                Navigator.pop(context);
                final XFile? image =
                    await ImagePicker().pickImage(source: ImageSource.gallery);
                CroppedFile? croppedFile = await ImageCropper().cropImage(
                  sourcePath: image!.path,
                  aspectRatioPresets: [
                    CropAspectRatioPreset.square,
                    CropAspectRatioPreset.ratio3x2,
                    CropAspectRatioPreset.original,
                    CropAspectRatioPreset.ratio4x3,
                    CropAspectRatioPreset.ratio16x9
                  ],
                  compressQuality: 100,
                  compressFormat: ImageCompressFormat.jpg,
                );
                setState(() {
                  selectedPic = File(croppedFile!.path);
                });
              }, Colors.blueAccent),
              buildActionItem(Icons.camera_alt, 'From Camera', () async {
                Navigator.pop(context);
                final XFile? image =
                    await ImagePicker().pickImage(source: ImageSource.camera);
                CroppedFile? croppedFile = await ImageCropper().cropImage(
                  sourcePath: image!.path,
                  aspectRatioPresets: [
                    CropAspectRatioPreset.square,
                    CropAspectRatioPreset.ratio3x2,
                    CropAspectRatioPreset.original,
                    CropAspectRatioPreset.ratio4x3,
                    CropAspectRatioPreset.ratio16x9
                  ],
                  compressQuality: 100,
                  compressFormat: ImageCompressFormat.jpg,
                );
                setState(() {
                  selectedPic = File(croppedFile!.path);
                });
              }, Colors.deepPurpleAccent),
              buildActionItem(Icons.delete, 'Delete', () {
                Navigator.pop(context);
                setState(() {
                  selectedPic = null;
                  widget.profilePic = '';
                });
              }, Colors.redAccent),
            ],
          );
        });
  }
}
