import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:onpods/providers/dummy_provider.dart';
import 'package:onpods/routes/app_routes.dart';
import 'package:onpods/screens/screens_exports.dart';
import 'package:provider/provider.dart';
import 'providers/providers_exports.dart';
import 'utils/utils_exports.dart';

void main() async {
   await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
   SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: scaffoldBackgroundColor,
    systemNavigationBarIconBrightness: Brightness.light,
  ));
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
 
  
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
                ChangeNotifierProvider(create: (_) => AudioPlayerProvider()),
                ChangeNotifierProvider(create: (_)=>DummyProvider()),
                 ChangeNotifierProvider(create: (_)=>QuoteProvider())
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
                    scaffoldBackgroundColor: scaffoldBackgroundColor,
                    useMaterial3: true),
                home: const SplashScreen(),
              ),
            ));
  }
}
