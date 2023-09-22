import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:onpods/utils/colors.dart';
import 'package:onpods/utils/images.dart';

import '../screens/screens_exports.dart';

class NoConnection extends StatelessWidget {
  const NoConnection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 30,
              ),
              Center(
                child: SvgPicture.asset(
                  connectionErrorImage,
                  fit: BoxFit.contain,
                  width: MediaQuery.of(context).size.width * 0.8,
                ),
              ),
              const Text(
                'No Connection',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  letterSpacing: 1,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'Please check your internet connection\nand try again.',
                style: TextStyle(
                  color: Colors.grey.shade300,
                  fontSize: 16,
                  letterSpacing: 1,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 40,
              ),
              GestureDetector(
                onTap: () =>Get.to(const DownloadsPage(),transition: Transition.cupertino),
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width / 2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: blueColor,
                  ),
                  child: const Center(
                      child: Text(
                    "Downloads",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
