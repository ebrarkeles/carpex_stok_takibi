// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:convert';

import 'package:carpex_cihaz_sevk/constants/fonts.dart';
import 'package:carpex_cihaz_sevk/page/return/customer_choose_page.dart';
import 'package:carpex_cihaz_sevk/page/return/gonderilmis_cihaz_list_page.dart';
import 'package:carpex_cihaz_sevk/page/return/return_qr_scan_page.dart';
import 'package:carpex_cihaz_sevk/page/return/widgets/return_device_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/colors.dart';
import '../../constants/constants.dart';
import '../../constants/urls.dart';
import '../../constants/utils/on_will_pop.dart';
import '../../controller/mainController.dart';
import '../dispatch/finish_page.dart';

class DeviceListPage extends StatefulWidget {
  final String selectedCustomer;

  const DeviceListPage({super.key, required this.selectedCustomer});

  @override
  State<DeviceListPage> createState() => _DeviceListPageState();
}

class _DeviceListPageState extends State<DeviceListPage> {
  //EXIT POP UP   ------------------------------------------------------------*/
  Future<bool> showExitPopupHandle() => showExitPopup(context);
/*----------------------------------------------------------------------------*/
  final controller = Get.put(MainController());

  //SEND   ------------------------------------------------------------*/

  void sendDevicesApi() async {
    Navigator.of(context).pop();
    setState(() {
      sendCircularIsActive = true;
    });
    var listem = [];

    prefs = await SharedPreferences.getInstance();
    // print('prefs.get("username") ${prefs!.get("username")}');
    // print('prefs.get("password") ${prefs!.get("password")}');

    for (var i = 0; i < Constants.iadeCihazListesi.length; i++) {
      // print(Constants.iadeCihazListesi[i].cihazKodu);
      String cihazKodu = Constants.iadeCihazListesi[i].cihazKodu.toString().toUpperCase();

      if (!cihazKodu.startsWith("CRP-")) {
        cihazKodu = "CRP-$cihazKodu";
      }

      cihazKodu = cihazKodu.replaceAll(" ", "");

      listem.add(cihazKodu);
      /*listem.add(
          "CRP-${Constants.iadeCihazListesi[i].cihazKodu.toString().replaceAll(" ", '')}"
              .toString()
              .toUpperCase());*/
    }

    var body = {"username": prefs!.get("username").toString(), "devices": listem, "buyer_id": prefs!.get("username").toString().split('@').last.trim()};

    // print("body1 : $body");
    // print("body2 : ${json.encode(body)}");

    try {
      String basicAuth = 'Basic ${base64.encode(utf8.encode('${prefs!.get("username").toString()}:${prefs!.get("password").toString()}'))}';
      // print(basicAuth);

      http.Response response = await http.post(Uri.parse("$API_URL/device-transaction/"), body: json.encode(body), headers: <String, String>{
        'authorization': basicAuth,
        'Content-Type': 'application/json; charset=UTF-8',
      });

      // print("11111111111 ${response.body}");
      if (response.statusCode == 200) {
        setState(() {
          sendCircularIsActive = false;
        });
        // print("2222222222 ${response.body}");
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (BuildContext context) => const FinishPage()),
          (Route<dynamic> route) => false,
        );
      } else {
        // print('başarısızIadeee');
        setState(() {
          sendCircularIsActive = false;
        });
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Cihaz iade işlemi başarısız!',
              style: TextStyle(fontSize: 18),
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height - 85,
            ),
            duration: const Duration(milliseconds: 800),
          ),
        );
      }
    } catch (e) {
      // print(e.toString());
      setState(() {
        sendCircularIsActive = false;
      });
    }
  }

/*----------------------------------------------------------------------------*/

  SharedPreferences? prefs;
  TextEditingController searchController = TextEditingController();
  bool sendCircularIsActive = false;
  @override
  void initState() {
    super.initState();
    searchController.text = Constants.musteri.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Constants.themeColor,
      child: SafeArea(
        child: WillPopScope(
          onWillPop: showExitPopupHandle,
          child: Scaffold(
            backgroundColor: Constants.backgroundColor,
            appBar: AppBar(
              centerTitle: true,
              elevation: 0,
              backgroundColor: Constants.themeColor,
              title: const Text(
                "İade Cihaz Listesi",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              leading: IconButton(
                onPressed: () {
                  Get.to(const MusteriSec());
                  Constants.tumEklenenCihazlar.clear();
                },
                icon: const Icon(
                  Icons.arrow_back_rounded,
                ),
              ),
              actions: [
                Padding(
                  padding: EdgeInsets.only(right: 2.0.wp),
                  child: IconButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SentDevicesList(),
                          ),
                          (route) => false);
                    },
                    icon: const Icon(Icons.playlist_add_rounded),
                  ),
                )
              ],
            ),
            body: Stack(
              children: [
                Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      height: 55,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 6,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: TextFormField(
                        enabled: false,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16, color: black),
                        controller: searchController,
                        decoration: const InputDecoration(
                          floatingLabelAlignment: FloatingLabelAlignment.center,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          filled: true,
                          fillColor: Colors.white70,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 15, left: 15, top: 8, bottom: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            // SizedBox(
                            //   height: 35,
                            //   child: Row(
                            //     crossAxisAlignment: CrossAxisAlignment.center,
                            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //     children: [
                            //       const Text(
                            //         "Cihaz Listesi",
                            //         style: TextStyle(
                            //           color: Colors.black,
                            //           fontSize: 14,
                            //           fontWeight: FontWeight.bold,
                            //         ),
                            //       ),
                            //       Text(
                            //         "${Constants.iadeCihazListesi.length}  cihaz eklendi",
                            //         style: const TextStyle(color: Colors.black54),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            const ReturnDeviceList(),
                            Container(
                              margin: const EdgeInsets.only(top: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      height: 50,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green[400],
                                        ),
                                        onPressed: () {
                                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => const ReturnQrScanPage()),
                                              (Route<dynamic> route) => false);
                                        },
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            const Icon(Icons.qr_code_scanner_rounded),
                                            Container(margin: const EdgeInsets.only(left: 6), child: const Text("Qr Okut")),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: SizedBox(
                                      height: 50,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          _showConfirmationDialog();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Constants.themeColor,
                                        ),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Container(margin: const EdgeInsets.only(right: 6), child: const Text("İade Et ")),
                                            const Icon(Icons.send_rounded),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                sendCircularIsActive == true
                    ? Container(
                        color: Colors.white54,
                        alignment: Alignment.center,
                        child: const CircularProgressIndicator(),
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Liste boş dolu kontrolü
  Future<void> _showConfirmationDialog() async {
    if (Constants.iadeCihazListesi.isEmpty) {
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Cihaz Blunamadı'),
            content: const SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Sevk edilecek bir cihaz bulunamadı. Lütfen önce cihaz ekleyiniz.'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Tamam'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Cihaz İade Onayı'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('${Constants.iadeCihazListesi.length} cihaz ${Constants.musteri} firmasından iade alınacak!'),
                ],
              ),
            ),
            actions: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      elevation: 0,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text(
                      'Vazgeç',
                      style: TextStyle(color: Color.fromARGB(194, 0, 0, 0)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Constants.themeColor,
                    ),
                    onPressed: () => sendDevicesApi(),
                    //return true when click on "Yes"
                    child: SizedBox(
                      width: 100,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 6),
                            child: const Text("İade Oluştur"),
                          ),
                          const Icon(Icons.send_rounded),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          );
        },
      );
    }
  }
}
