import 'package:flutter/material.dart';
import 'package:onpods/models/bg_audio_model.dart';
import 'package:onpods/models/models_exports.dart';
import 'package:onpods/resources/bg_audio_service.dart';
import 'package:onpods/resources/quote_service.dart';

class BgAudioProvider with ChangeNotifier {
  List<BgModel> _bgCategories = [];
  List<BgModel> get bgCategories => _bgCategories;
  List<Map<String, String>> _selectedBg = [];
List<Map<String, String>> get selectedBg => _selectedBg;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  fetchCategories() async {
    try {
      _isLoading = true;
      notifyListeners();
      _bgCategories = await BgAudioService().fetch();
      _isLoading = false;
    } catch (e) {
     
      throw Exception(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

addSelectedBg(Map<String, String> data) {
    _selectedBg.add(data);
  notifyListeners();
}

removeSelectedBg(Map<String, String> data) {
  _selectedBg.removeWhere((item) =>
      item['name'] == data['name']);
  notifyListeners();
}


}
