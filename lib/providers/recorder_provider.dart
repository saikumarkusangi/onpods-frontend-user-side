import 'package:flutter/foundation.dart';

class RecorderProvider with ChangeNotifier {
  String _state = 'not_recording';
  String get state => _state;

  updateState(state) {
    _state = state;
    notifyListeners();
  }
}
