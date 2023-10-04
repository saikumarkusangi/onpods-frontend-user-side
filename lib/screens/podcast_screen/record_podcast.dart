import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_sound_lite/flutter_sound.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:onpods/providers/bg_audio_provider.dart';
import 'package:onpods/providers/ui_providers/timer_provider.dart';
import 'package:onpods/screens/podcast_screen/bg_add.dart';
import 'package:onpods/screens/podcast_screen/sound_effect_add.dart';
import 'package:onpods/screens/podcast_screen/upload_podcast.dart';
import 'package:onpods/utils/utils_exports.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class RecordPodcast extends StatefulWidget {
  const RecordPodcast({super.key});

  @override
  State<RecordPodcast> createState() => _RecordPodcastState();
}

class _RecordPodcastState extends State<RecordPodcast> {
  late Timer _timer;
  final StreamController<Duration> _recordingDurationStreamController =
      StreamController<Duration>();
  late FlutterSoundPlayer _audioPlayer;
  late FlutterSoundRecorder _audioRecorder;
  bool _isRecording = false;
  bool _isPaused = false;
  bool _isStoped = false;
  bool _isPlaying = false;

  final AudioPlayer _player1 = AudioPlayer();
  final AudioPlayer _player2 = AudioPlayer();
  late String _audioFilePath;
  ValueNotifier<double> musicVolume = ValueNotifier<double>(0.5);
  ValueNotifier<int> currentBg = ValueNotifier<int>(0);
   ValueNotifier<double> soundEffectVolume = ValueNotifier<double>(0.5);
  ValueNotifier<int> currentSoundEffect = ValueNotifier<int>(0);
  
  @override
  void initState() {
    super.initState();
    _audioPlayer = FlutterSoundPlayer();
    _audioRecorder = FlutterSoundRecorder();
    _recordingDurationStreamController.add(Duration.zero);
  }

