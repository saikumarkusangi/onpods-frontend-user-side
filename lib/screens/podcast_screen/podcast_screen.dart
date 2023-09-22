import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onpods/screens/podcast_screen/record_podcast_onboarding.dart';
import 'package:onpods/screens/podcast_screen/widgets/continue_listening.dart';
import 'package:onpods/screens/podcast_screen/widgets/podcast_card_template.dart';
import 'package:onpods/widgets/widgets_exports.dart';
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
          toolbarHeight: 80,
          backgroundColor: Colors.black,
          flexibleSpace: const Padding(
              padding: EdgeInsets.only(top: 50, left: 10, right: 10),
              child: CustomTextFormField(
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
              ))),
      floatingActionButton: const CustomFAB(toPage: RecordPodcastBoarding()),
      body: const SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            ContinueListening(),
            PodcastCardTemplate(categoryTitle: 'Recommanded For You'),
            BrowseCategories()
          ],
        ),
      ),
    );
  }
}
