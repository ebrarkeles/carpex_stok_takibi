// ignore_for_file: library_private_types_in_public_api

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
      setState(() {
        scanningSuccessful = true;
        scannedDevice = scanData.code!;
      });
    });
  }

  void _onAddToMyList(bool shouldAdd) {
    if (shouldAdd) {
      // Eklemek istediğiniz listeye cihazı ekleyin
    }
    setState(() {
      scanningSuccessful = false;
      scannedDevice = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Scanner'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
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
              padding: const EdgeInsets.only(
                  top: 20, bottom: 20, left: 35, right: 25),
              child: Row(
                children: [
                  const Text('Okunan cihaz:',
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54)),
                  SizedBox(width: 50),
                  Text(
                    "$scannedDevice",
                    style: const TextStyle(
                      fontSize: 23,
                    ),
                  )
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(left: 15, bottom: 50, right: 15),
                child: ButtonBar(
                  alignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Constants.themeColor.withOpacity(0.6),
                            minimumSize: const Size(150, 40)),
                        onPressed: () {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      QrDeviceListPage(
                                          selectedCustomer: Constants.musteri)),
                              (Route<dynamic> route) => false);
                        },
                        child: const Text("Listeye Dön")),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(150, 40),
                        backgroundColor: Colors.green[400],
                      ),
                      onPressed: () {
                        if (scannedDevice.isNotEmpty) {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      /* floatingActionButton: scanningSuccessful ? FloatingActionButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Cihaz Ekle'),
                      content: Text('Okunan cihaz: $scannedDevice'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            _onAddToMyList(false);
                          },
                          child: const Text('Hayır'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            _onAddToMyList(true);
                          },
                          child: const Text('Evet'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Icon(Icons.check),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,*/
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
            content: const Text('Cihaz zaten eklenmiş, tekrar eklenemez!'),
            backgroundColor: Colors.red[900]?.withOpacity(0.6)),
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
            content: const Text('Cihaz listeye eklendi!'),
            backgroundColor: Colors.green[600]?.withOpacity(0.6)),
      );
    }
  }
}
