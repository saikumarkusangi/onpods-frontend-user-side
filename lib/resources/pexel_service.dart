import 'package:http/http.dart' as http;
import 'package:onpods/constants/constants.dart';

class PixelService {
  Future searchBg(String query, int page) async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://api.pexels.com/v1/search/?page=$page&per_page=14&query=$query'),
        headers: {'Authorization': pixelApiKey},
      );

      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('An error occurred while making the request: $e');
    }
  }
}
