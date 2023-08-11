import 'package:carpex_stok_takibi/constants/fonts.dart';
import 'package:carpex_stok_takibi/main.dart';
import 'package:carpex_stok_takibi/page/rerturn/musteri_sec.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/constants.dart';
import '../../controller/mainController.dart';
import '../../utils/on_wii_pop.dart';

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
    return SafeArea(
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
                  decoration: BoxDecoration(
                      color: Constants.themeColor,
                      borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(15),
                          bottomLeft: Radius.circular(15))),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 4.0.hp, vertical: 7.0.wp),
                    child: Center(
                      child: Text(
                        "Yapmak İstediğiniz İşlem",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0.sp,
                          //fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 6.0.hp, horizontal: 3.0.wp),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                            onTap: () {
                              controller.isSevk.value == false
                                  ? controller.selectChazSevk()
                                  : controller.isSevk.value = false;
                              print(
                                  "iade(${controller.isIade.value}) ve sevk(${controller.isSevk.value})");
                            },
                            child: Obx(
                              () => Container(
                                decoration: BoxDecoration(
                                    color: Colors.white70,
                                    border: controller.isSevk.value == true
                                        ? Border.all(
                                            color: Colors.green, width: 5)
                                        : Border.all(
                                            color: Colors.transparent)),
                                height: 27.0.hp,
                                width: 19.5.hp,
                                child: Column(
                                  children: [
                                    Container(
                                      height: 19.0.hp,
                                      width: 18.0.hp,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Image.asset(
                                        "assets/images/sevk-2.png",
                                        fit: BoxFit.fitHeight,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 2.0.hp,
                                    ),
                                    Text(
                                      "Chaz Sevk",
                                      style: TextStyle(
                                          fontSize: 14.0.sp,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 0.7),
                                    ),
                                  ],
                                ),
                              ),
                            )),
                        SizedBox(
                          width: 5.0.wp,
                        ),
                        InkWell(
                          onTap: () {
                            controller.isIade.value == false
                                ? controller.selectChazIade()
                                : controller.isIade.value = false;
                            print(
                                "iade(${controller.isIade.value}) ve sevk(${controller.isSevk.value})");
                          },
                          child: Obx(
                            () => Container(
                              decoration: BoxDecoration(
                                  color: Colors.white70,
                                  border: controller.isIade.value == true
                                      ? Border.all(
                                          color: Colors.green, width: 5)
                                      : Border.all(color: Colors.transparent)),
                              height: 27.0.hp,
                              width: 19.5.hp,
                              child: Column(
                                children: [
                                  Container(
                                    height: 19.0.hp,
                                    width: 18.0.hp,
                                    decoration: BoxDecoration(
                                      //color: Colors.green,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child:
                                        Image.asset("assets/images/images.png"),
                                  ),
                                  SizedBox(
                                    height: 2.0.hp,
                                  ),
                                  Text(
                                    "Chaz İade",
                                    style: TextStyle(
                                        fontSize: 14.0.sp,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.7),
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
                            color: controller.isIade.value == true ||
                                    controller.isSevk.value == true
                                ? Constants.themeColor
                                : Constants.themeColor.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Center(
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
    );
  }

  islemSecFunction() {
    if (controller.isIade.value == true) {
      Get.to(MusteriSec());
    } else if (controller.isSevk.value == true) {
      Get.to(MyHomePage());
    } else if (controller.isIade.value == false ||
        controller.isSevk.value == false) {}
  }
}
