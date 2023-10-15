import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:onpods/utils/exports.dart';

  // --------------------------------- Create New Chat Room--------------------------------------------------

  Future<Map<String, dynamic>> createRoom(chatTopic, roomType, ownerId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/chat-room/create'),
        body: {
          "chatTopic": chatTopic,
          "roomType": roomType,
          "ownerId": ownerId
        },
      ).timeout(const Duration(seconds: 30));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        showSnackbar('Successful', 'Room Created Successfully!');
        // All(const Layout(), transition: Transition.leftToRight);
        return data;
      } else {
        final Map<String, dynamic> error = json.decode(response.body);
        showSnackbar('Something Went Wrong', error['message']);
        throw Exception('Request failed with status code: ${error['message']}');
      }
    } catch (e) {
      if (e is TimeoutException) {
        showSnackbar('Timeout', 'Server is too busy.Please come back again');
      } else {
        // Handle other exceptions
        showSnackbar('Error', 'An error occurred: $e');
      }
      throw Exception('Error: $e');
    }
  }

