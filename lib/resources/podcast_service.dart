import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:onpods/models/banner_model.dart';
import 'package:onpods/models/current_podcast_model.dart';
import 'package:onpods/models/podcast_model.dart';
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

  // ------------------------------ Podcast Suggests -------------------------------------0
  Future<List<BannerModel>> suggestPodcasts() async {
    final userId = await UserSession.getUserId();
    //  print('################################'+userId.toString());
    print(
        'calling API for podcast suggest: @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/podcast/suggest'),
        headers: {"Authorization": userId!},
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        final List<dynamic> dataList = jsonData['data'];

        // Convert each element to BannerModel
        final List<BannerModel> data = dataList.map((dynamic item) {
          return BannerModel.fromJson(item);
        }).toList();

        return data;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  // ------------------------------ Podcast All Categories -------------------------------------0
  Future<List<PodcastCategoryModel>> allcategories() async {
    // final userId = await UserSession.getUserId();
    //  print('################################'+userId.toString());
    print(
        'calling API for all podcast categories: @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/podcast-category/all'),
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

  Future<List<PodcastModel>> podcastByCategory(id, page,sortBy) async {
    final userId = await UserSession.getUserId();
    print(
        'calling api podcasts by category : @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
    try {
      final response = await http.get(
          Uri.parse('$baseUrl/podcast/category/$id/?page=$page&sortBy=$sortBy'),
          headers: {"Authorization": userId!});
      if (response.statusCode == 200) {
        final jsonData = [jsonDecode(response.body)];

        final List<PodcastModel> podcasts = jsonData.map((item) {
          return PodcastModel.fromJson(item);
        }).toList();
        return podcasts;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  // ------------------------------ Podcasts by Filter Types ------------------------------------

  Future<List<PodcastModel>> trendingPodcasts() async {
    final userId = await UserSession.getUserId();
    print(
        'calling api trending podcasts : @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
    try {
      final response = await http.get(Uri.parse('$baseUrl/podcast/trending'),
          headers: {"Authorization": userId!});
      if (response.statusCode == 200) {
        final jsonData = [jsonDecode(response.body)];

        final List<PodcastModel> podcasts = jsonData.map((item) {
          return PodcastModel.fromJson(item);
        }).toList();
        return podcasts;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception(e);
    }
  }
  // ------------------------------ Listen Episode ------------------------------------

  Future listenEpisode(podcastId, id) async {
    final userId = await UserSession.getUserId();
    print(
        'calling api listen episode : @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
    try {
      final response = await http.get(
          Uri.parse('$baseUrl/podcast/$podcastId/episodes/$id/listen'),
          headers: {"Authorization": userId!});
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  // ------------------------------ Upload Podcast ------------------------------------

  Future uploadPodcast(String title, String description, String categoryId,
      String posterUrl, String maturityRating) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');
    print(
        'calling api podcast upload : @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');

    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/podcast/add'),
      );
      if (posterUrl != '') {
        request.files.add(
          await http.MultipartFile.fromPath(
            'file',
            posterUrl,
          ),
        );
      }

      request.headers['Authorization'] = userId!;
      request.fields['category'] = categoryId;
      request.fields['title'] = title;
      request.fields['description'] = description;
      request.fields['userId'] = userId;
      request.fields['certificate'] = maturityRating;

      final response = await request.send();
      final responseString = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(responseString);

        return jsonResponse;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception(e);
    }
  }

// ------------------------------Delete Podcast ------------------------------------

  Future<bool> deletePodcast(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');
    print(
        'calling api delete podcast : @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');

    try {
      final response = await http.delete(
          Uri.parse('$baseUrl/podcast/delete/$id'),
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

  // ------------------------------Delete Episode ------------------------------------

  Future<bool> deleteEpisode(String podcastId, String episodeId) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');
    print(
        'calling api delete episode : @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');

    try {
      final response = await http.delete(
          Uri.parse('$baseUrl/podcast/$podcastId/episode/$episodeId'),
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

  // ------------------------------ Podcasts by Id ------------------------------------

  Future<List<CurrentPodcastModel>> podcastById(id) async {
    final userId = await UserSession.getUserId();
    print(
        'calling api podcasts by id : $id');
    try {
      final response = await http.get(Uri.parse('$baseUrl/podcast/id/$id'),
          headers: {"Authorization": userId!});
      if (response.statusCode == 200) {
        final jsonData = [jsonDecode(response.body)];
        final List<CurrentPodcastModel> podcasts = jsonData.map((item) {
          return CurrentPodcastModel.fromJson(item);
        }).toList();
        
        return podcasts;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  // ------------------------------ Podcasts by Id ------------------------------------

  Future podcastsByUserId(id) async {
    final userId = await UserSession.getUserId();
    print(
        'calling api podcasts by user id : @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
    try {
      final response = await http.get(Uri.parse('$baseUrl/podcast/user/$id'),
          headers: {"Authorization": userId!});
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        return jsonData;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  // ------------------------------ Follow / unfollow Podcasts  ------------------------------------

  Future podcastFollow(id) async {
    final userId = await UserSession.getUserId();
    print(
        'calling api podcasts follow/unfollow : @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
    try {
      final response = await http.get(Uri.parse('$baseUrl/podcast/follow/$id'),
          headers: {"Authorization": userId!});
      if (response.statusCode == 200) {
        final jsonData = [jsonDecode(response.body)];
        return jsonData[0]['status'];
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  // ------------------------------ Upload New Episode ------------------------------------

  Future<bool> uploadEpisode(String title, String description, String audio,
      String podcastId, String poster) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');
    print(
        'calling api new episode upload : @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');

    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/podcast/$podcastId/add-episode'),
      );
      request.headers['Authorization'] = userId!;
      request.fields['title'] = title;
      request.fields['description'] = description;
      // Add the file to the request
      request.files.add(
        await http.MultipartFile.fromPath(
          'audioUrl',
          audio,
        ),
      );

      if (poster != '') {
        request.files.add(
          await http.MultipartFile.fromPath(
            'posterUrl',
            poster,
          ),
        );
      }

      final response = await request.send();

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception(e);
    }
  }

// ------------------------------ Upload New Episode  Notication------------------------------------

  Future<void> newEpisodeNotification(
    String title, String body, String podcastId) async {
  final prefs = await SharedPreferences.getInstance();
  final userId = prefs.getString('user_id');
  print('calling api new episode notification : @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');

  final response = await http.post(
    Uri.parse('$baseUrl/podcast/send'),
    body: {
      'title': title,
      'body': body,
      'podcastId': podcastId,
    },
    headers: {
      'Authorization': userId!,
    },
  );

  // Check the response if needed
  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');
}

  // ------------------------------ update Episode ------------------------------------

  Future<bool> updateEpisode(String title, String description, String podcastId,
      String episodeId, String poster) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');
    print(podcastId + ' -- ' + episodeId);
    print(
        'calling api update episode : @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');

    try {
      final request = http.MultipartRequest(
        'PUT',
        Uri.parse('$baseUrl/podcast/$podcastId/episode/$episodeId'),
      );
      request.headers['Authorization'] = userId!;
      request.fields['title'] = title;
      request.fields['description'] = description;

      if (poster != '') {
        request.files.add(
          await http.MultipartFile.fromPath(
            'posterUrl',
            poster,
          ),
        );
      }

      final response = await request.send();

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  // ------------------------------ update Podcast ------------------------------------

  Future<bool> updatePodcast(String title, String description, String podcastId,
      String category, String poster) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');

    print(
        'calling api update podcast : @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');

    try {
      final request = http.MultipartRequest(
        'PUT',
        Uri.parse('$baseUrl/podcast/$podcastId/update'),
      );
      request.headers['Authorization'] = userId!;
      request.fields['title'] = title;
      request.fields['description'] = description;
      request.fields['category'] = category;

      if (poster != '') {
        request.files.add(
          await http.MultipartFile.fromPath(
            'posterUrl',
            poster,
          ),
        );
      }

      final response = await request.send();

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  // search
  Future<Map<String, dynamic>> search(String query,int user_page,

           int podcasts_page,

           int episodes_page ,
          ) async {
    print(
        'calling search api $query @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('user_id');
      final response = await http.get(
          Uri.parse('$baseUrl/podcast/search/?query=$query&podcasts_page=$podcasts_page'),
          headers: {"Authorization": userId!});
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data;
      } else {
        final Map<String, dynamic> error = json.decode(response.body);

        throw error['message'];
      }
    } catch (e) {
      const context = BuildContext;
      if (e is TimeoutException) {
        showSnackbar('Timeout', 'Server is too busy.Please come back again',ContentType.failure,context);
      } else if (e
          .toString()
          .contains('ClientException with SocketException')) {
        showSnackbar(
            'Network Connection Error', 'Check your Internet Connection!!!',ContentType.failure,context);
      }
      throw Exception('Error: $e');
    }
  }

  // ------------------------------ Rate Podcasts  ------------------------------------

  Future ratePodcast(id, rating) async {
    final userId = await UserSession.getUserId();
    print(
        'calling api rate podcasts  : @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
    try {
      final response = await http.put(Uri.parse('$baseUrl/podcast/$id/rate'),
          headers: {"Authorization": userId!},
          body: {'rating': rating.toString()});

      if (response.statusCode == 200) {
        final jsonData = [jsonDecode(response.body)];
        return jsonData[0]['status'];
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  // Report Podcast
  
  Future reportPodcast(id, reason,type) async {
    final userId = await UserSession.getUserId();
    print(
        'calling api report podcasts  : $id');
    try {
      final response = await http.post(Uri.parse('$baseUrl/report'),
          headers: {"Authorization": userId!},
          body: {'reason': reason,'id':id,'type':type});

      if (response.statusCode == 200) { final jsonData = [jsonDecode(response.body)];
       
        return jsonData[0]['status'] == 'success';
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
