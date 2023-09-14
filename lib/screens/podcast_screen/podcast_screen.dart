import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onpods/screens/podcast_screen/record_podcast_onboarding.dart';
import 'package:onpods/screens/podcast_screen/widgets/continue_listening.dart';
import 'package:onpods/screens/podcast_screen/widgets/every_one_watching.dart';

import '../../utils/utils_exports.dart';
import '../../widgets/custom_text_field.dart';
import 'widgets/browse_categories.dart';

class PodcastScreen extends StatefulWidget {
  const PodcastScreen({super.key});

  @override
  State<PodcastScreen> createState() => _PodcastScreenState();
}

class _PodcastScreenState extends State<PodcastScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leadingWidth: 120,
          backgroundColor: scaffoldBackgroundColor,
          leading: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Image.asset(appBarLogo),
          ),
          bottom: const PreferredSize(
              preferredSize: Size(0, 60),
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14),
                  child: Column(children: [
                    CustomTextFormField(
                      autofocus: false,
                      radius: 10,
                      prefix: Icon(
                        Icons.search_rounded,
                        color: Colors.grey,
                        size: 26,
                      ),
                      hintText: "Search author,category & more...",
                      vertical: 16,
                      fillColor: textFieldColor,
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                      textStyle: TextStyle(color: Colors.white),
                    ),
                  ])))),
      floatingActionButton: FloatingActionButton(
          elevation: 10,
          isExtended: false,
          backgroundColor: Colors.blue,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
          onPressed: () =>
              Get.to(const RecordPodcastBoarding(), transition: Transition.fade),
          child: const Icon(
            Icons.add,
            size: 28,
            color: Colors.white,
          )),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 18, right: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              ContinueListening(),
              EveryOneWatching(),
              BrowseCategories()
            ],
          ),
        ),
      ),
    );
  }
}
