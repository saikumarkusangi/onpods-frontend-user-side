import 'package:flutter/material.dart';
import 'package:onpods/models/models_exports.dart';
import 'package:onpods/providers/providers_exports.dart';
import 'package:onpods/screens/quotes_screen/widgets/quote_card_template.dart';
import 'package:provider/provider.dart';
import '../../utils/utils_exports.dart';
import '../../widgets/widgets_exports.dart';

class QuotesScreen extends StatefulWidget {
  const QuotesScreen({super.key});
  @override
  State<QuotesScreen> createState() => _QuotesScreenState();
}

class _QuotesScreenState extends State<QuotesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    fetchCategoriesAndQuotes();
  }

  fetchCategoriesAndQuotes() async {
    final quoteProvider = Provider.of<QuoteProvider>(context, listen: false);
    await quoteProvider.fetchCategories();
    _tabController = TabController(
      length: quoteProvider.quotesCategories.length,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    final quoteCategoryProvider = Provider.of<QuoteProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        bottom:
        quoteCategoryProvider.isLoading ?
        const PreferredSize(
           preferredSize: Size(0, 0),
          child: QuotesCategorySkeleton()):
         PreferredSize(
          preferredSize: const Size(0, 0),
          child: TabBar(
            controller: _tabController,
            indicatorColor: blueColor,
            dividerColor: Colors.transparent,
            unselectedLabelColor: Colors.white,
            indicatorWeight: 5,
            indicatorPadding: const EdgeInsets.only(top: 10),
            labelColor: Colors.white,
            isScrollable: true,
            tabs: List.generate(quoteCategoryProvider.quotesCategories.length,
                (index) {
              return Text(
                quoteCategoryProvider.quotesCategories[index].name,
                style: const TextStyle(fontSize: 20),
              );
            }),
          ),
        ),
      ),
      body:  quoteCategoryProvider.isLoading ?
      const QuotesSkeleton():
       TabBarView(
        controller: _tabController,
        children: List.generate(
          quoteCategoryProvider.quotesCategories.length,
          (index) {
            final categoryId = quoteCategoryProvider.quotesCategories[index].id;
            return RefreshIndicator(
                onRefresh: () async {
                 await quoteCategoryProvider.fetchQuotesByCategory(categoryId,1);
                },
                child: StaggeredGridTemplate(categoryId: categoryId));
          },
        ),
      ),
    );
  }
}
