import 'dart:convert';
import 'dart:io';

import 'package:onpods/utils/exports.dart';


class BackGroundProvider with ChangeNotifier {
  Color _backgroundColor = Colors.white;
  double _opacity = 1.0;
  double get opacity => _opacity;
  Color get backgroundColor => _backgroundColor;
  int _lastSelected = 0;
  int get lastSelected => _lastSelected;

  bool _isLoading = false;
  List<BackgroundImagesModel> data = [];
  bool get isLoading => _isLoading;
  String backGroundUrlFromInternet = '';
  File backGroundFromGallery = File('');
  File backGroundFromCam = File('');

  clearData() {
    data.clear();
    notifyListeners();
  }

  updateLastSelected(index) {
    _lastSelected = index;
    notifyListeners();
  }

  void changeColor(Color color) {
    _backgroundColor = color;
    _lastSelected = 4;
    notifyListeners();
  }

  void changeOpacity(value) {
    _opacity = value;
    notifyListeners();
  }

  updateBgImageFromGallery(file) {
    backGroundFromGallery = file;
    notifyListeners();
  }

  updateBgImageFromCam(file) {
    backGroundFromCam = file;
    notifyListeners();
  }

  updateBgImageFromInternet(url) {
    backGroundUrlFromInternet = url;
    notifyListeners();
  }

  Future<List<BackgroundImagesModel>> fetchBackGroundImages(query, page) async {
    _isLoading = true;
    data.clear();
    notifyListeners();
    try {
      final response = await PixelService().searchBg(query, page);
      final parsedResponse = json.decode(response);
      final backgroundImages = BackgroundImagesModel.fromJson(parsedResponse);
      data.add(backgroundImages);
      _isLoading = false;
      notifyListeners();
      return data;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw Exception(e);
    }
  }
}
