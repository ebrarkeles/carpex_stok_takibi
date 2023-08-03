// ignore_for_file: file_names

import 'package:get/get.dart';

class MainController extends GetxController {
  RxString selectedCustomer = ''.obs;

  void setSelectedCustomer(String customer) {
    selectedCustomer.value = customer;
  }

  var rememberMe = false.obs;
}
