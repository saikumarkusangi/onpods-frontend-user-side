
import 'package:onpods/utils/exports.dart';

class EmptyPlaceHiolder extends StatelessWidget {
  final String message;
  const EmptyPlaceHiolder({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          height: 30,
        ),
        Image.asset(emptyImage, scale: 2.5),
        Text(
          'No $message Yet',
          style: const TextStyle(
              color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}
