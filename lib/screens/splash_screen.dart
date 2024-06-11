import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:onpods/providers/local_downloads_provider.dart';
import 'package:onpods/utils/exports.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkNetworkAndNavigate();
  }

  Future<void> _checkNetworkAndNavigate() async {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      // No internet connection
      Get.offAll(() => const NoConnection(), transition: Transition.fadeIn);
    } else {
      // Internet connection available
      final userId = await UserSession.getUserId();

      if (userId != null) {
        Get.offAll(() => const Layout(), transition: Transition.fadeIn);
      } else {
        Get.offAll(() => const LoginScreen(), transition: Transition.fadeIn);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localDownloadProvider = Provider.of<LocalDownloadProvider>(context);
    if (localDownloadProvider.audioFiles.isEmpty) {
      localDownloadProvider.loadLocalDownloads();
    }
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SizedBox(
          height: MediaQuery.of(context).size.height / 3,
          child: Image.asset(splashLogo),
        ),
      ),
    );
  }
}
