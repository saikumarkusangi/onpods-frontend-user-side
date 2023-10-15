import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:onpods/models/dummy_data.dart';

class DummyService {
  
  Future<List<DummyDataModel>> fetch() async {
    try {
      final response = await http.get(
          Uri.parse('https://64f9840c4098a7f2fc148953.mockapi.io/podcasts'));
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final List<DummyDataModel> dummyData = (jsonData as List)
            .map((item) => DummyDataModel.fromJson(item))
            .toList();
        print('calling api : @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
        return dummyData;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
