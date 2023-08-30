import 'package:flutter/material.dart';
import 'package:onpods/screens/home_screen/widgets/home_skeleton.dart';

class Recommendation extends StatefulWidget {
  const Recommendation({super.key});

  @override
  State<Recommendation> createState() => _RecommendationState();
}

class _RecommendationState extends State<Recommendation> {
  @override
  Widget build(BuildContext context) {
    return  const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recommendation',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22
            ),
        ),
        RecommendationSkeleton()
      ],
    );
  }
}