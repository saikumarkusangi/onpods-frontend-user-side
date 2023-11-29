import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:onpods/models/podcast_brief_model.dart';
import 'package:onpods/models/podcast_category_model.dart';
import 'package:onpods/utils/exports.dart';

class PodcastService {
  // ------------------------------ Podcast Categories -------------------------------------0
  Future<List<PodcastCategoryModel>> categories() async {
    // final userId = await UserSession.getUserId();
    //  print('################################'+userId.toString());
    print(
        'calling API for podcast categories: @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/podcast-category'),
        // headers: {"Authorization": userId!},
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        final List<PodcastCategoryModel> categories = (jsonData as List)
            .map((item) => PodcastCategoryModel.fromJson(item))
            .toList();

        return categories;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  // ------------------------------ Podcasts by category Id ------------------------------------

  Future<List<PodcastBriefModel>> podcastByCategory(id, page) async {
    final userId = await UserSession.getUserId();
    print(
        'calling api podcasts by category : @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
    try {
      final response = await http.get(
          Uri.parse('$baseUrl/podcast/category/$id/?page=$page'),
          headers: {"Authorization": userId!});
      if (response.statusCode == 200) {
        final jsonData = [jsonDecode(response.body)];
        final List<PodcastBriefModel> podcasts = jsonData.map((item) {
          print(item);
          return PodcastBriefModel.fromJson(item);
        }).toList();
        return podcasts;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  // ------------------------------ Upload Podcast ------------------------------------

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

// ------------------------------Delete Podcast ------------------------------------

  Future<bool> deleteQuotes(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');
    print('calling api quotes delete : @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');

    try {
      final response = await http.delete(Uri.parse('$baseUrl/quote/$id'),
          headers: {"Authorization": userId!});

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
