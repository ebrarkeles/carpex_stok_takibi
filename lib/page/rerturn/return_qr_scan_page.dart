// ignore_for_file: library_private_types_in_public_api, file_names, use_build_context_synchronously, avoid_print, prefer_const_constructors

import 'package:carpex_stok_takibi/page/rerturn/device_list_page.dart';
import 'package:carpex_stok_takibi/constants/utils/on_wii_pop.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/constants.dart';
import '../../constants/data_helpar.dart';

class ReturnQrScanPage extends StatefulWidget {
  const ReturnQrScanPage({Key? key}) : super(key: key);

  @override
  _ReturnQrScanPageState createState() => _ReturnQrScanPageState();
}

class _ReturnQrScanPageState extends State<ReturnQrScanPage> {
/*----------------------------------------------------------------------------*/
//TODOs                               VARIABLES                               */
/*----------------------------------------------------------------------------*/

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool scanningSuccessful = false;
  String scannedDevice = '';
  bool isQrStcokControlStatus = false;
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
      setState(() {
        String newScannedDevice = scanData.code!;
        if (scannedDevice != newScannedDevice) {
          scanningSuccessful = true;
          scannedDevice = scanData.code!;
          showSnackBar('Qr okundu: CRP-$scannedDevice');
          print("scannedDevice : CRP-$scannedDevice");
        }
      });
      /* } else {
      print("XXXXXXXXXXXXXXXXXXXXXXX");
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Farklı bir qr kod okuttunuz!',
            style: TextStyle(fontSize: 18),
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height - 85,
          ),
          duration: Duration(milliseconds: 800),
        ),
      );
      }*/
    });
  }

/*----------------------------------------------------------------------------*/
//TODOs                 LİSTEYE EKLE SORGULARI                     */
/*----------------------------------------------------------------------------*/
  void addToIadeList() {
    setState(() {
      isQrStcokControlStatus = true;
    });

    String crpDeviceId = "CRP-${scannedDevice.toUpperCase()}";
    bool found = false;

    for (var e in Constants.gonderilmisCihazList) {
      if (e['value'].toString() == crpDeviceId) {
        _addDeviceToCihazlar(scannedDevice);
        found = true;
        break;
      }
    }

    if (!found) {
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
                  "Bu cihaz ${Constants.musteri} firmasına ait bir cihaz değil!",
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

    setState(() {
      isQrStcokControlStatus = false;
    });
  }

/*----------------------------------------------------------------------------*/
//TODOs               CİHAZ DAHA ÖNCE LİSTEYE EKLENNDİ Mİ                     */
/*----------------------------------------------------------------------------*/

  void _addDeviceToCihazlar(String deviceCode) {
    // Kontrol et, cihazın zaten var mı?
    String crpDeviceId = "CRP-${deviceCode.toUpperCase()}";
    bool isDeviceExists =
        Constants.iadeCihazListesi.any((e) => e.cihazKodu == crpDeviceId);

    if (isDeviceExists) {
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
      // Cihaz yok, yeni cihazı ekle
      Cihaz newDevice = Cihaz(crpDeviceId);
      setState(() {
        Constants.iadeCihazListesi.add(newDevice);
      });

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

/* ---------------------------------------------------------------------------- */
//TODOs                          EXIT POP UP                                  */
/* ---------------------------------------------------------------------------- */

  Future<bool> showExitPopupHandle() => showExitPopup(context);

/* ---------------------------------------------------------------------------- */
//TODOs                               BUILD                                   */
/* ---------------------------------------------------------------------------- */

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: showExitPopupHandle,
        child: Scaffold(
          backgroundColor: Constants.backgroundColor,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: const Text(
              'İade QR Scanner',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            leading: IconButton(
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => DeviceListPage(
                            selectedCustomer: Constants.musteri)),
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
                              style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              controller: TextEditingController(
                                  text: scannedDevice.isNotEmpty
                                      ? "CRP-${scannedDevice.replaceAll(' ', '')}"
                                          .toString()
                                      : ""),
                              readOnly: true,
                              autofocus: true,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              style: const TextStyle(
                                  fontSize: 16.0,
                                  color: Color.fromARGB(255, 54, 58, 61),
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                              smartDashesType: SmartDashesType.enabled,
                              smartQuotesType: SmartQuotesType.enabled,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.only(
                                    left: 14.0, bottom: 18.0, top: 18.0),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color:
                                          Color.fromARGB(118, 189, 198, 207)),
                                  borderRadius: BorderRadius.circular(25.7),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(25.7),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            const Text(
                              "*Etkili bir okuma yapabilmek için cihazın QR kodu doğrultusunda ileri-geri hareket ettirilmesi gerekir.",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black54,
                                  fontStyle: FontStyle.italic,
                                  fontFamily: ""),
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          left: 10, right: 10, bottom: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 50,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                ),
                                onPressed: () {
                                  ScaffoldMessenger.of(context)
                                      .hideCurrentSnackBar();
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              DeviceListPage(
                                                  selectedCustomer:
                                                      Constants.musteri)),
                                      (Route<dynamic> route) => false);
                                },
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.arrow_back,
                                        color: Colors.black87),
                                    Container(
                                        margin: const EdgeInsets.only(left: 6),
                                        child: const Text(
                                          "Listeye Dön",
                                          style: TextStyle(
                                              color: Colors.black87,
                                              fontWeight: FontWeight.w500),
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
                                  if (scannedDevice.isNotEmpty) {
                                    ScaffoldMessenger.of(context)
                                        .hideCurrentSnackBar();
                                    addToIadeList();
                                  } else {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('Uyarı'),
                                        content: const Text(
                                            'Eklemek için taranan bir cihaz kodu yok.'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Tamam'),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                },
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                        margin: const EdgeInsets.only(right: 6),
                                        child: const Text("Cihazı Ekle")),
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
              isQrStcokControlStatus == true
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
    );
  }

/*----------------------------------------------------------------------------*/
//TODOs                            SHOW SNACKBAR                              */
/*----------------------------------------------------------------------------*/

  void showSnackBar(String message) {
    if (scannedDevice.isNotEmpty) {
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
  }
}
