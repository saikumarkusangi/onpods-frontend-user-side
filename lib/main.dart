
import 'package:onpods/utils/exports.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.black,
    systemNavigationBarIconBrightness: Brightness.light,
  ));
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
   await UserSession.initialize();
 
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(430, 1088),
      builder: (context, child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthProvider()),
            ChangeNotifierProvider(create: (_) => BackGroundProvider()),
            ChangeNotifierProvider(create: (_) => PodcastProvider()),
            ChangeNotifierProvider(create: (_) => QuoteProvider()),
            ChangeNotifierProvider(create: (_) => RecordingDurationProvider()),
            ChangeNotifierProvider(create: (_) => BgAudioProvider()),
            ChangeNotifierProvider(create: (_) => FileDownloaderProvider(),),
            ChangeNotifierProvider(create: (_) => WishlistProvider(),),
          ],
          child: GetMaterialApp(
            title: 'Onpods',
            debugShowCheckedModeBanner: false,
            initialRoute: AppRoutes.splash,
            routes: AppRoutes.routes,
            theme: ThemeData(
              scaffoldBackgroundColor: darkscaffoldBackgroundColor,
              useMaterial3: true,
            ),
            home: const SplashScreen(),
          ),
        );
      },
    );
  }
}
