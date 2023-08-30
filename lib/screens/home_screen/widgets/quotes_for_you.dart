import 'package:flutter/material.dart';
import 'package:onpods/screens/home_screen/widgets/home_skeleton.dart';

class QuotesForYou extends StatefulWidget {
  const QuotesForYou({super.key});

  @override
  State<QuotesForYou> createState() => _QuotesForYouState();
}

class _QuotesForYouState extends State<QuotesForYou> {
  @override
  Widget build(BuildContext context) {
    return const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quotes for you',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22
            ),
        ),
        QuotesSkeleton()
      ],
    );
  }
}
