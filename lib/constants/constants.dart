import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:carpex_stok_takibi/constants/data_helpar.dart';
import 'package:flutter/material.dart';

import '../page/login_page.dart';

class Constants {
  Constants._();

  static Color themeColor = Color(0xFF2B72B0);

  static List<Cihaz> tumEklenenCihazlar = [];

  static String musteri = '';

  static var getSplashScreen = AnimatedSplashScreen(
    duration: 700,
    splash: Image.asset("assets/images/sevk_logo.png"),
    nextScreen: const LoginPage(),
    splashTransition: SplashTransition.fadeTransition,
    backgroundColor: Colors.white,
    animationDuration: const Duration(milliseconds: 700),
    splashIconSize: 250,
    centered: true,
    //curve: Curves.bounceIn,
  );
}
