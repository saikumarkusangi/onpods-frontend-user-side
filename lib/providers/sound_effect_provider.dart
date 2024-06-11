import 'package:onpods/models/sound_effect_model.dart';
import 'package:onpods/utils/exports.dart';

class SoundEffectProvider with ChangeNotifier {

   List<SoundEffectCategory> _soundEffects = [];
  List<SoundEffectCategory> get soundEffects => _soundEffects;
  List<Map<String, String>> _selectedBg = [];
  List<Map<String, String>> get selectedBg => _selectedBg;
  List<Map<String, dynamic>> _selectedSoundEffects = [];
  List<Map<String, dynamic>> get selectedSoundEffects => _selectedSoundEffects;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

 

  fetchSoundEffects() async {
    try {
      _isLoading = true;
      notifyListeners();
      _soundEffects = await BgAudioService().fetchSoundEffects();
      _isLoading = false;
    } catch (e) {
      throw Exception(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  addSelectedBg(Map<String, String> data) {
    _selectedBg.add(data);
    notifyListeners();
  }

  removeSelectedBg(Map<String, String> data) {
    _selectedBg.removeWhere((item) => item['name'] == data['name']);
    notifyListeners();
  }

  addSoundEffect(Map<String, dynamic> data) {
    _selectedSoundEffects.add(data);
    notifyListeners();
  }

  removeSoundEffect(Map<String, dynamic> data) {
    _selectedSoundEffects.removeWhere((item) => item['name'] == data['name']);
    notifyListeners();
  }
}
