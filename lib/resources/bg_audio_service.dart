import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:onpods/models/sound_effect_model.dart';
import 'package:onpods/utils/exports.dart';

class BgAudioService {
  Future<List<BgModel>> fetch() async {
    final preps = await SharedPreferences.getInstance();
    final userId = preps.getString('user_id');
    try {
      final response = await http.get(Uri.parse('$baseUrl/background-audio'),
          headers: {"Authorization": userId!});

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        final List<BgModel> categories =
            (jsonData as List).map((item) => BgModel.fromJson(item)).toList();
        print(
            'calling api bg audio categories : @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
        return categories;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

   Future<List<SoundEffectCategory>> fetchSoundEffects() async {
    final preps = await SharedPreferences.getInstance();
    final userId = preps.getString('user_id');
    try {
      final response = await http.get(Uri.parse('$baseUrl/sound-effects'),
          headers: {"Authorization": userId!});

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
 
        final List<SoundEffectCategory> categories =
            (jsonData as List).map((item) => SoundEffectCategory.fromJson(item)).toList();
        print(
            'calling api sound effect categories : @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
         
        return categories;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
