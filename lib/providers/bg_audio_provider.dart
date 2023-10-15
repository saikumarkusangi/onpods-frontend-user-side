import 'package:onpods/utils/exports.dart';

class BgAudioProvider with ChangeNotifier {
  List<BgModel> _bgCategories = [];
  List<BgModel> get bgCategories => _bgCategories;
  List<Map<String, String>> _selectedBg = [];
  List<Map<String, String>> get selectedBg => _selectedBg;
  List<Map<String, dynamic>> _selectedSoundEffects = [];
  List<Map<String, dynamic>> get selectedSoundEffects => _selectedSoundEffects;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  fetchCategories() async {
    try {
      _isLoading = true;
      notifyListeners();
      _bgCategories = await BgAudioService().fetch();
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
