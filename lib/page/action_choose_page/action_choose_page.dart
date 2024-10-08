// ignore_for_file: avoid_print

import 'package:carpex_cihaz_sevk/constants/fonts.dart';
import 'package:carpex_cihaz_sevk/main.dart';
import 'package:carpex_cihaz_sevk/page/return/customer_choose_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/constants.dart';
import '../../constants/utils/on_will_pop.dart';
import '../../controller/mainController.dart';
import '../login_page.dart';

class ActionChoosePage extends StatefulWidget {
  const ActionChoosePage({super.key});

  @override
  State<ActionChoosePage> createState() => _ActionChoosePageState();
}

class _ActionChoosePageState extends State<ActionChoosePage> {
  //CONTROLLER  --------------------------------------------------------------*/
  final controller = Get.put(MainController());
/*----------------------------------------------------------------------------*/

  //EXIT POP UP   ------------------------------------------------------------*/
  Future<bool> showExitPopupHandle() => showExitPopup(context);
/*----------------------------------------------------------------------------*/

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Constants.themeColor,
      child: SafeArea(
        child: WillPopScope(
          onWillPop: showExitPopupHandle,
          child: Scaffold(
            backgroundColor: Constants.backgroundColor,
            body: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Constants.themeColor, borderRadius: const BorderRadius.only(bottomRight: Radius.circular(15), bottomLeft: Radius.circular(15))),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 7.0.wp),
                      child: Stack(children: [
                        Center(
                          child: Text(
                            "Yapmak İstediğiniz İşlem",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0.sp,
                              //fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Positioned(
                          top: -0.7.hp,
                          bottom: 0.9.hp,
                          right: 1.0.wp,
                          child: IconButton(
                              onPressed: () {
                                showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text("Carpex Cihaz Sevk"),
                                    content: const Text("Oturumdan çıkış yapmak istiyor musunuz?"),
                                    actions: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(backgroundColor: Colors.white, elevation: 0),
                                        onPressed: () => Navigator.of(context).pop(),
                                        child: const Text(
                                          'Hayır',
                                          style: TextStyle(color: Color.fromARGB(194, 0, 0, 0)),
                                        ),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 255, 60, 60)),
                                        onPressed: () {
                                          Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(builder: (context) => const LoginPage()),
                                            (route) => false,
                                          );
                                          // prefs!.clear();
                                        },
                                        child: const Text('Evet, Çıkış yap'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.exit_to_app_outlined,
                                color: Colors.white,
                              )),
                        ),
                      ]),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 6.0.hp, horizontal: 3.0.wp),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              controller.isSevk.value == false ? controller.selectChazSevk() : controller.isSevk.value = false;
                              // print("iade(${controller.isIade.value}) ve sevk(${controller.isSevk.value})");
                            },
                            child: Obx(
                              () => Container(
                                decoration: BoxDecoration(
                                  color: Colors.white70,
                                  border: controller.isSevk.value == true
                                      ? Border.all(color: Colors.green, width: 5)
                                      : Border.all(color: Colors.transparent, width: 5),
                                ),
                                width: 19.5.hp,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      height: 19.0.hp,
                                      width: 18.0.hp,
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
                                      child: Image.asset("assets/images/sevk-2.png", fit: BoxFit.fitHeight),
                                    ),
                                    SizedBox(height: 2.0.hp),
                                    Text(
                                      "Cihaz Sevk",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 14.0.sp, fontWeight: FontWeight.w700, letterSpacing: 0.7),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 5.0.wp),
                          InkWell(
                            onTap: () {
                              controller.isIade.value == false ? controller.selectChazIade() : controller.isIade.value = false;
                              // print("iade(${controller.isIade.value}) ve sevk(${controller.isSevk.value})");
                            },
                            child: Obx(
                              () => Container(
                                decoration: BoxDecoration(
                                  color: Colors.white70,
                                  border: controller.isIade.value == true
                                      ? Border.all(color: Colors.green, width: 5)
                                      : Border.all(color: Colors.transparent, width: 5),
                                ),
                                width: 19.5.hp,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      height: 19.0.hp,
                                      width: 18.0.hp,
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                                      child: Image.asset("assets/images/images.png"),
                                    ),
                                    SizedBox(height: 2.0.hp),
                                    Text(
                                      "Cihaz İade",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 14.0.sp, fontWeight: FontWeight.w700, letterSpacing: 0.7),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 1.5.hp,
                      ),
                      child: Obx(
                        () => InkWell(
                          onTap: islemSecFunction,
                          child: Container(
                            height: 7.0.hp,
                            width: 65.0.wp,
                            decoration: BoxDecoration(
                              color: controller.isIade.value == true || controller.isSevk.value == true
                                  ? Constants.themeColor
                                  : Constants.themeColor.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: const Center(
                              child: Text(
                                "İşlemi Seç",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  islemSecFunction() {
    if (controller.isIade.value == true) {
      Get.to(() => const MusteriSec());
    } else if (controller.isSevk.value == true) {
      Get.to(() => const MyHomePage());
    } else if (controller.isIade.value == false || controller.isSevk.value == false) {}
  }
}
