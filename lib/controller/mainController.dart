// ignore_for_file: file_names

import 'package:get/get.dart';

class MainController extends GetxController {
  RxString selectedCustomer = ''.obs;

  void setSelectedCustomer(String customer) {
    selectedCustomer.value = customer;
  }

  var rememberMe = false.obs;

  Future<void> delay(int millis) async {
    await Future.delayed(Duration(milliseconds: millis));
  }

  final usernameController = "".obs;
  final passwordController = "".obs;

  var isSevk = false.obs;
  var isIade = false.obs;

  void selectChazIade() {
    isSevk.value = false;
    isIade.value = true;
  }

  void selectChazSevk() {
    isSevk.value = true;
    isIade.value = false;
  }
}
