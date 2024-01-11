
import 'package:onpods/utils/exports.dart';

class EmptyPlaceHolder extends StatelessWidget {
  final String message;
  const EmptyPlaceHolder({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [

        Image.asset(emptyImage, scale: 4),
        const Text(
          'Nothing to show',
          style: TextStyle(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}
