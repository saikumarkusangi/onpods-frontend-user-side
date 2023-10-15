import 'package:flutter/material.dart';
import 'package:onpods/models/dummy_data.dart';
import 'package:onpods/resources/dummy_service.dart';

class DummyProvider with ChangeNotifier {
  List<DummyDataModel> _data = [];
  List<DummyDataModel> get data => _data;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  fetchData() async {
    try {
      _isLoading = true;
      notifyListeners();
      _data = await DummyService().fetch();
     
      _isLoading = false;
    } catch (e) {
      throw Exception(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
