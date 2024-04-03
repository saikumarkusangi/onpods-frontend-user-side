import 'dart:io';
import 'package:just_audio/just_audio.dart';
import 'package:onpods/screens/player/offline_player_screen.dart';
import 'package:onpods/utils/exports.dart';

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
    String audioFolderPath = appDocPath;

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
    print(_audioFiles);
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

                String fileName =
                    audioItem.path.split('/').last.replaceAll('.mp3', '');

                return GestureDetector(
                  onTap: () => Get.to(
                    OfflinePlayerScreen(
                      albumImage: '',
                      playlist: const [],
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
                      title: fileName.split('~e')[0],
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
                                      imageUrl: 'episodes![index].posterUrl',
                                      errorWidget: (context, url, error) =>
                                          Image.asset(podcastPlaceHolder),
                                    ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    fileName.split('~e')[0],
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
                                      fileName.split('~e')[1],
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
