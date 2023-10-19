import 'package:carpex_stok_takibi/constants/fonts.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../constants/colors.dart';

class ConnectivityService {
  static ConnectivityResult connectivityResult = ConnectivityResult.wifi;

  static void connectivityMethod() {
    /// check internet connection
    Connectivity().checkConnectivity().then((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        Get.snackbar(
          'Title',
          'Message',
          titleText: Text(
            'İnternet',
            style: TextStyle(
                color: white, fontSize: 16.0.sp, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          messageText: Text(
            'İnternet bağlantınız yok..',
            style: TextStyle(color: white, fontSize: 14.0.sp),
            textAlign: TextAlign.center,
          ),
          borderRadius: 0.0,
          margin: EdgeInsets.zero,
          colorText: white,
          backgroundColor: red,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(days: 1000),
          isDismissible: true,
          dismissDirection: DismissDirection.none,
        );
      }

      connectivityResult = result;
    });

    /// listen to internet connection change
    Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      if (result == ConnectivityResult.none) {
        if (connectivityResult == ConnectivityResult.wifi ||
            connectivityResult == ConnectivityResult.mobile) {
          Get.snackbar(
            'Title',
            'Message',
            titleText: Text(
              'İnternet',
              style: TextStyle(
                  color: white, fontSize: 16.0.sp, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            messageText: Text(
              'İnternet bağlantınız yok..',
              style: TextStyle(color: white, fontSize: 14.0.sp),
              textAlign: TextAlign.center,
            ),
            borderRadius: 0.0,
            margin: EdgeInsets.zero,
            colorText: white,
            backgroundColor: red,
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(days: 1000),
            isDismissible: true,
            dismissDirection: DismissDirection.none,
          );
        }
      } else if (result == ConnectivityResult.wifi ||
          result == ConnectivityResult.mobile) {
        if (connectivityResult == ConnectivityResult.none) {
          // close previously opened snackbar's
          Get.closeAllSnackbars();

          Get.snackbar(
            'Title',
            'Message',
            titleText: Text(
              'İnternet ',
              style: TextStyle(
                  color: white, fontSize: 16.0.sp, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            messageText: Text(
              'İnternete bağlanıyor..',
              style: TextStyle(color: white, fontSize: 14.0.sp),
              textAlign: TextAlign.center,
            ),
            borderRadius: 0.0,
            margin: EdgeInsets.zero,
            colorText: white,
            backgroundColor: greenColor,
            showProgressIndicator: true,
            progressIndicatorBackgroundColor: white,
            progressIndicatorValueColor:
                const AlwaysStoppedAnimation<Color>(greenColor),
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      }

      connectivityResult = result;
    });
  }
}
