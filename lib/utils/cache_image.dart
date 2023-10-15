import 'package:onpods/utils/exports.dart';

class CacheImage extends StatelessWidget {
  final String image;
  const CacheImage({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
        imageUrl: image,
        fit: BoxFit.cover,
        placeholder: (context, url) => Shimmer.fromColors(
              baseColor: const Color(0xff19232F),
              highlightColor: const Color.fromARGB(255, 43, 52, 64),
              child: Container(
                width: 0.46.sw,
                height: 0.2.sh,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey,
                ),
              ),
            ),
        errorWidget: (context, url, error) => Image.network(
            'https://www.publictransport.com.mt/images/failed-to-load-prview-placeholder.jpg'));
  }
}
