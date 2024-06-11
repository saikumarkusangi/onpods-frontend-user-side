import 'package:flutter/rendering.dart';
import 'package:just_audio/just_audio.dart';
import 'package:onpods/utils/exports.dart';

class BgAdd extends StatefulWidget {
  const BgAdd({Key? key}) : super(key: key);

  @override
  BgAddState createState() => BgAddState();
}

class BgAddState extends State<BgAdd> with AutomaticKeepAliveClientMixin {
  final AudioPlayer _player1 = AudioPlayer();
  bool _isPlaying = false;
  String? currentlyPlayingIndex;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  void dispose() {
    super.dispose();
    _player1.dispose();
  }

  Future<void> _startPlayback(String audioUrl) async {
    try {
      await _player1.setUrl(audioUrl);
      _player1.play();
      _player1.setVolume(1);

      setState(() {
        _isPlaying = true;
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> _stopPlayback() async {
    try {
      _player1.stop();
      setState(() {
        _isPlaying = false;
      });
    } catch (e) {
      throw Exception(e);
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
  Future<void> _pickAudio() async {
    final provider = Provider.of<BgAudioProvider>(context, listen: false);
    try {
      await FilePicker.platform
          .pickFiles(
        type: FileType.audio,
        allowMultiple: false,
      )
          .then((result) {
        if (result != null) {
          final data = {
            'name': result.files.single.name,
            "audiourl": result.files.single.path!
          };
          provider.addSelectedBg(data);
          Get.back();
          return result.files.single.path;
        }
        return null;
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final provider = Provider.of<BgAudioProvider>(context);
    return Scaffold(
       bottomNavigationBar: const MiniPlayer(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: blueColor,
        onPressed: _pickAudio,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        title: const Text(
          "Background music",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
      body: provider.isLoading
          ? Center(
              child: Image.asset(
                liveGif,
                color: blueColor,
                scale: 3,
              ),
            )
          : provider.bgCategories.isEmpty
              ? const Center(
                  child: EmptyPlaceHolder(
                  message: 'Audios',
                ))
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: provider.bgCategories.length,
                  itemBuilder: (context, index) {
                    final category = provider.bgCategories[index];
                    final categoryItems = category.data.map((e) {
                      final isCurrentlyPlaying = currentlyPlayingIndex == e.id;
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
                                    final data = {
                                      'name': e.name,
                                      'audiourl': e.audioUrl,
                                    };
                                    provider.selectedBg.any(
                                            (item) => item['name'] == e.name)
                                        ? provider.removeSelectedBg(data)
                                        : provider.addSelectedBg(data);
                                  },
                                  icon: Icon(
                                    provider.selectedBg.any(
                                            (item) => item['name'] == e.name)
                                        ? Icons.remove_circle
                                        : Icons.add_circle_outline,
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
                              iconColor: Colors.white,
                              collapsedIconColor: Colors.white,

                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    category.category,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                    ),
                                  ),

                                ],
                              ),


                              children: categoryItems.toList(),
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
