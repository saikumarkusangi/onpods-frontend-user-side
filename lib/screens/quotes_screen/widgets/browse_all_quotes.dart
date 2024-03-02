

// import 'package:onpods/screens/quotes_screen/single_category_quote.dart';
// import 'package:onpods/utils/exports.dart';

// class BrowseAllQuotes extends StatefulWidget {
//   const BrowseAllQuotes({super.key});

//   @override
//   State<BrowseAllQuotes> createState() => _BrowseAllQuotesState();
// }

// class _BrowseAllQuotesState extends State<BrowseAllQuotes> {
//   @override
//   void initState() {
//     super.initState();
//     final quoteCategoryProvider =
//         Provider.of<QuoteProvider>(context, listen: false);
//     quoteCategoryProvider.fetchCategories();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final quoteCategoryProvider = Provider.of<QuoteProvider>(context);

//     if (quoteCategoryProvider.isLoading) {
//       return const QuotesCategoriesSkeleton();
//     } else if (quoteCategoryProvider.quotesCategories.isEmpty) {
//       return const SizedBox();
//     } else {
//       return SizedBox(
//         height: 40,
//         width: double.maxFinite,
//         child: ListView.builder(
//           shrinkWrap: true,
//           scrollDirection: Axis.horizontal,
//           itemCount: quoteCategoryProvider.quotesCategories.length,
//           itemBuilder: (context, index) {
//             final category = quoteCategoryProvider.quotesCategories[index];
//             return Padding(
//               padding: const EdgeInsets.only(left: 10),
//               child: GestureDetector(
//                 onTap: () => Get.to(
//                     SingleCategoryQuote(
//                       title: quoteCategoryProvider.quotesCategories[index].name,
//                     ),
//                     transition: Transition.rightToLeftWithFade),
//                 child: Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(60),
//                     color: Colors.white,
//                   ),
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//                   child: Center(
//                     child: Text(
//                       category.name,
//                       style: const TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w600,
//                         color: Colors.black,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//       );
//     }
//   }
// }
