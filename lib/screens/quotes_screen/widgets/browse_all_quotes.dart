import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onpods/screens/podcast_screen/widgets/list_skeleton.dart';
import 'package:onpods/screens/quotes_screen/single_category_quote.dart';
import 'package:onpods/utils/colors.dart';
import 'package:provider/provider.dart';

import '../../../providers/providers_exports.dart';

class BrowseAllQuotes extends StatefulWidget {
  const BrowseAllQuotes({super.key});

  @override
  State<BrowseAllQuotes> createState() => _BrowseAllQuotesState();
}

class _BrowseAllQuotesState extends State<BrowseAllQuotes> {
  @override
  void initState() {
    super.initState();
    final quoteCategoryProvider =
        Provider.of<QuoteProvider>(context, listen: false);
    quoteCategoryProvider.fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    final quoteCategoryProvider =
        Provider.of<QuoteProvider>(context);

    if (quoteCategoryProvider.isLoading) {
      return const QuotesCategoriesSkeleton();
    } else if (quoteCategoryProvider.quotesCategories.isEmpty) {
      return Center(
        child: Image.network(
          'https://cdni.iconscout.com/illustration/premium/thumb/empty-box-4344460-3613888.png',
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(15),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: quoteCategoryProvider.quotesCategories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 16 / 11,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            crossAxisCount: 2,
          ),
          itemBuilder: (context, index) {
            final category = quoteCategoryProvider.quotesCategories[index];
            return GestureDetector(
              onTap: ()=>Get.to(SingleCategoryQuote(
                title: quoteCategoryProvider.quotesCategories[index].name,
                image: quoteCategoryProvider.quotesCategories[index].imageUrl,
              ),
              transition: Transition.rightToLeftWithFade),
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(category.imageUrl),
                    fit: BoxFit.cover,
                  ),
                  color: textFieldColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Stack(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black45,
                            Colors.black45,
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        category.name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    }
  }
}
