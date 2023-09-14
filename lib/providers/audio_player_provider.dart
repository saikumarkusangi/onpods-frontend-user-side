import 'package:flutter/material.dart';

class AudioPlayerProvider with ChangeNotifier {
  bool _isPlaying = false;
  bool get isPlaying => _isPlaying;

  playing() {
    _isPlaying = true;
    notifyListeners();
  }

  stopped() {
    _isPlaying = false;
    notifyListeners();
  }
}
