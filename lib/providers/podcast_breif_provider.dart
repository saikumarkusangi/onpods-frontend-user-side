import 'package:onpods/models/podcast_brief_model.dart';
import 'package:onpods/models/podcast_category_model.dart';
import 'package:onpods/models/podcast_model.dart';
import 'package:onpods/utils/exports.dart';

class PodcastProvider with ChangeNotifier {
  List<PodcastCategoryModel> _podcastCategories = [];
  List<PodcastCategoryModel> get podcastCategories => _podcastCategories;

  List<PodcastBriefModel> _podcasts = [];
  List<PodcastBriefModel> get podcasts => _podcasts;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchCategories() async {
    try {
      _isLoading = true;
      notifyListeners();
      _podcastCategories = await PodcastService().categories();
    } catch (e) {
      throw Exception(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchPodcastsByCategory(String categoryId, int page) async {
    try {
      _isLoading = true;
      notifyListeners();

      _podcasts = await PodcastService().podcastByCategory(categoryId, page);
      notifyListeners();
    } catch (e) {
      throw Exception(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
