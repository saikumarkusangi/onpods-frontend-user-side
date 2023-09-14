import 'package:flutter/material.dart';

import 'browse_category_card.dart';

class BrowseCategories extends StatefulWidget {
  const BrowseCategories({super.key});

  @override
  State<BrowseCategories> createState() => _BrowseCategoriesState();
}

class _BrowseCategoriesState extends State<BrowseCategories> {
  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: EdgeInsets.only( top: 10),
            child: Text(
              "Browse All",
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
              style: TextStyle(color: Colors.white, fontSize: 22),
            )),
            BrowseAllCard()
      ],
    );
  }
}
