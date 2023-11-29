import 'package:onpods/utils/exports.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () async {
      final userId = await UserSession.getUserId();
      print('splash screening checking user' + userId.toString());
      
      if (userId != null) {
        Get.off(() => const Layout(), transition: Transition.circularReveal);
      } else {
        Get.off(() => const LoginScreen(),
            transition: Transition.circularReveal);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
          child: SizedBox(
        height: MediaQuery.of(context).size.height / 3,
        child: Image.asset(splashLogo),
      )),
    );
  }
}
