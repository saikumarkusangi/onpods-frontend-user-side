import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onpods/utils/colors.dart';
import 'package:shimmer/shimmer.dart';

class ListSkeleton extends StatelessWidget {
  const ListSkeleton({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  final double? height, width;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: const Color(0xff19232F),
        highlightColor: const Color.fromARGB(255, 43, 52, 64),
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: 4,
            itemBuilder: (context, index) {
              return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Container(
                        height: 180,
                        width: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: primaryColor,
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: 20,
                          width: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: primaryColor,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: 10,
                          width: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: primaryColor,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 10,
                          width: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: primaryColor,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 10,
                          width: 120,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ]);
            }));
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

class QuotesCategoriesSkeleton extends StatelessWidget {
  const QuotesCategoriesSkeleton({super.key});
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
          height: 40,
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: 6,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Container(
                  width: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60),
                    color: Colors.white,
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                ),
              );
            },
          ),
        ));
  }
}
