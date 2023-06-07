import 'package:carpex_stok_takibi/widgets/cihaz_listesi.dart';
import 'package:flutter/material.dart';

import '../constants/constants.dart';

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
      backgroundColor: Colors.grey,
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
                  'Seçilen Müşteri: ${widget.selectedCustomer}',
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
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(170, 45),
                      ),
                      child: Text("Qr Okut")),
                  ElevatedButton(
                      onPressed: () {},
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
}
