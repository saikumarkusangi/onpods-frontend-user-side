import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:onpods/providers/dummy_provider.dart';
import 'package:onpods/providers/ui_providers/timer_provider.dart';
import 'package:onpods/routes/app_routes.dart';
import 'package:onpods/screens/podcast_screen/record_podcast.dart';
import 'package:onpods/screens/screens_exports.dart';
import 'package:onpods/widgets/connection_error.dart';
import 'package:provider/provider.dart';
import 'providers/providers_exports.dart';
import 'utils/utils_exports.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.black,
    systemNavigationBarIconBrightness: Brightness.light,
  ));
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
    if (result == ConnectivityResult.none) {
      Get.to(const NoConnection());
    }
  });
  await Hive.initFlutter();
  await FlutterDownloader.initialize(debug: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(430, 1088),
        builder: (context, child) => MultiProvider(
              providers: [
                ChangeNotifierProvider(create: (_) => AuthProvider()),
                ChangeNotifierProvider(create: (_) => BackGroundProvider()),
                ChangeNotifierProvider(create: (_) => PasswordToggle()),
                ChangeNotifierProvider(create: (_) => RecorderProvider()),
                ChangeNotifierProvider(create: (_) => CurrentAudioProvider()),
                ChangeNotifierProvider(create: (_) => DummyProvider()),
                ChangeNotifierProvider(create: (_) => QuoteProvider()),
                ChangeNotifierProvider(create: (_) => BgAudioProvider()),
                ChangeNotifierProvider(
                  create: (context) => FileDownloaderProvider(),
                ),
                ChangeNotifierProvider(
                  create: (context) => WishlistProvider(),
                ),
                ChangeNotifierProvider(  
                  create: (_) => RecordingDurationProvider(),
                  child: const RecordPodcast(),
                )
              ],
              child: GetMaterialApp(
                title: 'Onpods',
                debugShowCheckedModeBanner: false,
                initialRoute: AppRoutes.splash,
                routes: AppRoutes.routes,
                theme: ThemeData(
                    bottomNavigationBarTheme:
                        const BottomNavigationBarThemeData(
                            backgroundColor: bottomNavColor),
                    scaffoldBackgroundColor: Colors.black,
                    useMaterial3: true),
                home: const SplashScreen(),
              ),
            ));
  }
}




