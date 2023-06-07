import 'package:carpex_stok_takibi/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import '../constants/data_helpar.dart';

class QrScanPage extends StatefulWidget {
  @override
  _QrScanPageState createState() => _QrScanPageState();
}

class _QrScanPageState extends State<QrScanPage> {
  String scannedCode = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Okut'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                _scanQRCode();
              },
              child: Text('QR Kodu Tara'),
            ),
            SizedBox(height: 16),
            Text('Taranan Kod: $scannedCode'),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (scannedCode.isNotEmpty) {
                  _addDeviceToCihazlar(scannedCode);
                }
              },
              child: Text('Cihazı Ekle'),
            ),
          ],
        ),
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
    Cihaz newDevice = Cihaz(cihazKodu: deviceCode);
    Constants.tumEklenenCihazlar.add(newDevice);
    // tumQrEklenenCihazlar listesini güncelleme işlemleri
  }
}