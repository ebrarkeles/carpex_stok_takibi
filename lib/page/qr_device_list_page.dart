import 'package:carpex_stok_takibi/page/finish_page.dart';
import 'package:carpex_stok_takibi/page/okutma_sayfasi.dart';
import 'package:carpex_stok_takibi/widgets/cihaz_listesi.dart';
import 'package:flutter/material.dart';

import '../constants/constants.dart';
import '../constants/data_helpar.dart';

class QrDeviceListPage extends StatefulWidget {
  final String selectedCustomer;
  const QrDeviceListPage({super.key, required this.selectedCustomer});

  @override
  State<QrDeviceListPage> createState() => _QrDeviceListPageState();
}

class _QrDeviceListPageState extends State<QrDeviceListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Text(
                  'Seçilen Müşteri: ${Constants.musteri.toString()}',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            const SizedBox(height: 40),
            Expanded(child: Qr_List()),
            // SizedBox(height: 600),
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 20),
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
                                    QrScanPage()),
                            (Route<dynamic> route) => false);
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(170, 45),
                      ),
                      child: Text("Qr Okut")),
                  ElevatedButton(
                      onPressed: () {
                        _showConfirmationDialog();
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[400],
                          minimumSize: Size(170, 45)),
                      child: Text("Gönder")),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _showConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
              '${Constants.tumEklenenCihazlar.length} cihaz ${Constants.musteri} firmasına gönderilecek!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('İşlemi gerçekleştirmek istediğinizden emin misiniz?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Hayır'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Evet'),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => FinishPage()),
                    (Route<dynamic> route) => false);
              },
            ),
          ],
        );
      },
    );
  }
}
