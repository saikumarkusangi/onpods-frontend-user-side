import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onpods/utils/colors.dart';
import 'package:onpods/utils/utils_exports.dart';

class CustomFAB extends StatelessWidget {
  final dynamic toPage;
  const CustomFAB({super.key, this.toPage});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        elevation: 10,
        isExtended: false,
        backgroundColor: blueColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        onPressed: () => Get.to(toPage, transition: Transition.fade),
        child: const Icon(
          Icons.add,
          size: 28,
          color: Colors.white,
        ));
  }
}
