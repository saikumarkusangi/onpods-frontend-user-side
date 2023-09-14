import 'dart:io';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_sound_lite/public/flutter_sound_recorder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:onpods/providers/providers_exports.dart';
import 'package:onpods/screens/podcast_screen/custom_audio_player.dart';
import 'package:onpods/utils/utils_exports.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class RecordPodcast extends StatefulWidget {
  const RecordPodcast({super.key});

  @override
  State<RecordPodcast> createState() => _RecordPodcastState();
}

class _RecordPodcastState extends State<RecordPodcast> {
  final recorder = FlutterSoundRecorder();
  CustomAudioPlayer _player = CustomAudioPlayer();

  Future record() async {
    await recorder.startRecorder(toFile: '/downloads');
  }

  Future pause() async {
    await recorder.pauseRecorder();
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
                  style: TextStyle(fontSize: 14, color: Colors.blue),
                )),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Yes',
                  style: TextStyle(fontSize: 14, color: Colors.blue)),
            ),
          ],
        );
      },
    );
    if (confirm) {
      bool? result = await recorder.deleteRecord(fileName: 'audio');
    }
  }

  Future resume() async {
    await recorder.resumeRecorder();
  }

  Future stop() async {
    final path = await recorder.stopRecorder();
    final audioFile = path!;
    print(audioFile);
  }

  @override
  void initState() {
    super.initState();

    initRecorder();
  }

  @override
  void dispose() {
    recorder.closeAudioSession();
    super.dispose();
  }

  Future initRecorder() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw 'Microphone permission not granted';
    }

    await recorder.openAudioSession();

    recorder.setSubscriptionDuration(const Duration(milliseconds: 500));
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
                  style: TextStyle(fontSize: 14, color: Colors.blue),
                )),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Yes',
                  style: TextStyle(fontSize: 14, color: Colors.blue)),
            ),
          ],
        );
      },
    );
    return confirm;
  }

  @override
  Widget build(BuildContext context) {
    final recorderProvider = Provider.of<RecorderProvider>(context);
    final audioProvider = Provider.of<AudioPlayerProvider>(context);

    
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          if (recorderProvider.state == 'recording' ||
              recorderProvider.state == 'paused' ||
              recorderProvider.state == "stopped" ||
              recorderProvider.state == 'resume') {
            bool res = await showBackDialog();
            if (res) {
              recorderProvider.updateState('not_recording');
            }
          }

          return recorderProvider.state == 'not_recording';
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
                  child: recorderProvider.state == 'stopped'
                      ? ElevatedButton.icon(
                          onPressed: () async {
                            if (audioProvider.isPlaying) {
                              await _player.playSounds();
                              audioProvider.playing();
                            } else {
                              await _player.stop();
                              audioProvider.stopped();
                            }
                          },
                          icon: audioProvider.isPlaying
                              ? const Icon(Icons.pause)
                              : const Icon(Icons.play_arrow),
                          label: const Text('Preview'))
                      : null),
            ),
            Positioned(
              top: 100,
              left: MediaQuery.of(context).size.width * 0.4,
              child: Align(
                alignment: Alignment.topCenter,
                child: StreamBuilder<RecordingDisposition>(
                    stream: recorder.onProgress,
                    builder: (context, snapshot) {
                      final duration = snapshot.hasData
                          ? snapshot.data!.duration
                          : Duration.zero;

                      String towDigits(int n) => n.toString().padLeft(2);
                      final twoDigitMinutes =
                          towDigits(duration.inMinutes.remainder(60));
                      final twoDigitSeconds =
                          towDigits(duration.inSeconds.remainder(60));

                      return Text(
                        '$twoDigitMinutes :$twoDigitSeconds',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 32),
                      );
                    }),
              ),
            ),

            recorderProvider.state == 'recording'
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

            recorderProvider.state != 'stopped'
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
                      child: audioProvider.isPlaying
                          ? Image.network('https://i.gifer.com/KNGq.gif')
                          : SvgPicture.asset(
                              cdImage,
                            ),
                    ),
                  ).animate().moveY(
                      begin: MediaQuery.of(context).size.height * 1.5,
                      delay: 4.ms,
                    ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20, left: 20),
                child: recorderProvider.state == 'stopped' ||
                        recorderProvider.state == 'paused' ||
                        recorderProvider.state == 'resume' ||
                        recorderProvider.state == 'recording'
                    ? IconButton(
                        onPressed: () async {
                          if (recorderProvider.state == 'recording') {
                            recorderProvider.updateState('paused');
                            await pause();
                          } else if (recorderProvider.state == 'paused') {
                            recorderProvider.updateState('resume');
                            await resume();
                          } else if (recorderProvider.state == 'stoped') {
                            await delete();
                            recorderProvider.updateState('not_recording');
                          }
                        },
                        icon: CircleAvatar(
                          backgroundColor: Colors.grey,
                          radius: 34,
                          child: Icon(
                            recorderProvider.state == 'paused'
                                ? Icons.play_arrow
                                : recorderProvider.state == 'stopped'
                                    ? Icons.delete
                                    : Icons.pause,
                            color: Colors.white,
                            size: 38,
                          ),
                        ))
                    : null,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: IconButton(
                    onPressed: () async {
                    
                      if (recorderProvider.state == 'recording') {
                          bool confirm = await showBackDialog();
                        recorderProvider.updateState('paused');
                        await pause();
                      
                        if (confirm) {
                          recorderProvider.updateState('stopped');
                          await stop();
                        }
                      } else {
                        recorderProvider.updateState('recording');
                        await resume();
                      }
                    },
                    icon: CircleAvatar(
                      backgroundColor: Colors.red,
                      radius: 34,
                      child: Icon(
                        recorderProvider.state == 'recording' ||
                                recorderProvider.state == 'paused' ||
                                recorderProvider.state == 'resume'
                            ? Icons.stop
                            : Icons.mic,
                        color: Colors.white,
                        size: 38,
                      ),
                    )),
              ),
            ).animate().fadeIn(delay: const Duration(milliseconds: 700)),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20, right: 20),
                child: recorderProvider.state == 'stopped'
                    ? IconButton(
                        onPressed: () async {},
                        icon: CircleAvatar(
                          backgroundColor: Colors.green,
                          radius: 34,
                          child: Icon(
                            recorderProvider.state == 'stopped'
                                ? Icons.arrow_forward_rounded
                                : null,
                            color: Colors.white,
                            size: 38,
                          ),
                        ))
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
