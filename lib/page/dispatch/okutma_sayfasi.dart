// ignore_for_file: library_private_types_in_public_api, file_names, use_build_context_synchronously, avoid_print

import 'dart:convert';

import 'package:carpex_cihaz_sevk/constants/utils/on_will_pop.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/constants.dart';
import '../../constants/data_helper.dart';
import '../../constants/urls.dart';
import 'qr_device_list_page.dart';

class QRScannerPage extends StatefulWidget {
  const QRScannerPage({super.key});

  @override
  _QRScannerPageState createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
/*----------------------------------------------------------------------------*/
//TODOs                               VARIABLES                               */
/*----------------------------------------------------------------------------*/

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  final TextEditingController textEditingController = TextEditingController(text: '');
  bool scanningSuccessful = false;
  bool isQrStokControlStatus = false;
  SharedPreferences? prefs;

/*----------------------------------------------------------------------------*/
//TODOs                               DISPOSE                                 */
/*----------------------------------------------------------------------------*/

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

/*----------------------------------------------------------------------------*/
//TODOs                           QR VİEW SCANNER                             */
/*----------------------------------------------------------------------------*/

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      // if (scanData.code!.replaceAll(' ', '').length == 12) {
      if (textEditingController.text == '') {
        setState(() {
          String newScannedDevice = scanData.code!;
          if (!newScannedDevice.startsWith("CRP-")) {
            newScannedDevice = "CRP-$newScannedDevice";
            // print("cihaz kodunda CRP- bulunmuyordu eklendi.");
          } else {
            // print("cihaz kodunda CRP- bulunuyor eklenmeyecek.");
          }
          textEditingController.text = newScannedDevice.replaceAll(' ', '').toUpperCase().toString();
          showSnackBar('Qr okundu: ${textEditingController.text}');
        });
      }
    });
  }

/*----------------------------------------------------------------------------*/
//TODOs                       LİSTEYE EKLE SORGULARI                          */
/*----------------------------------------------------------------------------*/

  void addTooList() async {
    setState(() {
      isQrStokControlStatus = true;
    });
    prefs = await SharedPreferences.getInstance();

    // print('prefs.get("username") ${prefs!.get("username")}');
    // print('prefs.get("password") ${prefs!.get("password")}');

    String username = prefs!.get("username").toString();
    String deviceId = textEditingController.text.replaceAll(' ', '').toUpperCase().toString();

    !deviceId.startsWith("CRP-") ? "CRP-$deviceId" : deviceId;

    var body = {"owner_id": username.split('@').last.trim(), "device_id": deviceId};

    try {
      // String basicAuth = 'Basic ${base64.encode(utf8.encode('${prefs!.get("username").toString()}:${prefs!.get("password").toString()}'))}';
      // print(basicAuth);

      http.Response response = await http.post(Uri.parse("$API_URL/device-stock-control/"), body: json.encode(body), headers: <String, String>{
        // 'authorization': basicAuth,
        'Content-Type': 'application/json; charset=UTF-8',
      });

      if (response.statusCode == 200) {
        //buraya bak
        // print("11111111111dene ${response.body.toString()}");
        // print("11111111111deneeee ${response.bodyBytes.toString()}");
        var abc = jsonDecode(utf8.decode(response.bodyBytes));
        // print("22222deneee ${abc['status']}");
        // print("22222deneee ${abc['status'].runtimeType}");

        if (abc['status'] == true) {
          // print('BU CİHAZ STOKTA VAR. LİSTEYE EKLİYORUM');
          // print('_addDeviceToCihazlar FONKSİYNU ÇALIŞIYOR');

          _addDeviceToCihazlar(textEditingController.text);
        } else {
          // print('BU CİHAZ STOKTA YOOOOOOOOKKKKKK');

          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const SizedBox(
                height: 20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Bu cihaz stokta yok!",
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height / 2,
              ),
              duration: const Duration(milliseconds: 800),
            ),
          );
        }
      } else {
        // print("server'da değilsin");
      }
    } catch (e) {
      // print('EEEEEEEeeeeeeee e.toString():${e.toString()}');
    }
    setState(() {
      isQrStokControlStatus = false;
    });
  }

