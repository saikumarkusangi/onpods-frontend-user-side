import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:onpods/screens/quotes_screen/background_images.dart';
import 'package:onpods/screens/quotes_screen/upload_quote.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:text_editor/text_editor.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import '../../providers/providers_exports.dart';
import '../../utils/utils_exports.dart';

class CreateQuote extends StatefulWidget {
  const CreateQuote({Key? key}) : super(key: key);

  @override
  _CreateQuoteState createState() => _CreateQuoteState();
}

class _CreateQuoteState extends State<CreateQuote> {
  ScreenshotController screenshotController = ScreenshotController();
  List searchResults = [];

  final fonts = [
    'OpenSans',
    'Billabong',
    'GrandHotel',
    'Oswald',
    'Quicksand',
    'BeautifulPeople',
    'BeautyMountains',
    'BiteChocolate',
    'BlackberryJam',
    'BunchBlossoms',
    'CinderelaRegular',
    'Countryside',
    'Halimun',
    'LemonJelly',
    'QuiteMagicalRegular',
    'Tomatoes',
    'TropicalAsianDemoRegular',
    'VeganStyle',
  ];

  final textStyleNotifier = ValueNotifier<TextStyle>(
    const TextStyle(
      fontSize: 42,
      color: Colors.black,
    ),
  );
  final opacityNotifier = ValueNotifier<double>(1.0);

  final textNotifier = ValueNotifier<String>('Type Here');

  final textAlignNotifier = ValueNotifier<TextAlign>(TextAlign.center);

  final dragOffsetNotifier = ValueNotifier<Offset>(Offset(0, 0.4.sh));

  final editingNotifier = ValueNotifier<bool>(false);

  void updateOpacity(double value) {
    opacityNotifier.value = value;
  }

