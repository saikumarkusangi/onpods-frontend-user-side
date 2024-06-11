import 'dart:io';
import 'package:just_audio/just_audio.dart';
import 'package:onpods/screens/all_download_episodes.dart';
import 'package:onpods/screens/player/offline_player_screen.dart';
import 'package:onpods/utils/exports.dart';
import 'package:pinput/pinput.dart';

class DownloadsPage extends StatefulWidget {
  const DownloadsPage({Key? key}) : super(key: key);

  @override
  DownloadsPageState createState() => DownloadsPageState();
}

class DownloadsPageState extends State<DownloadsPage> {
  List<File> _albumFiles = [];
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

    Set<String> showNames = {}; // Set to store unique show names

    for (var file in files) {
      if (file is File && file.path.endsWith('.png')) {
        String filePath = file.path;
        String showName =
            filePath.split('/').last.split('~e')[0]; // Extract show name

        // Check if the show name is not already in the set
        if (!showNames.contains(showName)) {
          _albumFiles.add(file); // Add the file to the list
          showNames.add(showName); // Add the show name to the set
        }
      }
    }

    setState(() {});
  }

  Future selectedPodcast(name) async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    String audioFolderPath = appDocPath;

    var files = Directory(audioFolderPath).listSync();

    final audioFiles = files
        .where((file) {
          return file is File &&
              file.path.toString().toString().endsWith('.mp3') &&
              file.path.split('/').last.split('~e')[0] == name;
        })
        .cast<File>()
        .toList();
    final imageFiles = files
        .where((file) =>
            file is File &&
            file.path.toString().endsWith('.jpg') &&
            file.path.split('/').last.split('~e')[0] == name)
        .cast<File>()
        .toList();
    return [audioFiles, imageFiles];
  }

  Future<void> _playAudio(String path) async {
    await _audioPlayer.setUrl(path);
    await _audioPlayer.play();
  }

  Future<void> _deleteFilesForShow(String showName) async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    String audioFolderPath = appDocPath;

    var files = Directory(audioFolderPath).listSync();

    for (var file in files) {
     
      if (file is File &&
          file.path.split('/').last.split('~e')[0] == showName) {
        await file.delete();
      }
    }
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
      body: _albumFiles.isEmpty
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
              itemCount: _albumFiles.length,
              itemBuilder: (context, index) {
                final albumItem = _albumFiles[index];

                String fileName = albumItem.path.split('/').last;

                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: const BoxDecoration(
                      border:
                          Border(bottom: BorderSide(color: Colors.white24))),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () async {
                        final data =
                            await selectedPodcast(fileName.split('~e')[0]);
                        Get.to(
                            AllDownloadsPage(
                                name: fileName.split('~e')[0],
                                audioFiles: data[0],
                                imageFiles: data[1]),
                            transition: Transition.cupertino);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              albumItem,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 10, right: 10),
                                  child: Text(
                                    fileName.split('~e')[0],
                                    maxLines: 4,
                                    softWrap: true,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        overflow: TextOverflow.ellipsis,
                                        fontSize: 18),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: FutureBuilder(
                                    future: selectedPodcast(
                                        fileName.split('~e')[0]),
                                    builder: (context, snapshot) {
                                      if (snapshot.data[0].length == 0) {
                                        _deleteFilesForShow(fileName.split('~e')[0]);
                                      }
                                      return snapshot.connectionState !=
                                              ConnectionState.waiting
                                          ? Text(
                                              '${snapshot.data[0].length} ${snapshot.data[0].length > 1 ? 'Episodes' : 'Episode'}',
                                              maxLines: 4,
                                              softWrap: true,
                                              style: const TextStyle(
                                                  color: Colors.white60,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  fontSize: 16),
                                            )
                                          : const Text(
                                              'Loading...',
                                              maxLines: 4,
                                              softWrap: true,
                                              style: TextStyle(
                                                  color: Colors.white60,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  fontSize: 16),
                                            );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.keyboard_arrow_right_outlined,
                            color: Colors.white,
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
