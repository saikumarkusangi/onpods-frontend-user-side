import 'dart:convert';
import 'package:onpods/constants/constants.dart';
import 'package:onpods/models/models_exports.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserServices {

  // ------------------------------ User By Id -------------------------------------0

 static Future userById(id) async {
    final preps = await SharedPreferences.getInstance();
    final userId = preps.getString('user_id');
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

 static Future userQuotes(id,page) async {
    final preps = await SharedPreferences.getInstance();
    final userId = preps.getString('user_id');
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

 static Future userFollowers(id,page,title) async {
    final preps = await SharedPreferences.getInstance();
    final userId = preps.getString('user_id');
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

   static Future FollowUser(id) async {
    final preps = await SharedPreferences.getInstance();
    final userId = preps.getString('user_id');
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

   static Future UnFollowUser(id) async {
    final preps = await SharedPreferences.getInstance();
    final userId = preps.getString('user_id');
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



}
