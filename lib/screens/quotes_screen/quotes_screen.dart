import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onpods/models/models_exports.dart';
import 'package:onpods/providers/providers_exports.dart';
import 'package:onpods/screens/quotes_screen/create_quote.dart';
import 'package:onpods/screens/quotes_screen/widgets/browse_all_quotes.dart';
import 'package:onpods/screens/quotes_screen/widgets/popular_quotes.dart';
import 'package:onpods/screens/quotes_screen/widgets/quote_of_the_day.dart';
import 'package:provider/provider.dart';
import '../../utils/utils_exports.dart';
import '../../widgets/widgets_exports.dart';

class QuotesScreen extends StatefulWidget {
  const QuotesScreen({super.key});
  @override
  State<QuotesScreen> createState() => _QuotesScreenState();
}

class _QuotesScreenState extends State<QuotesScreen> {
  @override
  // void initState() {
  //   super.initState();
  //   fetchData();
  // }

  // Future<void> fetchData() async {
  //   final quoteProvider = Provider.of<QuoteProvider>(context, listen: false);
  //   await quoteProvider.fetchCategories();
  // }

  Widget build(BuildContext context) {
    final quoteProvider = Provider.of<QuoteProvider>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
            leadingWidth: 120,
            backgroundColor: scaffoldBackgroundColor,
            leading: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Image.asset(appBarLogo),
            ),
            bottom: const PreferredSize(
                preferredSize: Size(0, 70),
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14),
                    child: Column(children: [
                      CustomTextFormField(
                        autofocus: false,
                        radius: 10,
                        prefix: Icon(
                          Icons.search_rounded,
                          color: Colors.grey,
                          size: 26,
                        ),
                        hintText: "Search category,name & more...",
                        vertical: 16,
                        fillColor: textFieldColor,
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                        textStyle: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        height: 10,
                      )
                    ])))),
        floatingActionButton: FloatingActionButton(
            elevation: 10,
            isExtended: false,
            backgroundColor: Colors.blue,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
            onPressed: () =>
                Get.to(const CreateQuote(), transition: Transition.rightToLeft),
            child: const Icon(
              Icons.add,
              size: 28,
              color: Colors.white,
            )),
        body: RefreshIndicator(
          onRefresh: () async {
            quoteProvider.fetchCategories();
          },
          child: const SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                QuoteOfTheDay(),
                SizedBox(
                  height: 10,
                ),
                PopularQuotes(),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: Text(
                    "Browse All",
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: TextStyle(color: Colors.white, fontSize: 22),
                  ),
                ),
                BrowseAllQuotes(),
              ],
            ),
          ),
        ));
  }
}
