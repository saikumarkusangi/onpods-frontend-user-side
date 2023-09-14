import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:onpods/screens/layout_screen.dart';
import 'package:onpods/widgets/widgets_exports.dart';
import '../../utils/utils_exports.dart';
import 'widget/chip_item_widget.dart';

class ChooseYourInterestScreen extends StatelessWidget {
  const ChooseYourInterestScreen({super.key});
  static final List<String> data = [
    "Biography",
    "Self-Help",
    "Science",
    "Mental Health",
    "Science Fiction",
    "Fantasy",
    "Coding",
    "Politics",
    "Culture",
    "Horror",
    "News","Technology",
    "Society",
    "General Knowledge",
    "Entertainment",
    "Education",
    "Current Affairs",
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          backgroundColor: scaffoldBackgroundColor,
          toolbarHeight: 100,
          title: const Column(children: [
            Text(
              "What are your interests.",
              style: TextStyle(color: Colors.white, fontSize: 26),
            ),
            SizedBox(height: 10),
            Text(
              'Pick 4 categories of your choice',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ]),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 0.6.sh,
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10, 
                  children: data.map((item) {
                    return ChipItemWidget(text: item);
                  }).toList(),
                ),
              ),
              const Spacer(),
              Container(
                color: scaffoldBackgroundColor,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomElevatedButton(
                        height: 38,
                        text: "Continue",
                        onTap: () => onTapContinue(context),
                      ),
                      const SizedBox(height: 18),
                      CustomElevatedButton(
                        height: 38,
                        buttonStyle: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color?>(
                            (Set<MaterialState> states) => Colors.transparent,
                          ),
                        ),
                        text: "Skip",
                        onTap: () => onTapSkip(context),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onTapSkip(BuildContext context) {
    Get.off(const Layout(), transition: Transition.rightToLeft);
  }

  void onTapContinue(BuildContext context) {
    Get.off(const Layout(), transition: Transition.rightToLeft);
  }
}
