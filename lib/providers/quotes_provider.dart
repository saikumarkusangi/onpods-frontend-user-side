import 'package:flutter/material.dart';
import 'package:onpods/models/models_exports.dart';
import 'package:onpods/resources/dummy_service.dart';
import 'package:onpods/resources/quote_service.dart';

class QuoteProvider with ChangeNotifier {
  List<QuotesCategoryModel> _quotesCategories = [];
  List<QuotesCategoryModel> get quotesCategories => _quotesCategories;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  fetchCategories() async {
    try {
      _isLoading = true;
      notifyListeners();
      _quotesCategories = await QuoteService().categories();
     
      _isLoading = false;
    } catch (e) {
      throw Exception(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
