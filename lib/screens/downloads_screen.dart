import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:just_audio/just_audio.dart';
import 'package:onpods/screens/player/offline_player_screen.dart';
import 'package:onpods/utils/exports.dart';
import 'package:path_provider/path_provider.dart';

class DownloadsPage extends StatefulWidget {
  const DownloadsPage({Key? key}) : super(key: key);

  @override
  DownloadsPageState createState() => DownloadsPageState();
}

class DownloadsPageState extends State<DownloadsPage> {
  List<File> _audioFiles = [];
  List<File> _imageFiles = [];
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _loadFiles();
  }

  Future<void> _loadFiles() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    String audioFolderPath = '$appDocPath';

    var files = Directory(audioFolderPath).listSync();

    setState(() {
      _audioFiles = files
          .where(
              (file) => file is File && file.path.toString().endsWith('.mp3'))
          .cast<File>()
          .toList();
      _imageFiles = files
          .where(
              (file) => file is File && file.path.toString().endsWith('.jpg'))
          .cast<File>()
          .toList();
    });
  }

  Future<void> _playAudio(String path) async {
    await _audioPlayer.setUrl(path);
    await _audioPlayer.play();
  }

  bool _hasImage(String fileName) {
    return _imageFiles.any(
      (imageFile) =>
          imageFile.path.split('/').last.replaceAll('.jpg', '') == fileName,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       bottomNavigationBar: const MiniPlayer(),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        title: const Text(
          'Downloads',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: _audioFiles.isEmpty
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
              itemCount: _audioFiles.length,
              itemBuilder: (context, index) {
                final audioItem = _audioFiles[index];

                // Extracting file name without extension
                String fileName =
                    audioItem.path.split('/').last.replaceAll('.mp3', '');

                return GestureDetector(
                  onTap: () => Get.to(
                    OfflinePlayerScreen(
                      albumImage: '',
                      playlist: const [
                        {
                          "title": "Rudy's One Piece Birthday",
                          "description":
                              "New Merch: https://www.badfriendsmerch.com Tour Tickets: https://badfriendspod.com Get MORE Bad Friends at our Patreon!! https://www.patreon.com/badfriends Thank you to our Sponsors: Morgan&Morgan, ZocDoc, Dr.Squatch & AirUp • Morgan & Morgan: If you’re ever injured, you can check out Morgan & Morgan. Their fee is free unless they win. For more information go to https://ForThePeople.com/badfriends or dial Pound LAW (Pound 529) from your cell phone. This is a paid advertisement. • ZocDoc: Find and book top rated doctors at https://www.zocdoc.com/badfriends",
                          "audioUrl":
                              "https://onpods.s3.ap-south-1.amazonaws.com/podcasts/1701445250827-TPC7752669034.mp3",
                          "_id": "6569fe9cfecb5f7230cf3f84",

                        },
                      ],
                      audioUrl: audioItem.path,
                      episode: 'episodes[index].title!',
                      poster: _imageFiles
                          .firstWhere(
                            (imageFile) =>
                                imageFile.path
                                    .split('/')
                                    .last
                                    .replaceAll('.jpg', '') ==
                                fileName,
                          )
                          .path,
                      title: fileName.split('-')[0],
                      startingIndex: index,
                      podcastId: 'widget.podcastId',
                      episodeId: 'episodes[index].id!',
                    ),
                    transition: Transition.downToUp,
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 12, right: 12, top: 10),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: _hasImage(fileName)
                                  ? Image.file(
                                      _imageFiles.firstWhere(
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
                                      imageUrl: 'episodes![index].posterUrl' ??
                                          'widget.image',
                                      errorWidget: (context, url, error) =>
                                          Image.network('widget.image'),
                                    ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    fileName.split('-')[0],
                                    maxLines: 2,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 18,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Text(
                                      fileName.split('-')[1],
                                      maxLines: 3,
                                      softWrap: true,
                                      style: const TextStyle(
                                          color: Colors.white54,
                                          overflow: TextOverflow.ellipsis,
                                          fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
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
