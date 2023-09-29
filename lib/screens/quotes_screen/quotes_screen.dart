import 'package:flutter/material.dart';
import 'package:onpods/providers/providers_exports.dart';
import 'package:onpods/screens/quotes_screen/create_quote.dart';
import 'package:onpods/screens/quotes_screen/widgets/browse_all_quotes.dart';
import 'package:onpods/screens/quotes_screen/widgets/quote_card_template.dart';
import 'package:provider/provider.dart';
import '../../utils/utils_exports.dart';
import '../../widgets/widgets_exports.dart';

class QuotesScreen extends StatefulWidget {
  const QuotesScreen({super.key});
  @override
  State<QuotesScreen> createState() => _QuotesScreenState();
}

class _QuotesScreenState extends State<QuotesScreen> {
  // @override
  // void initState() {
  //   super.initState();
  //   fetchData();
  // }

  // Future<void> fetchData() async {
  //   final quoteProvider = Provider.of<QuoteProvider>(context, listen: false);
  //   await quoteProvider.fetchCategories();
  // }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.black,
          flexibleSpace: const Padding(
            padding: EdgeInsets.only(top: 60),
            child: BrowseAllQuotes(),
          ),
        ),
        body: const SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                QuoteCardTemplate(
                  categoryTitle: 'Popular Quotes',
                ),
                SizedBox(
                  height: 10,
                ),
                QuoteCardTemplate(
                  categoryTitle: 'You May Like',
                ),
              ],
            ),
          ),
        ));
  }
}
