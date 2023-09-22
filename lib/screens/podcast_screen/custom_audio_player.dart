import 'dart:async';
import 'package:flutter/material.dart';
// import 'package:audioplayers/audioplayers.dart';
import 'package:just_audio/just_audio.dart';

class CustomAudioPlayer {
  AudioPlayer audioPlayer1 = AudioPlayer();
  AudioPlayer audioPlayer2 = AudioPlayer();

  Future stop() async {
    await audioPlayer1.stop();
    await audioPlayer1.stop();
  }

  Future pause() async {
    await audioPlayer1.pause();
    await audioPlayer1.pause();
  }

  Future playSounds() async {
    // await audioPlayer2.play(
    //   UrlSource(
    //       'https://sri.saikumar150.repl.co/no-time-to-die-hartzmann-main-version-9251-02-01.mp3'),
    // );

    Future.delayed(const Duration(seconds: 3), () async {
      // await audioPlayer1.play(
      //   UrlSource(
      //       'https://www.thepodcastexchange.ca/s/AlanCross-Porter-v2.mp3'),
      // );

   
    });

    // audioPlayer2.setReleaseMode(ReleaseMode.loop);
    Timer.periodic(const Duration(seconds: 5), (timer) {
      double currentVolume = audioPlayer2.volume;
      if (currentVolume >= 0.5) {
        audioPlayer2.setVolume(currentVolume - 0.3);
      } else if (currentVolume < 0.5) {
        audioPlayer2.setVolume(currentVolume - 0.2);
      } else {
        timer.cancel();
        audioPlayer2.setVolume(0.015);
      }
    });
  }
}
