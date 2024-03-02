

import 'package:onpods/utils/exports.dart';

class ChipItemWidget extends StatelessWidget {
  final String text;
  const ChipItemWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        canvasColor: Colors.transparent,
      ),
      child: RawChip(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
        showCheckmark: false,
        labelPadding: EdgeInsets.zero,
        label: Text(
          text,
          textAlign: TextAlign.left,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        selected: false,
        backgroundColor: Colors.transparent,
        selectedColor: blueColor,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.grey, width: 0.4),
          borderRadius: BorderRadius.circular(20),
        ),
        onSelected: (value) {},
      ),
    );
  }
}
