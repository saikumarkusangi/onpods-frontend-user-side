import 'package:flutter/material.dart';

class RecordingDurationProvider extends ChangeNotifier {
  Duration _recordingDuration = Duration.zero;

  Duration get recordingDuration => _recordingDuration;

  void updateRecordingDuration(Duration duration) {
    _recordingDuration = duration;
    notifyListeners();
  }
}
