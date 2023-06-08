import 'package:carpex_stok_takibi/page/finish_page.dart';
import 'package:carpex_stok_takibi/widgets/cihaz_listesi.dart';
import 'package:flutter/material.dart';

import '../constants/constants.dart';
import 'okutma_sayfasi_güncel.dart';

class QrDeviceListPage extends StatefulWidget {
  final String selectedCustomer;
  const QrDeviceListPage({super.key, required this.selectedCustomer});

  @override
  State<QrDeviceListPage> createState() => _QrDeviceListPageState();
}

class _QrDeviceListPageState extends State<QrDeviceListPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          // backgroundColor: Constants.themeColor,
          title: const Text('Cihaz Listesi'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: 30, right: 30, left: 30, bottom: 40),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Row(
                    children: [
                      const Text('Müşteri:',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54)),
                      const SizedBox(width: 35),
                      Text(
                        Constants.musteri.toString(),
                        style: const TextStyle(
                          fontSize: 23,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Expanded(
                  child: Column(
                children: [
                  const Qr_List(),
                  Padding(
                    padding: const EdgeInsets.only(right: 20, left: 20),
                    child: Container(
                        color: Colors.white,
                        height: 50,
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              "${Constants.tumEklenenCihazlar.length.toString()} cihaz eklendi",
                              style: const TextStyle(color: Colors.black54),
                            ),
                          ),
                        )),
                  )
                ],
              )),
              // SizedBox(height: 600),
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 40),
                child: ButtonBar(
                  alignment: MainAxisAlignment.center,
                  buttonMinWidth: 200,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      const QRScannerPage()),
                              (Route<dynamic> route) => false);
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(170, 45),
                        ),
                        child: const Text("Qr Okut")),
                    ElevatedButton(
                        onPressed: () {
                          _showConfirmationDialog();
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[400],
                            minimumSize: const Size(170, 45)),
                        child: const Text("Gönder")),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showConfirmationDialog() async {
    if (Constants.tumEklenenCihazlar.isEmpty) {
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Cihaz Blunamadı'),
            content: const SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                      'Sevk edilecek bir cihaz bulunamadı. Lütfen önce cihaz ekleyiniz.'),
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
            title: Text(
                '${Constants.tumEklenenCihazlar.length} cihaz ${Constants.musteri} firmasına gönderilecek!'),
            content: const SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('İşlemi gerçekleştirmek istediğinizden emin misiniz?'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Hayır'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Evet'),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => const FinishPage()),
                    (Route<dynamic> route) => false,
                  );
                },
              ),
            ],
          );
        },
      );
    }
  }
}
