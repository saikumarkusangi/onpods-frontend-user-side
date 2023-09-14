import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onpods/utils/colors.dart';
import 'package:shimmer/shimmer.dart';

class HomeSkeleton extends StatelessWidget {
  const HomeSkeleton({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  final double? height, width;

  static final Widget _container = Padding(
    padding: const EdgeInsets.only(top: 10),
    child: Container(
      width: 0.28.sw,
      height: 0.18.sh,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: primaryColor,
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xff19232F),
      highlightColor: const Color.fromARGB(255, 43, 52, 64),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(3, (index) => _container),
          ),
          // Padding(
          //   padding: const EdgeInsets.only(top: 14),
          //   child: ListView.builder(
          //     shrinkWrap: true,
          //     itemCount: 4,
          //     itemBuilder: (context, index) => _listTile,
          //   ),
          // ),
        ],
      ),
    );
  }
}

class RecommendationSkeleton extends StatelessWidget {
  const RecommendationSkeleton({super.key});
  static final Widget _container = Padding(
    padding: const EdgeInsets.only(top: 10),
    child: Column(
      children: [
        Container(
          width: 0.5.sw,
          height: 0.12.sh,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: primaryColor,
          ),
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xff19232F),
      highlightColor: const Color.fromARGB(255, 43, 52, 64),
      child: SizedBox(
        height: 120,
        child: ListView.builder(
            itemCount: 2,
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(left: 15),
                child: _container,
              );
            }),
      ),
    );
  }
}



class OurPodcastsSkeleton extends StatelessWidget {
  const OurPodcastsSkeleton({super.key});
  static final Widget _container = Padding(
    padding: const EdgeInsets.only(top: 10),
    child: Column(
      children: [
        Container(
          width: 0.6.sw,
          height: 0.16.sh,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: primaryColor,
          ),
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xff19232F),
      highlightColor: const Color.fromARGB(255, 43, 52, 64),
      child: SizedBox(
        height: 140,
        child: ListView.builder(
            itemCount: 2,
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: _container,
              );
            }),
      ),
    );
  }
}


class QuotesSkeleton extends StatelessWidget {
  const QuotesSkeleton({super.key});
  static final Widget _container = Padding(
    padding: const EdgeInsets.only(top: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 0.46.sw,
          height: 0.2.sh,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: primaryColor,
          ),
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xff19232F),
      highlightColor: const Color.fromARGB(255, 43, 52, 64),
      child: SizedBox(
        height: 180,
        child: ListView.builder(
            itemCount: 2,
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(left: 15),
                child: _container,
              );
            }),
      ),
    );
  }
}
