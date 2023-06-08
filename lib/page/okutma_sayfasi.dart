// ignore_for_file: library_private_types_in_public_api

import 'package:carpex_stok_takibi/constants/constants.dart';
import 'package:carpex_stok_takibi/page/qr_device_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import '../constants/data_helpar.dart';

class QrScanPage extends StatefulWidget {
  const QrScanPage({Key? key}) : super(key: key);

  @override
  _QrScanPageState createState() => _QrScanPageState();
}

class _QrScanPageState extends State<QrScanPage> {
  String scannedCode = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('QR Okut'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(50),
            child: Column(
              children: [
                Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        const Text(
                          'Taranan Kod:',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 35),
                        Text(
                          "$scannedCode",
                          style: TextStyle(fontSize: 26, color: Colors.black),
                        ),
                      ],
                    )),
                SizedBox(height: 25),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Constants.themeColor.withOpacity(0.6)),
                    onPressed: () {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      _scanQRCode();
                    },
                    child: const Text('QR Kodu Tara'),
                  ),
                ),
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
                          minimumSize: Size(150, 40)),
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
                      child: Text("Listeye Dön")),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(150, 40),
                      backgroundColor: Colors.green[400],
                    ),
                    onPressed: () {
                      if (scannedCode.isNotEmpty) {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        _addDeviceToCihazlar(scannedCode);
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
    );
  }

  Future<void> _scanQRCode() async {
    String? scanResult = await FlutterBarcodeScanner.scanBarcode(
      '#ff6666', // Tara düğmesi rengi
      'İptal', // İptal düğmesi metni
      true, // Kamera flaşı açılsın mı?
      ScanMode.QR, // Sadece QR kodlarını tara
    );

    if (scanResult != null && scanResult != '-1') {
      setState(() {
        scannedCode = scanResult;
      });
    }
  }

  void _addDeviceToCihazlar(String deviceCode) {
    // Kontrol ett cihazın var mı
    bool isDeviceExists = Constants.tumEklenenCihazlar
        .any((cihaz) => cihaz.cihazKodu == deviceCode);

    if (isDeviceExists) {
      // Cihaz zaten var uyarı snacki göster
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Cihaz zaten eklenmiş, tekrar eklenemez!'),
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
            content: Text('Cihaz listeye eklendi!'),
            backgroundColor: Colors.green[600]?.withOpacity(0.6)),
      );
    }
  }
}
