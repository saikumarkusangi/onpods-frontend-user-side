import 'dart:convert';

import 'package:onpods/constants/constants.dart';
import 'package:onpods/models/models_exports.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class QuoteService {
  Future<List<QuotesCategoryModel>> categories() async {
    final preps = await SharedPreferences.getInstance();
    final userId = preps.getString('user_id');
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/quote-category'),
          headers: {"Authorization":userId!}
          );
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
