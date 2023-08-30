import 'package:flutter/material.dart';

class IconColorProvider extends ChangeNotifier {
  Color _activeColor = Colors.blue; 

  Color get activeColor => _activeColor;

  void setActiveColor(Color color) {
    _activeColor = color;
    notifyListeners();
  }
}
