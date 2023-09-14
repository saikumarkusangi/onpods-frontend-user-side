import 'dart:convert';

import 'package:onpods/constants/constants.dart';
import 'package:onpods/models/models_exports.dart';
import 'package:http/http.dart' as http;

class QuoteService {
  Future<List<QuotesCategoryModel>> categories() async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/quote/api/categories'));
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        
        final List<QuotesCategoryModel> categories = (jsonData as List)
            .map((item) => QuotesCategoryModel.fromJson(item))
            .toList();
        print('calling api quotes categories : @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
        return categories;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
