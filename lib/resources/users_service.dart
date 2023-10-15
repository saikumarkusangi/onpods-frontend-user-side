import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:onpods/utils/exports.dart';

class UserServices {
 final userId = UserSession.getUserId();
  // ------------------------------ User By Id -------------------------------------0

  Future userById(id) async {
  
      print('calling api user by id : @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/user/info/?id=$id'),
          headers: {"Authorization":userId!}
          );
         
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

  Future userQuotes(id,page) async {
    
      print('calling api user quotes : @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/user/quotes/?id=$id&page=$page'),
          headers: {"Authorization":userId!}
          );
         
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

  Future userFollowers(id,page,title) async {
   
      print('calling api user Followers : @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/user/$title/?id=$id&page=$page'),
          headers: {"Authorization":userId!}
          );
         
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
   
      print('calling api user Followers : @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/user/follow/?userId=$id'),
          headers: {"Authorization":userId!}
          );
         
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
   
      print('calling api user Followers : @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/user/unfollow/?userId=$id'),
          headers: {"Authorization":userId!}
          );
         
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

    Future updateUser(File profilePic,String userName) async {
   
      print('calling api user update : @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
    
      try {
      final request = http.MultipartRequest(
        'PUT',
        Uri.parse('$baseUrl/user/update'),
      );
      request.headers['Authorization'] = userId!;

      // Add the file to the request
      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          profilePic.path,
        ),
      );

      // Add other form data, if needed
      request.fields['username'] = userName;

      final response = await request.send();
      final responseString = await response.stream.bytesToString();
        
         print(responseString);
    } catch (e) {
      throw Exception(e);
    }
  }



}
