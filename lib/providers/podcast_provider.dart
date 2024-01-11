import 'package:flutter/foundation.dart';
import 'package:onpods/models/banner_model.dart';
import 'package:onpods/models/podcast_model.dart';
import 'package:onpods/models/podcast_category_model.dart';
import 'package:onpods/models/current_podcast_model.dart';
import 'package:onpods/utils/exports.dart';

class PodcastProvider with ChangeNotifier {
  List<PodcastCategoryModel> _podcastCategories = [];
  List<PodcastCategoryModel> get podcastCategories => _podcastCategories;

  Map<String,dynamic> _searchData = {};
  Map<String,dynamic> get searchData => _searchData;

  List<PodcastCategoryModel> _allpodcastCategories = [];
  List<PodcastCategoryModel> get allpodcastCategories => _allpodcastCategories;

  List<PodcastModel> _podcasts = [];
  List<PodcastModel> get podcasts => _podcasts;

  List<BannerModel> _suggestpodcasts = [];
  List<BannerModel> get suggestpodcasts => _suggestpodcasts;

  List<PodcastModel> _trendingPodcasts = [];
  List<PodcastModel> get trendingPodcasts => _trendingPodcasts;

  List<CurrentPodcastModel> _currentPodcast = [];
  List<CurrentPodcastModel> get currentPodcast => _currentPodcast;

  bool _isLoading = false;
  String _categoryId = '';
  String get categoryId => _categoryId;
  bool get isLoading => _isLoading;

  Future<void> fetchCategories() async {
    try {
      notifyListeners();
      _podcastCategories = await PodcastService().categories();
      notifyListeners();
    } catch (e) {
      throw Exception(e);
    }
  }

   Future<void> fetchSuggestPodcasts() async {
    try {
      _suggestpodcasts = await PodcastService().suggestPodcasts();
      notifyListeners();
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> fetchAllCategories() async {
    try {

      _allpodcastCategories = await PodcastService().allcategories();
      notifyListeners();
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> fetchPodcastsByCategory(String categoryId, int page) async {
    try {
_isLoading = true;
      notifyListeners();
      final podcastsData =
          await PodcastService().podcastByCategory(categoryId, page);

      if (_podcasts.isNotEmpty && _categoryId == categoryId) {
        if (_podcasts[0].data!.isNotEmpty &&
            _categoryId == categoryId &&
            podcastsData[0].page != _podcasts[0].page) {
          _podcasts[0].data!.addAll(podcastsData[0].data!);
          _podcasts[0].page = podcastsData[0].page;
          _podcasts[0].totalPages = podcastsData[0].totalPages;
        }
      } else {
        _podcasts = podcastsData;
        _categoryId = categoryId;
        notifyListeners();
      }
    } catch (e) {
      throw Exception(e);
    }finally{
      _isLoading = true;
      notifyListeners();
    }
  }

  Future<void> fetchTrendingPodcasts() async {
    try {

      _trendingPodcasts = await PodcastService().trendingPodcasts();

    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> fetchPodcastsById(String podcastId) async {
    _currentPodcast = [];
    notifyListeners();
    try {


      _currentPodcast = await PodcastService().podcastById(podcastId);
      notifyListeners();
    } catch (e) {
      throw Exception(e);
    }
  }

  setCategory() {
    _categoryId = '';
    notifyListeners();
  }


  Future<void> search(query,userpage,podcastpage,episodepage) async {
    try {

      _searchData = await PodcastService().search(query,1,1,1);
      notifyListeners();
    } catch (e) {
      throw Exception(e);
    }
  }
}
