import 'package:onpods/models/quotes_model.dart';
import 'package:onpods/utils/exports.dart';

class QuoteProvider with ChangeNotifier {
  List<QuotesCategoryModel> _quotesCategories = [];
  List<QuotesCategoryModel> get quotesCategories => _quotesCategories;

  List<QuotesModel> _quotes = [];
  List<QuotesModel> get quotes => _quotes;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchCategories() async {
    try {
      _isLoading = true;
      notifyListeners();
      _quotesCategories = await QuoteService().categories();
    } catch (e) {
      throw Exception(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchQuotesByCategory(String categoryId, int page) async {
    try {
      final existingIndex = _quotes.indexWhere(
        (element) => element.datas.any((e) => e.category == categoryId),
      );

      if (existingIndex == -1) {
        _isLoading = true;
        notifyListeners();
      }

      final data = await QuoteService().quotesByCategory(categoryId, page);

      if (existingIndex != -1) {
        final existingQuotes = _quotes[existingIndex];
        if (page == 1 && existingQuotes.page != 1) {
          final Set<String> existingIds =
              existingQuotes.datas.map((e) => e.id).toSet();
          final newData = data[0]
              .datas
              .where((newItem) => !existingIds.contains(newItem.id))
              .toList();
          existingQuotes.datas
              .insertAll(0, newData); // Add new data before existing data.
        } else if (existingQuotes.page != data[0].page) {
          if (data[0].page > 1) {
            existingQuotes.page = data[0].page;
          }
          existingQuotes.datas.addAll(data[0].datas);
        }
        existingQuotes.count = data[0].count;
        existingQuotes.totalPages = data[0].totalPages;
      } else {
        if (data[0].count > 0) {
          _quotes.add(data[0]);
        }
      }
    } catch (e) {
      throw Exception(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