  Future<void> _startRecording() async {
    try {
      final status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        throw 'Microphone permission not granted';
      }
      await _audioRecorder.openAudioSession();
      _audioFilePath = 'recording.aac'; // Set the file path
      await _audioRecorder.startRecorder(
        toFile: _audioFilePath,
        codec: Codec.aacADTS,
      );
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        context.read<RecordingDurationProvider>().updateRecordingDuration(
              context.read<RecordingDurationProvider>().recordingDuration +
                  const Duration(seconds: 1),
            );
      });

      setState(() {
        _isRecording = true;
      });
    } catch (e) {
      throw ('Error starting recording: $e');
    }
  }

  Future<void> _stopRecording() async {
    try {
      await _audioRecorder.stopRecorder();
      _timer.cancel();
      _player1.stop();
      _player2.stop();
      context
          .read<RecordingDurationProvider>()
          .updateRecordingDuration(Duration.zero);
      setState(() {
        _isRecording = false;
        _isStoped = true;
      });
    } catch (e) {
      throw ('Error stopping recording: $e');
    }
  }

  Future<void> _resumeRecording() async {
    try {
      await _audioRecorder.resumeRecorder();
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        context.read<RecordingDurationProvider>().updateRecordingDuration(
              context.read<RecordingDurationProvider>().recordingDuration +
                  const Duration(seconds: 1),
            );
      });
      setState(() {
        _isPaused = false;
      });
    } catch (e) {
      throw ('Error stopping recording: $e');
    }
  }

  Future<void> _pausedRecording() async {
    try {
      await _audioRecorder.pauseRecorder();
      _timer.cancel();

      setState(() {
        _isPaused = true;
      });
    } catch (e) {
      throw ('Error stopping recording: $e');
    }
  }

  Future<void> _startPlayback() async {
    try {
      await _audioPlayer.openAudioSession();

      await _audioPlayer.startPlayer(
        fromURI: _audioFilePath,
        whenFinished: () {
          setState(() {
            _isPlaying = false;
          });
        },
      );

      setState(() {
        _isPlaying = true;
      });
    } catch (e) {
      throw ('Error starting playback: $e');
    }
  }

  Future<void> _stopPlayback() async {
    try {
      await _audioPlayer.stopPlayer();

      setState(() {
        _isPlaying = false;
      });
    } catch (e) {
      throw ('Error stopping playback: $e');
    }
  }

  Future<void> _deleteAudioFile() async {
    try {
      final file = File(_audioFilePath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      throw ('Error deleting audio file: $e');
    }
  }

  @override
  void dispose() {
    _player1.dispose();
    _player2.dispose();
    _audioPlayer.closeAudioSession();
    _audioRecorder.closeAudioSession();
    _deleteAudioFile();
    _timer.cancel();

    context
        .read<RecordingDurationProvider>()
        .updateRecordingDuration(Duration.zero);

    super.dispose();
  }

  Future delete() async {
    bool confirm = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          title: const Text('Delete Recording?'),
          content: const Text(
            'Are you sure you want to delete your recording?',
            style: TextStyle(fontSize: 16),
          ),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text(
                  'No',
                  style: TextStyle(fontSize: 20, color: blueColor),
                )),
            TextButton(
              onPressed: () {
                setState(() {
                  _isStoped = false;
                  _isPaused = false;
                });
                Navigator.of(context).pop(true);
              },
              child: const Text('Yes',
                  style: TextStyle(fontSize: 20, color: blueColor)),
            ),
          ],
        );
      },
    );
    if (confirm) _deleteAudioFile();
  }

  String formatDuration(Duration duration) {
    if (duration.inHours > 0) {
      // If duration is greater than an hour, format as hh:mm:ss
      final twoDigitHours = duration.inHours.toString().padLeft(2, '0');
      final twoDigitMinutes =
          (duration.inMinutes % 60).toString().padLeft(2, '0');
      final twoDigitSeconds =
          (duration.inSeconds % 60).toString().padLeft(2, '0');
      return '$twoDigitHours:$twoDigitMinutes:$twoDigitSeconds';
    } else {
      // Otherwise, format as mm:ss
      final twoDigitMinutes =
          (duration.inMinutes % 60).toString().padLeft(2, '0');
      final twoDigitSeconds =
          (duration.inSeconds % 60).toString().padLeft(2, '0');
      return '$twoDigitMinutes:$twoDigitSeconds';
    }
  }

  Future<bool> showBackDialog() async {
    bool confirm = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          title: const Text('Stop Recording?'),
          content: const Text(
            'Are you sure you want to stop your recording?',
            style: TextStyle(fontSize: 16),
          ),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text(
                  'No',
                  style: TextStyle(fontSize: 18, color: blueColor),
                )),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Yes',
                  style: TextStyle(fontSize: 18, color: blueColor)),
            ),
          ],
        );
      },
    );
    return confirm;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BgAudioProvider>(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: WillPopScope(
        onWillPop: () async {
          if (_isRecording || _isStoped) {
            _pausedRecording();
            bool res = await showBackDialog();
            if (res) {
              context
                  .read<RecordingDurationProvider>()
                  .updateRecordingDuration(Duration.zero);
              Get.back();
            }
          }

          return true;
        },
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 80),
              child: Align(
                  alignment: Alignment.topCenter,
                  child: _isStoped
                      ? ElevatedButton.icon(
                          onPressed: () async {
                            if (_isPlaying) {
                              _stopPlayback();
                            } else {
                              _startPlayback();
                            }
                          },
                          icon: _isPlaying
                              ? const Icon(
                                  Icons.pause,
                                  color: blueColor,
                                  size: 28,
                                )
                              : const Icon(
                                  Icons.play_arrow,
                                  color: blueColor,
                                  size: 28,
                                ),
                          label: const Text(
                            'Preview',
                            style: TextStyle(color: blueColor, fontSize: 18),
                          ))
                      : null),
            ),
            // !_isStoped
            //     ? const Align(
            //         alignment: Alignment.bottomCenter,
            //         child: Padding(
            //           padding: EdgeInsets.symmetric(vertical: 5),
            //           child: Text(
            //             'Use headphones for better quality',
            //             style: TextStyle(
            //                 color: Color.fromARGB(255, 255, 255, 255)),
            //           ),
            //         ),
            //       )
            //     : const SizedBox(),
            _isStoped
                ? Align(
                    alignment: Alignment.center,
                    child: RotationTransition(
                            turns: const AlwaysStoppedAnimation(90 / 360),
                            child: Image.asset(
                                _isPlaying ? playerGif : playerImage))
                        .animate()
                        .moveY(
                          begin: MediaQuery.of(context).size.height * 1.5,
                          delay: 4.ms,
                        ),
                  )
                : const SizedBox(),
            Column(children: [
              !_isStoped
                  ? Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 50),
                        child: Consumer<RecordingDurationProvider>(
                          builder: (context, durationProvider, child) {
                            return Text(
                              formatDuration(
                                  durationProvider.recordingDuration),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                              ),
                            );
                          },
                        ),
                      ),
                    )
                  : const SizedBox(),
            
              !_isStoped
                  ? SizedBox(
                      height: MediaQuery.of(context).size.height * 0.68,
                      child: DefaultTabController(
                          length: 2,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const TabBar(
                                  indicatorSize: TabBarIndicatorSize.tab,
                                  labelColor: Colors.white,
                                  indicatorColor: Colors.white,
                                  dividerColor: Colors.black,
                                  unselectedLabelColor: Colors.white60,
                                  tabs: [
                                    Tab(
                                      icon: Icon(Icons.music_note),
                                      text: 'Music',
                                    ),
                                    Tab(
                                      icon: Icon(Icons.spatial_audio),
                                      text: 'Sound Effects',
                                    )
                                  ],
                                ),
                                Flexible(
                                  child: TabBarView(
                                  
                                    children: [
                                   
                                    Stack(
                                      children: [
                                       
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 4),
                                          child: GridView.builder(
                                            gridDelegate:
                                                const SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: 4,
                                                    childAspectRatio: 0.8,
                                                    mainAxisSpacing: 0.0),
                                            shrinkWrap: true,
                                            itemCount:
                                                provider.selectedBg.length + 1,
                                            itemBuilder: (context, index) {
                                              final data = index <
                                                      provider.selectedBg.length
                                                  ? provider.selectedBg[index]
                                                  : null;
                                              if (index >=
                                                  provider.selectedBg.length) {
                                                return Column(
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        _player1.stop();
                                                        Get.to(const BgAdd());
                                                      },
                                                      child: Container(
                                                        width: 55,
                                                        height: 55,
                                                        decoration: BoxDecoration(
                                                            color: const Color
                                                                .fromARGB(255,
                                                                44, 41, 41),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        100)),
                                                        child: const Center(
                                                            child: Icon(
                                                          Icons.add,
                                                          size: 32,
                                                          color: Colors.white,
                                                        )),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              } else {
                                                return Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    GestureDetector(
                                                        onTap: () async {
                                                          final audioUrl =
                                                              data!['audiourl'];

                                                          if (audioUrl !=
                                                              null) {
                                                            final audioSource =
                                                                AudioSource.uri(
                                                                    Uri.parse(
                                                                        audioUrl));
                                                            await _player1
                                                                .setAudioSource(
                                                                    audioSource);
                                                            if (_player1
                                                                    .playing &&
                                                                currentBg
                                                                        .value ==
                                                                    index) {
                                                              _player1.stop();
                                                            } else {
                                                              _player1.play();
                                                              currentBg.value =
                                                                  index;
                                                            }
                                                          }
                                                        },
                                                        child: Stack(
                                                          children: [
                                                            Container(
                                                              width: 50,
                                                              height: 50,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: const Color
                                                                    .fromARGB(
                                                                    255,
                                                                    44,
                                                                    41,
                                                                    41),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            100),
                                                              ),
                                                              child:
                                                                  const Center(
                                                                child: Icon(
                                                                  Icons
                                                                      .music_note,
                                                                  color: Colors
                                                                      .white,
                                                                  size: 32,
                                                                ),
                                                              ),
                                                            ),
                                                            Positioned.fill(
                                                              child:
                                                                  StreamBuilder<
                                                                      Duration>(
                                                                stream: _player1
                                                                    .positionStream, // Stream of audio playback position
                                                                builder: (context,
                                                                    snapshot) {
                                                                  final position = snapshot
                                                                          .data ??
                                                                      Duration
                                                                          .zero; // Current playback position
                                                                  return CircularProgressIndicator(
                                                                    value: currentBg.value ==
                                                                            index
                                                                        ? position.inMilliseconds /
                                                                            (_player1.duration?.inMilliseconds ??
                                                                                1)
                                                                        : 0,
                                                                    backgroundColor:
                                                                        const Color
                                                                            .fromARGB(
                                                                            255,
                                                                            107,
                                                                            106,
                                                                            106),
                                                                    valueColor: const AlwaysStoppedAnimation<
                                                                            Color>(
                                                                        Colors
                                                                            .white),
                                                                  );
                                                                },
                                                              ),
                                                            ),
                                                          ],
                                                        )),
                                                    const SizedBox(
                                                      height: 6,
                                                    ),
                                                    Text(
                                                      data!['name'] ??
                                                          'undefined',
                                                      maxLines: 1,
                                                      style: const TextStyle(
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          color: Colors.white,
                                                          fontSize: 14),
                                                    ),
                                                  ],
                                                );
                                              }
                                            },
                                          ),
                                        ),
                                         Positioned(
                                        top: 20,
                                        left: 20,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Icon(
                                                Icons.volume_up_rounded,
                                                color: Colors.white,
                                              ),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.75,
                                                child: ValueListenableBuilder<
                                                    double>(
                                                  valueListenable: musicVolume,
                                                  builder:
                                                      (context, volume, child) {
                                                    return Slider(
                                                      activeColor: blueColor,
                                                      value: volume,
                                                      onChanged: (value) {
                                                        musicVolume.value = value;
                                                        _player1.setVolume(value);
                                                      },
                                                    );
                                                  },
                                                ),
                                              ),
                                              ValueListenableBuilder<double>(
                                                  valueListenable: musicVolume,
                                                  builder:
                                                      (context, volume, child) {
                                                    return Text(
                                                      '${(volume * 100).toStringAsFixed(0)}%',
                                                      style: const TextStyle(
                                                          color: Colors.white),
                                                    );
                                                  })
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Stack(
                                      children: [
                                       
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 4),
                                          child: GridView.builder(
                                            gridDelegate:
                                                const SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: 4,
                                                    childAspectRatio: 0.8,
                                                    mainAxisSpacing: 0.0),
                                            shrinkWrap: true,
                                            itemCount:
                                                provider.selectedSoundEffects.length + 1,
                                            itemBuilder: (context, index) {
                                              final data = index <
                                                      provider.selectedSoundEffects.length
                                                  ? provider.selectedSoundEffects[index]
                                                  : null;
                                              if (index >=
                                                  provider.selectedSoundEffects.length) {
                                                return Column(
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        _player2.stop();
                                                        Get.to(const SoundEffectAdd());
                                                      },
                                                      child: Container(
                                                        width: 55,
                                                        height: 55,
                                                        decoration: BoxDecoration(
                                                            color: const Color
                                                                .fromARGB(255,
                                                                44, 41, 41),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        100)),
                                                        child: const Center(
                                                            child: Icon(
                                                          Icons.add,
                                                          size: 32,
                                                          color: Colors.white,
                                                        )),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              } else {
                                                return Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    GestureDetector(
                                                        onTap: () async {
                                                          final audioUrl =
                                                              data!['sound'];

                                                          if (audioUrl !=
                                                              null) {
                                                            final audioSource =
                                                                AudioSource.uri(
                                                                    Uri.parse(
                                                                        audioUrl));
                                                            await _player2
                                                                .setAudioSource(
                                                                    audioSource);
                                                            if (_player2
                                                                    .playing &&
                                                                currentSoundEffect
                                                                        .value ==
                                                                    index) {
                                                              _player2.stop();
                                                            } else {
                                                              _player2.play();
                                                              currentSoundEffect.value =
                                                                  index;
                                                            }
                                                          }
                                                        },
                                                        child: Stack(
                                                          children: [
                                                            Container(
                                                              width: 50,
                                                              height: 50,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: const Color
                                                                    .fromARGB(
                                                                    255,
                                                                    44,
                                                                    41,
                                                                    41),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            100),
                                                              ),
                                                              child:
                                                                   Center(
                                                                child: Padding(
                                                                  padding: const EdgeInsets.all(8.0),
                                                                  child: CachedNetworkImage(
                                                                  imageUrl:  data!['icon'] ?? '',
                                                                    color: Colors.white,
                                                                    errorWidget: (context, url, error) => const Icon(Icons.music_note,
                                                                    color:Colors.white,  size: 32,),
                                                                  ),
                                                                )
                                                              ),
                                                            ),
                                                            Positioned.fill(
                                                              child:
                                                                  StreamBuilder<
                                                                      Duration>(
                                                                stream: _player2
                                                                    .positionStream, // Stream of audio playback position
                                                                builder: (context,
                                                                    snapshot) {
                                                                  final position = snapshot
                                                                          .data ??
                                                                      Duration
                                                                          .zero; // Current playback position
                                                                  return CircularProgressIndicator(
                                                                    value: currentSoundEffect.value ==
                                                                            index
                                                                        ? position.inMilliseconds /
                                                                            (_player2.duration?.inMilliseconds ??
                                                                                1)
                                                                        : 0,
                                                                    backgroundColor:
                                                                        const Color
                                                                            .fromARGB(
                                                                            255,
                                                                            107,
                                                                            106,
                                                                            106),
                                                                    valueColor: const AlwaysStoppedAnimation<
                                                                            Color>(
                                                                        Colors
                                                                            .white),
                                                                  );
                                                                },
                                                              ),
                                                            ),
                                                          ],
                                                        )),
                                                    const SizedBox(
                                                      height: 6,
                                                    ),
                                                    Text(
                                                      data!['name'] ??
                                                          'undefined',
                                                      maxLines: 1,
                                                      style: const TextStyle(
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          color: Colors.white,
                                                          fontSize: 14),
                                                    ),
                                                  ],
                                                );
                                              }
                                            },
                                          ),
                                        ),
                                         Positioned(
                                        top: 20,
                                        left: 20,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Icon(
                                                Icons.volume_up_rounded,
                                                color: Colors.white,
                                              ),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.75,
                                                child: ValueListenableBuilder<
                                                    double>(
                                                  valueListenable: soundEffectVolume,
                                                  builder:
                                                      (context, volume, child) {
                                                    return Slider(
                                                      activeColor: blueColor,
                                                      value: volume,
                                                      onChanged: (value) {
                                                        soundEffectVolume.value = value;
                                                        _player2.setVolume(value);
                                                      },
                                                    );
                                                  },
                                                ),
                                              ),
                                              ValueListenableBuilder<double>(
                                                  valueListenable: soundEffectVolume,
                                                  builder:
                                                      (context, volume, child) {
                                                    return Text(
                                                      '${(volume * 100).toStringAsFixed(0)}%',
                                                      style: const TextStyle(
                                                          color: Colors.white),
                                                    );
                                                  })
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                 
                                  
                                  ]),
                                )
                              ])),
                    )
                  : const SizedBox()
            ]),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20, left: 20),
                child: _isRecording
                    ? IconButton(
                        onPressed: () async {
                          if (!_isPaused) {
                            _pausedRecording();
                          } else {
                            _resumeRecording();
                          }
                        },
                        icon: CircleAvatar(
                          backgroundColor: Colors.grey,
                          radius: 28,
                          child: Icon(
                            _isPaused ? Icons.play_arrow : Icons.pause,
                            color: Colors.white,
                            size: 38,
                          ),
                        ),
                      )
                    : const SizedBox(),
              ),
            ),
            _isStoped
                ? Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                        padding: const EdgeInsets.only(bottom: 20, left: 20),
                        child: IconButton(
                          onPressed: () async {
                            delete();
                            _stopPlayback();
                          },
                          icon: const CircleAvatar(
                            backgroundColor: Colors.grey,
                            radius: 28,
                            child: Icon(
                              Icons.delete,
                              color: Colors.white,
                              size: 38,
                            ),
                          ),
                        )),
                  )
                : const SizedBox(),
            !_isStoped
                ? Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: IconButton(
                        onPressed: () async {
                          if (_isRecording) {
                            _stopRecording();
                          } else {
                            _startRecording();
                          }
                        },
                        icon: CircleAvatar(
                          backgroundColor: Colors.red,
                          radius: 28,
                          child: Icon(
                            _isRecording ? Icons.stop : Icons.mic,
                            color: Colors.white,
                            size: 38,
                          ),
                        ),
                      ),
                    ),
                  )
                : const SizedBox(),
                  Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20, right: 20),
                child: _isStoped
                    ? IconButton(
                        onPressed: () {
                          _stopPlayback();
                          // Get.to(() => BgAdd(filePath: _audioFilePath),
                          //     transition: Transition.cupertino);
                        },
                        icon: const CircleAvatar(
                          backgroundColor: Colors.lightBlue,
                          radius: 28,
                          child: Icon(
                            Icons.save,
                            color: Colors.white,
                            size: 38,
                          ),
                        ),
                      )
                    : const SizedBox(),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20, right: 20),
                child: _isStoped
                    ? IconButton(
                        onPressed: () {
                          _stopPlayback();
                          Get.to(() => const PodcastUploadPage(),
                              transition: Transition.cupertino);
                        },
                        icon: const CircleAvatar(
                          backgroundColor: Colors.green,
                          radius: 28,
                          child: Icon(
                            Icons.arrow_forward_rounded,
                            color: Colors.white,
                            size: 38,
                          ),
                        ),
                      )
                    : const SizedBox(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
