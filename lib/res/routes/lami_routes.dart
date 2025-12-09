import "package:flutter/material.dart";
import "package:lami_tag/views/splash/splash_view.dart";

class LamiRoutes {
  static const String splashScreen = '/splash';


  static Map<String, Widget Function(BuildContext)> appRoutes = {
    LamiRoutes.splashScreen: (context) => const SplashView(),
  };
}
