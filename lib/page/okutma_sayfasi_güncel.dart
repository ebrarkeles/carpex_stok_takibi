// ignore_for_file: library_private_types_in_public_api, file_names

import 'package:carpex_stok_takibi/page/qr_device_list_page.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../constants/constants.dart';
import '../constants/data_helpar.dart';

class QRScannerPage extends StatefulWidget {
  const QRScannerPage({Key? key}) : super(key: key);

  @override
  _QRScannerPageState createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool scanningSuccessful = false;
  String scannedDevice = '';

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      // if (scanData.code!.replaceAll(' ', '').length == 12) {
      setState(() {
        scanningSuccessful = true;
        scannedDevice = scanData.code!;
      });
      // } else {
      // print("XXXXXXXXXXXXXXXXXXXXXXX");
      // ScaffoldMessenger.of(context).hideCurrentSnackBar();
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: const Text(
      //       'Farklı bir qr kod okuttunuz!',
      //       style: TextStyle(fontSize: 18),
      //     ),
      //     backgroundColor: Colors.red,
      //     behavior: SnackBarBehavior.floating,
      //     margin: EdgeInsets.only(
      //       bottom: MediaQuery.of(context).size.height - 85,
      //     ),
      //     duration: Duration(milliseconds: 800),
      //   ),
      // );
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('QR Scanner'),
          backgroundColor: Constants.themeColor,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(),
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.75,
                  height: MediaQuery.of(context).size.height * 0.35,
                  child: QRView(
                    key: qrKey,
                    onQRViewCreated: _onQRViewCreated,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 35, right: 25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Okunan Cihaz ',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black54,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      scannedDevice.isNotEmpty
                          ? "CRP-${scannedDevice.replaceAll(' ', '')}"
                              .toString()
                          : "",
                      style: const TextStyle(
                          fontSize: 23, color: Colors.black, letterSpacing: 1),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 15, bottom: 50, right: 15),
                  child: ButtonBar(
                    alignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        height: 40,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Constants.themeColor.withOpacity(0.6),
                            ),
                            onPressed: () {
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          QrDeviceListPage(
                                              selectedCustomer:
                                                  Constants.musteri)),
                                  (Route<dynamic> route) => false);
                            },
                            child: const Text("Listeye Dön")),
                      ),
                      SizedBox(
                        height: 40,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[400],
                          ),
                          onPressed: () {
                            if (scannedDevice.isNotEmpty) {
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                              _addDeviceToCihazlar(scannedDevice);
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
                          child: const Text('Cihazı Ekle'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  void _addDeviceToCihazlar(String deviceCode) {
    // Kontrol ett cihazın var mı
    bool isDeviceExists = Constants.tumEklenenCihazlar
        .any((cihaz) => cihaz.cihazKodu == deviceCode);
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    if (isDeviceExists) {
      // Cihaz zaten var uyarı snacki göster
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Cihaz zaten ekli.',
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
    } else {
      // Cihaz yokyeni cihazı ekle
      Cihaz newDevice = Cihaz(deviceCode);
      setState(() {
        Constants.tumEklenenCihazlar.add(newDevice);
      });

      // EKLENDİ snacki göster
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Cihaz listeye eklendi',
            style: TextStyle(fontSize: 18),
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height - 85,
          ),
          duration: Duration(milliseconds: 800),
        ),
      );
    }
  }
}
