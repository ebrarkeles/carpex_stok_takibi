// ignore_for_file: non_constant_identifier_names

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:carpex_cihaz_sevk/constants/data_helper.dart';
import 'package:flutter/material.dart';

import '../page/login_page.dart';

class Constants {
  Constants._();

  static Color themeColor = const Color.fromRGBO(43, 114, 176, 1);
  static Color backgroundColor = const Color.fromRGBO(245, 245, 245, 1);

  static List<Cihaz> tumEklenenCihazlar = [];
  static List<Cihaz> iadeCihazListesi = [];
  static var gonderilmisCihazList = [];

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
  );

  static var MusteriList = [];
  static String buyerId = "";
}
