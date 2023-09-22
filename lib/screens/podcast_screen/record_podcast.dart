import 'dart:async';
import 'dart:io';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_sound_lite/flutter_sound.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:onpods/providers/providers_exports.dart';
import 'package:onpods/providers/ui_providers/timer_provider.dart';
import 'package:onpods/screens/podcast_screen/bg_add.dart';
import 'package:onpods/screens/podcast_screen/custom_audio_player.dart';
import 'package:onpods/utils/utils_exports.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';

class RecordPodcast extends StatefulWidget {
  const RecordPodcast({super.key});

  @override
  State<RecordPodcast> createState() => _RecordPodcastState();
}

class _RecordPodcastState extends State<RecordPodcast> {
  late Timer _timer;
  StreamController<Duration> _recordingDurationStreamController =
      StreamController<Duration>();
  late FlutterSoundPlayer _audioPlayer;
  late FlutterSoundRecorder _audioRecorder;
  bool _isRecording = false;
  bool _isPaused = false;
  bool _isStoped = false;
  bool _isPlaying = false;
  late String _audioFilePath; // Store the path to the recorded audio file
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
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        context.read<RecordingDurationProvider>().updateRecordingDuration(
              context.read<RecordingDurationProvider>().recordingDuration +
                  Duration(seconds: 1),
            );
      });

      setState(() {
        _isRecording = true;
      });
    } catch (e) {
      print('Error starting recording: $e');
    }
  }

  Future<void> _stopRecording() async {
    try {
      await _audioRecorder.stopRecorder();
      _timer?.cancel();

      // Update the recording duration to zero using Provider
      context
          .read<RecordingDurationProvider>()
          .updateRecordingDuration(Duration.zero);
      setState(() {
        _isRecording = false;
        _isStoped = true;
      });
    } catch (e) {
      print('Error stopping recording: $e');
    }
  }

  Future<void> _resumeRecording() async {
    try {
      await _audioRecorder.resumeRecorder();
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        context.read<RecordingDurationProvider>().updateRecordingDuration(
              context.read<RecordingDurationProvider>().recordingDuration +
                  Duration(seconds: 1),
            );
      });
      setState(() {
        _isPaused = false;
      });
    } catch (e) {
      print('Error stopping recording: $e');
    }
  }

  Future<void> _pausedRecording() async {
    try {
      await _audioRecorder.pauseRecorder();
      _timer?.cancel();

      setState(() {
        _isPaused = true;
      });
    } catch (e) {
      print('Error stopping recording: $e');
    }
  }

  Future<void> _startPlayback() async {
    try {
      await _audioPlayer.openAudioSession();

      await _audioPlayer.startPlayer(
        fromURI: _audioFilePath, // Use the recorded file path
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
      print('Error starting playback: $e');
    }
  }

  Future<void> _stopPlayback() async {
    try {
      await _audioPlayer.stopPlayer();

      setState(() {
        _isPlaying = false;
      });
    } catch (e) {
      print('Error stopping playback: $e');
    }
  }

  Future<void> _deleteAudioFile() async {
    try {
      print('-------------- deleting  -----------------');

      final file = File(_audioFilePath);
      if (await file.exists()) {
        print('------------ deleted  ------------------');
        await file.delete();
      }
    } catch (e) {
      print('------------ $e  ------------------');
      print('Error deleting audio file: $e');
    }
  }

  @override
  void dispose() {
    _audioPlayer.closeAudioSession();
    _audioRecorder.closeAudioSession();

    _deleteAudioFile(); // Delete the audio file when disposing
    _timer?.cancel();

    // Update the recording duration to zero using Provider
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
    print('@@@@@@@@@@@@@');
    final recorderProvider = Provider.of<RecorderProvider>(context);

    return Scaffold(
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
            // Padding(
            //   padding: const EdgeInsets.only(top: 50),
            //   child: Align(
            //       alignment: Alignment.topCenter,
            //       child: recorderProvider.state == 'recording'
            //           ? AvatarGlow(

            //                 child: CircleAvatar(
            //                   backgroundColor: Colors.grey[100],
            //                   child: Image.asset(
            //                     'assets/images/dart.png',
            //                     height: 50,
            //                   ),
            //                   radius: 30.0,
            //                 ),
            //               ),
            //             )
            //           : null),
            // ),
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
            _isRecording
                ? Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 50),
                      child: Consumer<RecordingDurationProvider>(
                        builder: (context, durationProvider, child) {
                          return Text(
                            formatDuration(durationProvider.recordingDuration),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 70,
                            ),
                          );
                        },
                      ),
                    ),
                  )
                : const SizedBox(),

            _isRecording && !_isPaused
                ? const Align(
                    heightFactor: 2,
                    alignment: Alignment.center,
                    child: AvatarGlow(
                      endRadius: 150.0,
                      repeatPauseDuration: Duration(milliseconds: 50),
                      child: Material(
                        shape: CircleBorder(),
                        child: CircleAvatar(
                          backgroundColor: scaffoldBackgroundColor,
                          radius: 50.0,
                        ),
                      ),
                    ),
                  )
                : const SizedBox(),

            !_isStoped
                ? Align(
                    alignment: Alignment.bottomCenter,
                    child: Image.asset(
                      micStand,
                      scale: 1.2,
                    ).animate().moveY(
                        begin: MediaQuery.of(context).size.width * 1.5,
                        delay: 4.ms,
                        duration: const Duration(milliseconds: 300)))
                : Align(
                    alignment: Alignment.center,
                    child: RotationTransition(
                        turns: const AlwaysStoppedAnimation(90 / 360),
                        child:
                            Image.asset(_isPlaying ? playerGif : playerImage)),
                  ).animate().moveY(
                      begin: MediaQuery.of(context).size.height * 1.5,
                      delay: 4.ms,
                    ),

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
                          radius: 34,
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
                            radius: 34,
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
                          radius: 34,
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
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20, right: 20),
                child: _isStoped
                    ? IconButton(
                        onPressed: () {
                          _stopPlayback();
                          Get.to(() => BgAdd(filePath: _audioFilePath),
                              transition: Transition.cupertino);
                        },
                        icon: const CircleAvatar(
                          backgroundColor: Colors.green,
                          radius: 34,
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
