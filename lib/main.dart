import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lami_tag/firebase_options.dart';
import 'package:lami_tag/res/lami_colors.dart';
import 'package:lami_tag/res/lami_strings.dart';
import 'package:lami_tag/res/routes/lami_routes.dart';
import 'package:lami_tag/views/splash/splash_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

GlobalKey<NavigatorState> globalKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
            navigatorKey: globalKey,
            title: LamiString.appName,
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                  seedColor: LamiColors.white),
              useMaterial3: true,
              textTheme: GoogleFonts.robotoTextTheme()
            ),
            home: const SplashView(),
            routes: LamiRoutes.appRoutes);
      },
    );
  }
}
