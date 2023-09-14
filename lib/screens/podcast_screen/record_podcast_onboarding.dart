import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:onpods/screens/podcast_screen/custom_audio_player.dart';
import 'package:onpods/screens/podcast_screen/record_podcast.dart';
import 'package:onpods/widgets/custom_button.dart';
import 'package:provider/provider.dart';
import '../../providers/providers_exports.dart';
import '../../utils/utils_exports.dart';

class RecordPodcastBoarding extends StatefulWidget {
  const RecordPodcastBoarding({super.key});

  @override
  State<RecordPodcastBoarding> createState() => _RecordPodcastBoardingState();
}

class _RecordPodcastBoardingState extends State<RecordPodcastBoarding> {
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
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Unleash Your Creativity',
              style: TextStyle(
                  color: Colors.white, fontSize: 24, fontFamily: 'OpenSans'),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: SvgPicture.asset(
                recordAudio,
                width: MediaQuery.of(context).size.width * 0.6,
                alignment: Alignment.center,
              ),
            ).animate().fadeIn(),
            CustomElevatedButton(
              width: 0.6.sw,
              onTap: () => Get.to( const RecordPodcast(),
                  transition: Transition.cupertinoDialog),
              height: 42,
              text: 'Record Audio',
              buttonTextStyle:
                  const TextStyle(color: Colors.white, fontSize: 18),
              buttonStyle: ButtonStyle(
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                fixedSize: MaterialStateProperty.resolveWith<Size?>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.disabled)) {
                      return Size(0.6.sw, 40);
                    }
                    return Size(0.6.sw, 40);
                  },
                ),
                backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.disabled)) {
                      return Colors.grey;
                    }
                    return blueColor;
                  },
                ),
              ),
            ).animate().fadeIn(),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: SvgPicture.asset(
                audioUpload,
                width: MediaQuery.of(context).size.width * 0.6,
                alignment: Alignment.center,
              ),
            ).animate().fadeIn(),
            CustomElevatedButton(
              width: 0.6.sw,
              onTap: () {},
              height: 42,
              text: 'Upload Audio',
              buttonTextStyle:
                  const TextStyle(color: Colors.white, fontSize: 18),
              buttonStyle: ButtonStyle(
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                fixedSize: MaterialStateProperty.resolveWith<Size?>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.disabled)) {
                      return Size(0.6.sw, 40);
                    }
                    return Size(0.6.sw, 40);
                  },
                ),
                backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.disabled)) {
                      return Colors.grey;
                    }
                    return blueColor;
                  },
                ),
              ),
            ).animate().fade(),
          ],
        ),
      ),
    );
  }
}
