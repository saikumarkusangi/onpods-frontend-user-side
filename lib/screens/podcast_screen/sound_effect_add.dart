import 'package:just_audio/just_audio.dart';
import 'package:onpods/utils/exports.dart';

class SoundEffectAdd extends StatefulWidget {
  const SoundEffectAdd({Key? key}) : super(key: key);

  @override
  SoundEffectAddState createState() => SoundEffectAddState();
}

class SoundEffectAddState extends State<SoundEffectAdd>
    with AutomaticKeepAliveClientMixin {
  final AudioPlayer _player1 = AudioPlayer();
  bool _isPlaying = false;
  String? currentlyPlayingIndex;

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
          final uuid = Random();
          String generatedUuid = uuid.nextInt(4).toString();
          final data = {
            'name': result.files.single.name,
            "sound": result.files.single.path!,
            'id': generatedUuid
          };
          provider.addSoundEffect(data);
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
          "Choose Sound Effect",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
       
      ),
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: soundEffects.length,
        itemBuilder: (context, index) {
          final category = soundEffects[index];
          final categoryItems =
              List<Widget>.from(category['data'].map<Widget>((e) {
            final isCurrentlyPlaying = currentlyPlayingIndex == e['id'];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
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
                              _startPlayback(e['sound']);
                            }
                          } else {
                            if (_isPlaying) {
                              _stopPlayback();
                            }
                            setState(() {
                              currentlyPlayingIndex = e['id'];
                            });
                            _startPlayback(e['sound']);
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
                        e['name'],
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      IconButton(
                        onPressed: () {
                          final data = {
                            'name': e['name'],
                            'sound': e['sound'],
                            'icon': e['icon']
                          };
                          provider.selectedSoundEffects
                                  .any((item) => item['name'] == e['name'])
                              ? provider.removeSoundEffect(data)
                              : provider.addSoundEffect(data);
                        },
                        icon: Icon(
                          provider.selectedSoundEffects
                                  .any((item) => item['name'] == e['name'])
                              ? Icons.remove_circle
                              : Icons.add_circle_outline,
                          size: 38,
                        ),
                      ),
                    ]),
              ),
            );
          }).toList());

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
                      category['category'],
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
