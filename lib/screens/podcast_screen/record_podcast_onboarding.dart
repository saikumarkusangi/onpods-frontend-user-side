

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onpods/utils/exports.dart';

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
        backgroundColor: Colors.black,
       iconTheme: const IconThemeData(color: Colors.white),
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
                width: MediaQuery.of(context).size.width * 0.5,
                alignment: Alignment.center,
              ),
            ).animate().fadeIn(),
            CustomElevatedButton(
              width: 0.6.sw,
              onTap: () => Get.to(  const RecordPodcast(),
                  transition: Transition.cupertinoDialog),
              height: 42,
              text: 'Record Audio',
              buttonTextStyle:
                  const TextStyle(color: Colors.white, fontSize: 18),
              buttonColor: blueColor,
            ).animate().fadeIn(),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: SvgPicture.asset(
                audioUpload,
                width: MediaQuery.of(context).size.width * 0.5,
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
             buttonColor: blueColor,
            ).animate().fade(),
          ],
        ),
      ),
    );
  }
}
