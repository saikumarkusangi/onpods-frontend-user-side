import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:onpods/utils/exports.dart';

class UserServices {
  // ------------------------------ User By Id -------------------------------------0

  Future userById(id) async {
    final userId = await UserSession.getUserId();
    print('calling api user by id : @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
    try {
      final response = await http.get(Uri.parse('$baseUrl/user/info/?id=$id'),
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

// -------------------------------- delete -----------------------------------------
  Future delete() async {
    final userId = await UserSession.getUserId();
    print('calling api user delete : @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
    try {
      final response = await http.delete(Uri.parse('$baseUrl/auth/delete'),
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

  // ------------------------------ User Quotes -------------------------------------

  Future userQuotes(id, page) async {
    print('calling api user quotes : @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
    final userId = await UserSession.getUserId();
    try {
      final response = await http.get(
          Uri.parse('$baseUrl/user/quotes/?id=$id&page=$page'),
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

  // ------------------------------ User Followers -------------------------------------

  Future userFollowers(id, page, title) async {
    final userId = await UserSession.getUserId();
    print(
        'calling api user Followers : @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
    try {
      final response = await http.get(
          Uri.parse('$baseUrl/user/$title/?id=$id&page=$page'),
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

// ------------------------ Follow user -----------------------

  Future followUser(id) async {
    final userId = await UserSession.getUserId();
    print(
        'calling api user Followers : @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
    try {
      final response = await http.get(
          Uri.parse('$baseUrl/user/follow/?userId=$id'),
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

  // ------------------------ Follow user -----------------------

  Future unFollowUser(id) async {
    final userId = await UserSession.getUserId();
    print(
        'calling api user Followers : @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
    try {
      final response = await http.get(
          Uri.parse('$baseUrl/user/unfollow/?userId=$id'),
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

  // ------------------------ Update User -----------------------

  Future updateUser(String profilePic, String userName, List interests) async {
    final userId = await UserSession.getUserId();
    print('calling api user update : @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');

    try {
      final request = http.MultipartRequest(
        'PUT',
        Uri.parse('$baseUrl/user/update'),
      );
      request.headers['Authorization'] = userId!;

      // Add the file to the request
      if (profilePic.isNotEmpty) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'file',
            profilePic,
          ),
        );
      }

      if (userName != '') {
        // Add other form data, if needed
        request.fields['username'] = userName;
      }
      if (interests.isNotEmpty) {
        for (int i = 0; i < interests.length; i++) {
          String fieldName = 'interests[$i]';
          String interestValue = interests[i];
          request.fields[fieldName] = interestValue;
        }
      }

      final response = await request.send();
      final responseString = await response.stream.bytesToString();

      print(responseString);
    } catch (e) {
      throw Exception(e);
    }
  }

  // ------------------------ Update My List -----------------------
  Future updateMyList(List<String> ids, String action) async {
    final userId = await UserSession.getUserId();

    try {
      final Uri url = Uri.parse('$baseUrl/user/myList');

      final Map<String, dynamic> requestBody = {
        "action": action,
        "podcastIds": ids,
      };

      final response = await http.put(
        url,
        headers: {
          'Authorization': userId!,
          'Content-Type': 'application/json',
        },
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data;
      } else {
        throw Exception('Failed to load myList');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

// ------------------------ Fetch MyList -----------------------

  Future fetchMyList() async {
    final userId = await UserSession.getUserId();
    print('calling api user my list : @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');

    try {
      final request = http.MultipartRequest(
        'GET',
        Uri.parse('$baseUrl/user/myList'),
      );
      request.headers['Authorization'] = userId!;

      final response = await request.send();
      final responseString = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        final data = json.decode(responseString);
        return data;
      } else {
        throw Exception('Failed to load myList');
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
