import 'dart:convert';
import 'dart:io';
import 'package:onpods/constants/constants.dart';
import 'package:onpods/models/models_exports.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class QuoteService {

  // ------------------------------ Quote Categories -------------------------------------0

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


  // ------------------------------ Quotes by category Id ------------------------------------

  Future<List<QuotesModel>> quotesByCategory(id,page) async {
    final preps = await SharedPreferences.getInstance();
    final userId = preps.getString('user_id');
       print('calling api quotes by category : @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/quote/category/$id/?page=$page'),
          headers: {"Authorization":userId!}
          );
      if (response.statusCode == 200) {
        final jsonData = [jsonDecode(response.body)];
        final List<QuotesModel> quotes = jsonData
            .map((item) {
              return QuotesModel.fromJson(item);
            })
            .toList();
        return quotes;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception(e);
    }
  }


  // ------------------------------ Upload Quotes ------------------------------------

 Future<bool> uploadQuotes(String id, File image) async {
  final prefs = await SharedPreferences.getInstance();
  final userId = prefs.getString('user_id');
  print('calling api quotes upload : @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');

  try {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/quote/upload'),
    );
    request.headers['Authorization'] = userId!;

    // Add the file to the request
    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        image.path,
      ),
    );

    // Add other form data, if needed
    request.fields['category'] = id;

    final response = await request.send();
    final responseString = await response.stream.bytesToString();

    print(responseString);

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    throw Exception(e);
  }
}


// ------------------------------ Upload Quotes ------------------------------------

 Future<bool> deleteQuotes(String id) async {
  final prefs = await SharedPreferences.getInstance();
  final userId = prefs.getString('user_id');
  print('calling api quotes delete : @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');

  try {
    final response =await http.delete(
      Uri.parse('$baseUrl/quote/$id'),
       headers: {"Authorization":userId!}
    );


    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    throw Exception(e);
  }
}

}
