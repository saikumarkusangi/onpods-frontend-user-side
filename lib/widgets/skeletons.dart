import 'package:onpods/utils/exports.dart';


// Function to create a shimmering container
Widget buildShimmerContainer({
  double? width,
  double? height,
}) {
  return Shimmer.fromColors(
    baseColor: const Color.fromARGB(255, 14, 18, 24),
    highlightColor: const Color.fromARGB(255, 44, 44, 44),
     child: Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: primaryColor,
      ),
    ),
  );
}

// Function to create a list of shimmering containers
Widget buildShimmerContainerList(int itemCount) {
  return ListView.builder(
    itemCount: itemCount,
    itemBuilder: (context, index) {
      return buildShimmerContainer(
        width: 150,
        height: 180,
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
          },
        ),
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
          },
        ),
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
          },
        ),
      ),
    );
  }
}

class QuotesCategoriesSkeleton extends StatelessWidget {
  const QuotesCategoriesSkeleton({super.key});
 
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
      ),
    );
  }
}
