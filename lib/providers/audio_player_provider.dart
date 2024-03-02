import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:onpods/models/audio_model.dart';

class CurrentAudioProvider extends ChangeNotifier {
  AudioModel? _currentAudio;

  AudioModel? get currentAudio => _currentAudio;

  void setAudio(AudioModel audio) {
    _currentAudio = audio;
    notifyListeners();
  }
}