/*----------------------------------------------------------------------------*/
//TODOs               CİHAZ DAHA ÖNCE LİSTEYE EKLENNDİ Mİ                     */
/*----------------------------------------------------------------------------*/

  void _addDeviceToCihazlar(String deviceCode) {
    // print('CİHAZ LİSTEYE DAHA ÖNCE EKLENİŞ Mİ BAKIYORUM');
    // Kontrol ett cihazın var mı
    bool isDeviceExists = Constants.tumEklenenCihazlar.any((cihaz) => cihaz.cihazKodu == deviceCode);
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    if (isDeviceExists) {
      // print('Cihaz zaten ekli!!!!!!!!!!!');
      // Cihaz zaten var uyarı snacki göster
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Container(
            alignment: Alignment.center,
            height: 50,
            color: Colors.red,
            child: const Text(
              'Cihaz zaten ekli.',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
          backgroundColor: Colors.transparent,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height - 85,
          ),
          duration: const Duration(milliseconds: 800),
        ),
      );
    } else {
      // print('CİHAZ LİSTEDE YOK YENİ CİHAZ EKLİYORUM');
      // Cihaz yokyeni cihazı ekle
      Cihaz newDevice = Cihaz(deviceCode);
      setState(() {
        Constants.tumEklenenCihazlar.add(newDevice);
      });
      // print('EKLEDİM');
      // EKLENDİ snacki göster
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Container(
            alignment: Alignment.center,
            height: 50,
            color: Colors.green,
            child: const Text(
              'Cihaz listeye eklendi',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
          backgroundColor: Colors.transparent,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height - 85,
          ),
          duration: const Duration(milliseconds: 800),
        ),
      );
    }
  }

/*----------------------------------------------------------------------------*/
//TODOs                          EXIT POP UP                                  */
/*----------------------------------------------------------------------------*/

  Future<bool> showExitPopupHandle() => showExitPopup(context);

/*----------------------------------------------------------------------------*/
//TODOs                            SHOW SNACKBAR                              */
/*----------------------------------------------------------------------------*/

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: SizedBox(
          height: 20,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                message,
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height / 2,
        ),
        duration: const Duration(milliseconds: 800),
      ),
    );
  }

