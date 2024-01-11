import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:onpods/utils/colors.dart';
import 'package:shimmer/shimmer.dart';

class HomeSkeleton extends StatelessWidget {
  const HomeSkeleton({
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
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: double.maxFinite,
            height: 250,
            child: ListView.builder(
              itemCount: 3,
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 0.4.sw,
                        height: 160,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: 0.4.sw,
                      height: 20,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey,
                      ),
                    ),
                  ],
                );
              },
            ),
          )),
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
            color: Colors.grey,
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

class ProfileQuotesSkeleton extends StatelessWidget {
  const ProfileQuotesSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Shimmer.fromColors(
          baseColor: const Color(0xff19232F),
          highlightColor: const Color.fromARGB(255, 43, 52, 64),
          child: SizedBox(
            width: 1.sw,
            height: 0.6.sh,
            child: GridView.builder(
              shrinkWrap: true,
              itemCount: 9,
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                itemBuilder: ((context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(6),
                    child: Container(
                      width: 0.42.sw,
                      height: 0.2.sh,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey,
                      ),
                    ),
                  );
                })),
          )),
    );
  }
}

class ProfileSkeleton extends StatelessWidget {
  const ProfileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: const Color(0xff19232F),
        highlightColor: const Color.fromARGB(255, 43, 52, 64),
        child: Column(children: [
          const SizedBox(height: 80),
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(60),
              color: Colors.grey,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            width: 200,
            height: 20,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            width: 100,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(60),
              color: Colors.grey,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
              padding: const EdgeInsets.only(
                  left: 50, right: 50, top: 10, bottom: 10),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                width: double.maxFinite,
                height: 100,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10), color: blueColor),
              )),
        ]));
  }
}

Widget buildShimmerContainer({
  double? width,
  double? height,
}) {
  return Shimmer.fromColors(
    baseColor: const Color(0xff19232F),
    highlightColor: const Color.fromARGB(255, 43, 52, 64),
    child: Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey,
      ),
    ),
  );
}

// Function to create a list of shimmering containers
Widget buildShimmerContainerList(int itemCount) {
  return ListView.builder(
    itemCount: itemCount,
    shrinkWrap: true,
    itemBuilder: (context, index) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: buildShimmerContainer(
              width: 150,
              height: 180,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: buildShimmerContainer(
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: 15,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: buildShimmerContainer(
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: 10,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: buildShimmerContainer(
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: 10,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: buildShimmerContainer(
                  width: MediaQuery.of(context).size.width * 0.2,
                  height: 10,
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
}

class ListSkeleton extends StatelessWidget {
  const ListSkeleton({Key? key, this.width, this.height}) : super(key: key);

  final double? height, width;

  @override
  Widget build(BuildContext context) {
    return buildShimmerContainerList(4);
  }
}

class QuotesCategorySkeleton extends StatelessWidget {
  const QuotesCategorySkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xff19232F),
      highlightColor: const Color.fromARGB(255, 43, 52, 64),
      child: SizedBox(
        height: 30,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 4,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Container(
                  width: 100,
                  height: 10,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey,
                  ),
                ),
              );
            }),
      ),
    );
  }
}

class QuotesSkeleton extends StatelessWidget {
  const QuotesSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: const Color(0xff19232F),
        highlightColor: const Color.fromARGB(255, 43, 52, 64),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: StaggeredGrid.count(
            crossAxisCount: 2,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 300,
                  height: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: 160,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

class PodcastCategoriesSkeleton extends StatelessWidget {
  const PodcastCategoriesSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: const Color(0xff19232F),
        highlightColor: const Color.fromARGB(255, 43, 52, 64),
        child: SizedBox(
          height: 1.sh,
          width: 1.sw,
          child: GridView.builder(
            shrinkWrap: true,
            itemCount: 8,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, childAspectRatio: 1.4),
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.all(6),
              child: Container(
                width: 300,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        ));
  }
}
