import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:onpods/routes/app_routes.dart';
import 'package:onpods/screens/screens_exports.dart';
import 'package:provider/provider.dart';
import 'providers/providers_exports.dart';
import 'utils/utils_exports.dart';

void main() {
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
                ChangeNotifierProvider(create: (context) => PasswordToggle()),
                ChangeNotifierProvider(
                    create: (context) => IconColorProvider()),
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
