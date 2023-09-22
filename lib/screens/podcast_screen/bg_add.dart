import 'package:flutter/material.dart';
import 'package:flutter_sound_lite/flutter_sound.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:onpods/providers/providers_exports.dart';
import 'package:onpods/screens/podcast_screen/upload_podcast.dart';
import 'package:onpods/utils/colors.dart';
import 'package:provider/provider.dart';

import '../../utils/utils_exports.dart';

class BgAdd extends StatefulWidget {
  final filePath;

  const BgAdd({Key? key, this.filePath}) : super(key: key);

  @override
  _BgAddState createState() => _BgAddState();
}

class _BgAddState extends State<BgAdd> with AutomaticKeepAliveClientMixin {
  String? selectedBg;

  final AudioPlayer _player1 = AudioPlayer();
  final FlutterSoundPlayer _player2 = FlutterSoundPlayer();
  bool _isPaused = false;
  bool _isPlaying = false;
  String? currentlyPlayingIndex;

  @override
  void initState() {
    super.initState();
    _player2.openAudioSession();
    fetchData();
  }

  @override
  void dispose() {
    super.dispose();
    _player1.dispose();
    _player2.closeAudioSession();
  }

  Future<void> _startPlayback(String audioUrl) async {
    try {
      await _player2.startPlayer(
        fromURI: widget.filePath,
        whenFinished: () {
          setState(() {
            _isPlaying = false;
          });
          _player1.stop();
        },
      );

      await _player1.setUrl(audioUrl);
      _player1.play();
      _player1.setVolume(1);

      setState(() {
        _isPlaying = true;
      });
    } catch (e) {
      print('Error starting playback: $e');
    }
  }

  Future<void> _stopPlayback() async {
    try {
      await _player2.stopPlayer();
      _player1.stop();
      setState(() {
        _isPlaying = false;
      });
    } catch (e) {
      print('Error stopping playback: $e');
    }
  }

  Future<void> fetchData() async {
    final provider = Provider.of<BgAudioProvider>(context, listen: false);
    if (provider.bgCategories.isEmpty) {
      await provider.fetchCategories();
    }
  }

  final List<Color> randomColors = [
    Colors.redAccent,
    Colors.blueAccent,
    Colors.greenAccent,
    Colors.yellowAccent,
    Colors.orangeAccent,
    Colors.pinkAccent,
    Colors.purpleAccent,
    Colors.indigoAccent,
    Colors.deepOrangeAccent
  ];
  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin

    final provider = Provider.of<BgAudioProvider>(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        title: const Text(
          "Background Music",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: TextButton(
              onPressed: () => Get.to(const PodcastUploadPage(),transition: Transition.cupertino),
              child: const Text(
                'Next',
                style: TextStyle(
                    color: blueColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w400),
              ),
            ),
          )
        ],
      ),
      body: provider.isLoading
          ? Center(
              child: Image.asset(
                liveGif,
                color: blueColor,
                scale: 2,
              ),
            )
          : provider.bgCategories.isEmpty
              ? Center(child: Image.asset(emptyImage))
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: provider.bgCategories.length,
                  itemBuilder: (context, index) {
                    final category = provider.bgCategories[index];
                    final categoryItems = category.data.map((e) {
                      final isCurrentlyPlaying = currentlyPlayingIndex == e.id;
                      var isSelected = selectedBg == e.id;
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 6),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6)),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    if (isCurrentlyPlaying) {
                                      if (_isPlaying) {
                                        _stopPlayback();
                                      } else {
                                        _startPlayback(e.audioUrl);
                                      }
                                    } else {
                                      if (_isPlaying) {
                                        _stopPlayback();
                                      }
                                      setState(() {
                                        currentlyPlayingIndex = e.id;
                                      });
                                      _startPlayback(e.audioUrl);
                                    }
                                  },
                                  icon: Icon(
                                    isCurrentlyPlaying && _isPlaying
                                        ? Icons.pause_circle
                                        : Icons.play_circle,
                                    size: 48,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  e.name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500),
                                ),
                                IconButton(
                                  onPressed: () {
                                    if (selectedBg == e.id) {
                                      setState(() {
                                        selectedBg = '';
                                      });
                                    } else {
                                      setState(() {
                                        selectedBg = e.id;
                                      });
                                    }
                                  },
                                  icon: Icon(
                                    !isSelected ? Icons.add : Icons.done,
                                    size: 38,
                                  ),
                                ),
                              ]),
                        ),
                      );
                    }).toList();

                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 4,
                          ),
                          child: Container(
                            color: randomColors[index % randomColors.length],
                            width: double.infinity,
                            child: ExpansionTile(
                              title: Text(
                                category.category,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                ),
                              ),
                              trailing: const Icon(
                                Icons.keyboard_arrow_down, // Dropdown icon
                                color: Colors.white,
                                size: 30,
                              ),
                              children: categoryItems, // List of songs
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
    );
  }

  @override
  bool get wantKeepAlive => true; // Required for AutomaticKeepAliveClientMixin
}
