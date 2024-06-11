import 'dart:io';
import 'package:just_audio/just_audio.dart';
import 'package:onpods/screens/player/offline_player_screen.dart';
import 'package:onpods/utils/exports.dart';

class AllDownloadsPage extends StatefulWidget {
  final List<File> audioFiles;
  final List<File> imageFiles;
  final String name;
  const AllDownloadsPage(
      {super.key,
      required this.audioFiles,
      required this.imageFiles,
      required this.name});

  @override
  AllDownloadsPageState createState() => AllDownloadsPageState();
}

class AllDownloadsPageState extends State<AllDownloadsPage> {
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
  }

  Future<void> _playAudio(String path) async {
    await _audioPlayer.setUrl(path);
    await _audioPlayer.play();
  }

  bool _hasImage(String fileName) {
    return widget.imageFiles.any(
      (imageFile) =>
          imageFile.path.split('/').last.replaceAll('.jpg', '') == fileName,
    );
  }

  Future<void> _deleteAudioFile(File file) async {
    try {
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      // Handle any errors here
      print('Error deleting:${e}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const MiniPlayer(),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        title: Text(
          widget.name,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: widget.audioFiles.isEmpty
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const EmptyPlaceHolder(message: 'message'),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Explore and download your favorite podcasts and listen when you\'re offline.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
                SizedBox(
                  height: 0.2.sh,
                ),
              ],
            )
          : ListView.builder(
              itemCount: widget.audioFiles.length,
              itemBuilder: (context, index) {
                final audioItem = widget.audioFiles[index];

                String fileName =
                    audioItem.path.split('/').last.replaceAll('.mp3', '');

                return GestureDetector(
                  onTap: () {
                    Get.to(
                      OfflinePlayerScreen(
                        albumImage: '',
                        playlist: const [],
                        audioUrl: audioItem.path,
                        episode: fileName.split('~e')[1],
                        poster: widget.imageFiles
                            .firstWhere(
                              (imageFile) =>
                                  imageFile.path
                                      .split('/')
                                      .last
                                      .replaceAll('.jpg', '') ==
                                  fileName,
                            )
                            .path,
                        title: fileName.split('~e')[0],
                        startingIndex: index,
                        podcastId: '',
                        episodeId: '',
                      ),
                      transition: Transition.downToUp,
                    );
                  },
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: const BoxDecoration(
                            border: Border(
                                bottom: BorderSide(color: Colors.white24))),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 12, right: 12, top: 10, bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: _hasImage(fileName)
                                    ? Image.file(
                                        widget.imageFiles.firstWhere(
                                          (imageFile) =>
                                              imageFile.path
                                                  .split('/')
                                                  .last
                                                  .replaceAll('.jpg', '') ==
                                              fileName,
                                        ),
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      )
                                    : CachedNetworkImage(
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                        imageUrl: 'episodes![index].posterUrl',
                                        errorWidget: (context, url, error) =>
                                            Image.asset(podcastPlaceHolder),
                                      ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10, right: 10),
                                      child: Text(
                                        fileName.split('~e')[1],
                                        maxLines: 4,
                                        softWrap: true,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: 16),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    showModalBottomSheet(
                                      constraints:
                                          const BoxConstraints(maxHeight: 140),
                                      backgroundColor:
                                          const Color.fromARGB(255, 45, 45, 45),
                                      context: context,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(6)),
                                      builder: (context) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 10),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              ListTile(
                                                onTap: () {
                                                  Get.back(); 
                                                  Get.to(
                                                    OfflinePlayerScreen(
                                                      albumImage: '',
                                                      playlist: const [],
                                                      audioUrl: audioItem.path,
                                                      episode: fileName
                                                          .split('~e')[1],
                                                      poster: widget.imageFiles
                                                          .firstWhere(
                                                            (imageFile) =>
                                                                imageFile.path
                                                                    .split('/')
                                                                    .last
                                                                    .replaceAll(
                                                                        '.jpg',
                                                                        '') ==
                                                                fileName,
                                                          )
                                                          .path,
                                                      title: fileName
                                                          .split('~e')[0],
                                                      startingIndex: index,
                                                      podcastId: '',
                                                      episodeId: '',
                                                    ),
                                                    transition:
                                                        Transition.downToUp,
                                                  );
                                                },
                                                leading: const Icon(
                                                  Icons.play_circle,
                                                  size: 28,
                                                  color: Colors.white,
                                                ),
                                                title: const Text(
                                                  'Play Now',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                              ListTile(
                                                onTap: () {
                                                  Get.back();
                                                  showModalBottomSheet(
                                                    constraints:
                                                        const BoxConstraints(
                                                            maxHeight: 220),
                                                    backgroundColor:
                                                        const Color.fromARGB(
                                                            255, 45, 45, 45),
                                                    context: context,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        6)),
                                                    builder: (context) {
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 20,
                                                                vertical: 10),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            const Icon(
                                                              Icons.warning,
                                                              color: Colors
                                                                  .white54,
                                                              size: 52,
                                                            ),
                                                            const Text(
                                                              'Are you sure you want to delete the download?',
                                                              style:
                                                                  TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 18,
                                                              ),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                            ElevatedButton(
                                                                onPressed:
                                                                    () async {
                                                                  Get.back();
                                                                  await _deleteAudioFile(
                                                                      audioItem);
                                                                  setState(() {
                                                                    widget
                                                                        .audioFiles
                                                                        .removeAt(
                                                                            index);
                                                                  });
                                                                },
                                                                style: ElevatedButton.styleFrom(
                                                                    backgroundColor:
                                                                        Colors
                                                                            .red,
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                10)),
                                                                    minimumSize:
                                                                        const Size(
                                                                            double
                                                                                .maxFinite,
                                                                            50),
                                                                    textStyle:
                                                                        const TextStyle(
                                                                            color: Colors
                                                                                .white)),
                                                                child:
                                                                    const Text(
                                                                  'Delete Download',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          18),
                                                                ))
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                  );
                                                },
                                                leading: const Icon(
                                                  Icons.delete,
                                                  size: 28,
                                                  color: Colors.white,
                                                ),
                                                title: const Text(
                                                  'Delete Episode',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              )
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.more_vert,
                                    color: Colors.white,
                                  ))
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