  void _tapHandler() {
    if (editingNotifier.value) {
      showGeneralDialog(
        context: context,
        barrierDismissible: false,
        transitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (_, __, ___) {
          return Container(
            color: Colors.black.withOpacity(0.4),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: SafeArea(
                child: TextEditor(
                  fonts: fonts,
                  text: textNotifier.value,
                  textStyle: textStyleNotifier.value,
                  textAlingment: textAlignNotifier.value,
                  minFontSize: 20,
                  onEditCompleted: (style, align, text) {
                    textStyleNotifier.value = style;
                    textAlignNotifier.value = align;
                    textNotifier.value = text;
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          );
        },
      );
    } else {
      final RenderBox renderBox = context.findRenderObject() as RenderBox;
      final tapPosition = renderBox.globalToLocal(dragOffsetNotifier.value);
      dragOffsetNotifier.value = tapPosition;
      editingNotifier.value = true;
    }
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    dragOffsetNotifier.value += details.delta;
  }

  File backgroundImage = File('');

  _galleryImage() async {
    final bgProvider = Provider.of<BackGroundProvider>(context, listen: false);
    final bgOpacityProvider =
        Provider.of<BackGroundProvider>(context, listen: false);
    ImagePicker picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    imageQuality: 50
    );

    if (pickedFile?.path != null) {
      bgOpacityProvider.updateLastSelected(1);
      bgProvider.updateBgImageFromGallery(File(pickedFile!.path));
    }
  }

  _cameraImage() async {
    final bgProvider = Provider.of<BackGroundProvider>(context, listen: false);
    final bgOpacityProvider =
        Provider.of<BackGroundProvider>(context, listen: false);

    ImagePicker picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50
    );

    if (pickedFile?.path != null) {
      bgOpacityProvider.updateLastSelected(2);
      bgProvider.updateBgImageFromCam(File(pickedFile!.path));
    }
  }

  _backgroundColor() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Consumer<BackGroundProvider>(
              builder: (context, provider, child) {
                return ColorPicker(
                  pickerAreaBorderRadius: BorderRadius.circular(10),
                  colorPickerWidth: 0.8.sw,
                  pickerAreaHeightPercent: 0.7,
                  showLabel: false,
                  pickerColor: provider.backgroundColor,
                  onColorChanged: provider.changeColor,
                );
              },
            ),
          ],
        );
      },
    );
  }

  double currentscale = 1.0;

  Future<File> saveUint8ListAsImage(Uint8List uint8List) async {
    final tempDir = await getTemporaryDirectory();
    final tempFile = File('${tempDir.path}/temp_image.png');
    await tempFile.writeAsBytes(uint8List);
    return tempFile;
  }

  // Function to share the image

  Future<dynamic> shareImage() async {
    final image = await screenshotController.capture();
    // Capture the screenshot
    final File imageFile = await saveUint8ListAsImage(image!);
    final xFile = XFile(imageFile.path);
    await Share.shareXFiles([xFile],
        text:
            'Check out my quote made on onpods. \n www.instagram.com/theonpods/');
  }

  // Function to save the image to the gallery
  Future<dynamic> saveImageToGallery() async {
    Get.snackbar('Process Started', 'Please wait work in progress..',
        backgroundColor: Colors.white);

    try {
      final image = await screenshotController.capture();
      // Capture the screenshot
      final File imageFile = await saveUint8ListAsImage(image!);
      final result = await ImageGallerySaver.saveFile(imageFile.path);

      if (result['isSuccess']) {
        Get.snackbar('Done', 'Image saved to gallery',
            backgroundColor: Colors.white);
      } else {
        Get.snackbar('Something went wrong', 'Failed to save image to gallery',
            backgroundColor: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Error capturing or saving screenshot:', e.toString(),
          backgroundColor: Colors.white);
    }
  }

  @override
  void dispose() {
    textStyleNotifier.dispose();
    textNotifier.dispose();
    textAlignNotifier.dispose();
    dragOffsetNotifier.dispose();
    editingNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bgProvider = Provider.of<BackGroundProvider>(context);
    final opacityProvider = Provider.of<BackGroundProvider>(context);
    Future<bool> showBackDialog() async {
      bool confirm = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            title: const Text('Discard Changes?'),
            content: const Text(
              'Are you sure you want to discard your edits?',
              style: TextStyle(fontSize: 16),
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: const Text(
                    'Continue Editing',
                    style: TextStyle(fontSize: 14, color: blueColor),
                  )),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                  bgProvider.clearData();
                  bgProvider.updateLastSelected(0);
                },
                child: const Text('Discard',
                    style: TextStyle(fontSize: 14, color: blueColor)),
              ),
            ],
          );
        },
      );
      return confirm;
    }

    return Consumer<BackGroundProvider>(
      builder: (context, provider, child) {
        return SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: WillPopScope(
              onWillPop: showBackDialog,
              child: Center(
                child: Stack(
                  children: [
                    Screenshot(
                      controller: screenshotController,
                      child: Stack(
                        children: [
                          Opacity(
                            opacity: opacityProvider.opacity,
                            child: bgProvider.backGroundFromGallery.path
                                        .isNotEmpty &&
                                    opacityProvider.lastSelected == 1
                                ? Center(
                                    child: PhotoView(
                                        imageProvider: FileImage(
                                          bgProvider.backGroundFromGallery,
                                        ),
                                        backgroundDecoration: null),
                                  )
                                : bgProvider.backGroundFromCam.path
                                            .isNotEmpty &&
                                        opacityProvider.lastSelected == 2
                                    ? Center(
                                        child: PhotoView(
                                            imageProvider: FileImage(
                                                bgProvider.backGroundFromCam),
                                            backgroundDecoration: null),
                                      )
                                    : bgProvider.backGroundUrlFromInternet
                                                .isNotEmpty &&
                                            opacityProvider.lastSelected == 3
                                        ? GestureDetector(
                                            onTap: _tapHandler,
                                            child: Center(
                                              child: PhotoView(
                                                  imageProvider: NetworkImage(
                                                      bgProvider
                                                          .backGroundUrlFromInternet),
                                                  backgroundDecoration: null),
                                            ),
                                          )
                                        : opacityProvider.lastSelected == 4
                                            ? Container(
                                                color: provider.backgroundColor,
                                              )
                                            : Container(
                                                color: Colors.white,
                                              ),
                          ),
                          ValueListenableBuilder<Offset>(
                            valueListenable: dragOffsetNotifier,
                            builder: (context, dragOffset, child) {
                              return Positioned(
                                left: dragOffset.dx,
                                top: dragOffset.dy,
                                child: ValueListenableBuilder<String>(
                                  valueListenable: textNotifier,
                                  builder: (context, text, child) {
                                    return ValueListenableBuilder<TextStyle>(
                                        valueListenable: textStyleNotifier,
                                        builder: (context, textStyle, child) {
                                          return SizedBox(
                                            width: 1.sw,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12),
                                              child: GestureDetector(
                                                onTap: _tapHandler,
                                                onPanUpdate: _handleDragUpdate,
                                                child: Transform.scale(
                                                  scale: currentscale,
                                                  child: Text(
                                                    text,
                                                    style:
                                                        textStyleNotifier.value,
                                                    textAlign:
                                                        textAlignNotifier.value,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        });
                                  },
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(60),
                              ),
                              child: IconButton(
                                onPressed: () async {
                                  bool confirm = await showBackDialog();
                                  if (confirm) {
                                    Get.back();
                                  }
                                },
                                icon: const Icon(
                                  Icons.navigate_before,
                                  size: 32,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(60),
                              ),
                              child: IconButton(
                                onPressed: () => shareImage(),
                                icon: const Icon(
                                  Icons.share,
                                  size: 32,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(60),
                              ),
                              child: IconButton(
                                onPressed: () => saveImageToGallery(),
                                icon: const Icon(
                                  Icons.save_alt,
                                  size: 32,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(60),
                              ),
                              child: IconButton(
                                onPressed: () async {
                                  final image =
                                      await screenshotController.capture();

                                  final File imageFile =
                                      await saveUint8ListAsImage(image!);
                                  CroppedFile? croppedFile =
                                      await ImageCropper().cropImage(
                                    sourcePath: imageFile.path,
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
                                  if(croppedFile == null) {
                                
                                  } else {
                                    Get.to(
                                      UploadQuotes(
                                        image: File(croppedFile.path),
                                      ),
                                      transition: Transition.cupertino);
                                  }
                                },
                                icon: const Icon(
                                  Icons.navigate_next,
                                  size: 32,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Slider(
                            activeColor: blueColor,
                            value: opacityProvider.opacity,
                            onChanged: (value) =>
                                opacityProvider.changeOpacity(value),
                            min: 0.0,
                            max: 1.0,
                            divisions: 100,
                            label: opacityProvider.opacity.toStringAsFixed(1),
                          ),
                          Container(
                            decoration:
                                const BoxDecoration(color: Colors.black45),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    onPressed: _galleryImage,
                                    icon: Image.asset(
                                      galleryIcon,
                                      scale: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: _cameraImage,
                                    icon: Image.asset(
                                      camera,
                                      scale: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      String? ImageFromInternet =
                                          await Get.to<String>(
                                              const BackGroundImages(),
                                              transition: Transition.downToUp);
                                      ImageFromInternet != null
                                          ? bgProvider
                                              .updateBgImageFromInternet(
                                                  ImageFromInternet)
                                          : '';
                                    },
                                    icon: Image.asset(
                                      internrtIcon,
                                      scale: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: _backgroundColor,
                                    icon: Image.asset(
                                      paint,
                                      scale: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
