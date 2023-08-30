import 'package:flutter/material.dart';
import 'package:onpods/utils/colors.dart';
import 'package:shimmer/shimmer.dart';

class ChatRoomListkeleton extends StatelessWidget {
  const ChatRoomListkeleton({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  final double? height, width;

  static final Widget _container = Padding(
     padding: const EdgeInsets.only(bottom: 14),
    child: Container(
      height: 180,
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
        child: ListView.builder(
          itemCount: 5,
          itemBuilder: (context, index) {
            return _container;
          },
        ));
  }
}
