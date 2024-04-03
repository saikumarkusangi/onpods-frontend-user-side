import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:onpods/providers/local_downloads_provider.dart';
import 'package:onpods/providers/mini_player_provider.dart';
import 'package:onpods/utils/dynamic_links.dart';
import 'package:onpods/utils/exports.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:onpods/utils/firebase_notification.dart';
import 'package:onpods/utils/notification_service.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // final fcmToken = await FirebaseMessaging.instance.getToken();


setupFirebaseMessaging();

  await NotificationService.initializeNotification();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.black,
    systemNavigationBarIconBrightness: Brightness.light,
  ));
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await UserSession.initialize();

  DynamicLinkProvider().initDynamicLink();

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
            ChangeNotifierProvider(create: (_) => LocalDownloadProvider()),
            ChangeNotifierProvider(
              create: (_) => FileDownloaderProvider(),
            ),
            ChangeNotifierProvider(
              create: (_) => WishlistProvider(),
            ),
            ChangeNotifierProvider(
              create: (_) => MiniPlayerProvider(),
            ),
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
