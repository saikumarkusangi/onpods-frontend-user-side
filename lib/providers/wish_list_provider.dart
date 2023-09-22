import 'package:flutter/foundation.dart';

class PodcastItem {
  final String title;
  final String posterUrl;

  PodcastItem({required this.title, required this.posterUrl});
}

class WishlistProvider extends ChangeNotifier {
  List<PodcastItem> _wishlist = [];

  List<PodcastItem> get wishlist => _wishlist;

  void addToWishlist(String podcastTitle, String posterUrl) {
    if (!_wishlist.any((item) => item.title == podcastTitle)) {
      final newItem = PodcastItem(title: podcastTitle, posterUrl: posterUrl);
      _wishlist.add(newItem);
      notifyListeners(); // Notify listeners when the wishlist changes
    }
  }

  void removeFromWishlist(String podcastTitle) {
    _wishlist.removeWhere((item) => item.title == podcastTitle);
    notifyListeners(); // Notify listeners when the wishlist changes
  }
}