/*----------------------------------------------------------------------------*/
//TODOs                               BUILD                                   */
/*----------------------------------------------------------------------------*/

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: showExitPopupHandle,
      child: Scaffold(
        backgroundColor: Constants.backgroundColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: const Text(
            'QR Scanner',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => QrDeviceListPage(selectedCustomer: Constants.musteri)),
                  (Route<dynamic> route) => false);
            },
            icon: const Icon(
              Icons.arrow_back_rounded,
            ),
          ),
          backgroundColor: Constants.themeColor,
        ),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.85,
                        height: MediaQuery.of(context).size.height * 0.45,
                        child: QRView(
                          key: qrKey,
                          onQRViewCreated: _onQRViewCreated,
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 30,
                          ),
                          const Text(
                            'Okunan Cihaz ',
                            style: TextStyle(fontSize: 17, color: Colors.black87, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: textEditingController,
                            readOnly: true,
                            autofocus: true,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            style: const TextStyle(fontSize: 16.0, color: Color.fromARGB(255, 54, 58, 61), fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                            smartDashesType: SmartDashesType.enabled,
                            smartQuotesType: SmartQuotesType.enabled,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.only(left: 14.0, bottom: 18.0, top: 18.0),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Color.fromARGB(118, 189, 198, 207)),
                                borderRadius: BorderRadius.circular(25.7),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: const BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(25.7),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          const Text(
                            "*Etkili bir okuma yapabilmek için cihazın QR kodu doğrultusunda ileri-geri hareket ettirilmesi gerekir.",
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black54, fontStyle: FontStyle.italic, fontFamily: ""),
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Expanded(
                        //   child: SizedBox(
                        //     height: 50,
                        //     child: ElevatedButton(
                        //       style: ElevatedButton.styleFrom(
                        //         backgroundColor: Colors.white,
                        //       ),
                        //       onPressed: () {
                        //         ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        //         Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => QrDeviceListPage(selectedCustomer: Constants.musteri)), (Route<dynamic> route) => false);
                        //       },
                        //       child: Row(
                        //         crossAxisAlignment: CrossAxisAlignment.center,
                        //         mainAxisAlignment: MainAxisAlignment.center,
                        //         children: [
                        //           const Icon(Icons.arrow_back, color: Colors.black87),
                        //           Container(
                        //               margin: const EdgeInsets.only(left: 6),
                        //               child: const Text(
                        //                 "Listeye Dön",
                        //                 style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500),
                        //               )),
                        //         ],
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        Expanded(
                          child: SizedBox(
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                              ),
                              onPressed: () {
                                // ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => QrDeviceListPage(selectedCustomer: Constants.musteri)), (Route<dynamic> route) => false);
                                setState(() {
                                  textEditingController.text = '';
                                });
                                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Container(
                                      alignment: Alignment.center,
                                      height: 50,
                                      color: Colors.white,
                                      child: const Text(
                                        'Cihaz okutabilirsiniz',
                                        style: TextStyle(fontSize: 18, color: Colors.black87, fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    backgroundColor: Colors.transparent,
                                    behavior: SnackBarBehavior.floating,
                                    margin: EdgeInsets.only(
                                      bottom: MediaQuery.of(context).size.height - 85,
                                    ),
                                    duration: const Duration(milliseconds: 500),
                                  ),
                                );
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.read_more_outlined, color: Colors.black87),
                                  Container(
                                      margin: const EdgeInsets.only(left: 6),
                                      child: const Text(
                                        "Yeni Cihaz Okut",
                                        style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500),
                                      )),
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
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Constants.themeColor,
                              ),
                              onPressed: () {
                                // print('CİHAZ EKLE BUTONUNA TIKLANDI!!!!!!!!');
                                if (textEditingController.text.isNotEmpty &&
                                    textEditingController.text.length == 16 &&
                                    textEditingController.text.startsWith("CRP-") &&
                                    textEditingController.text != '') {
                                  ScaffoldMessenger.of(context).hideCurrentSnackBar();

                                  // print('addTooList ÇALIŞACAK');
                                  addTooList();
                                } else {
                                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Container(
                                        alignment: Alignment.center,
                                        height: 50,
                                        color: Colors.red,
                                        child: const Text(
                                          'Okunan QR geçersiz.',
                                          style: TextStyle(fontSize: 18),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      backgroundColor: Colors.transparent,
                                      behavior: SnackBarBehavior.floating,
                                      margin: EdgeInsets.only(
                                        bottom: MediaQuery.of(context).size.height - 85,
                                      ),
                                      duration: const Duration(milliseconds: 800),
                                    ),
                                  );
                                  // showDialog(
                                  //   context: context,
                                  //   builder: (context) => AlertDialog(
                                  //     title: const Text('Uyarı'),
                                  //     content: const Text('Geçersiz cihaz kodu girdiniz.'),
                                  //     actions: [
                                  //       TextButton(
                                  //         onPressed: () {
                                  //           Navigator.pop(context);
                                  //         },
                                  //         child: const Text('Tamam'),
                                  //       ),
                                  //     ],
                                  //   ),
                                  // );
                                }
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(margin: const EdgeInsets.only(right: 6), child: const Text("Cihazı Ekle")),
                                  const Icon(Icons.add),
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
            isQrStokControlStatus == true
                ? Container(
                    color: Colors.white54,
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
