// ignore_for_file: camel_case_types

import 'package:carpex_stok_takibi/constants/constants.dart';
import 'package:carpex_stok_takibi/constants/data_helpar.dart';
import 'package:flutter/material.dart';

class Qr_List extends StatefulWidget {
  const Qr_List({super.key});

  @override
  State<Qr_List> createState() => _Qr_ListState();
}

class _Qr_ListState extends State<Qr_List> {
  List<Cihaz> tumQrEklenenCihazlar = Constants.tumEklenenCihazlar;

  void removeDevice(Cihaz cihaz) {
    setState(() {
      tumQrEklenenCihazlar.remove(cihaz);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (tumQrEklenenCihazlar.isNotEmpty) {
      return ListView.builder(
        itemCount: tumQrEklenenCihazlar.length,
        itemBuilder: (context, index) {
          Cihaz cihaz = tumQrEklenenCihazlar[index];
          return ListTile(
            title: Text('CRP-${cihaz.cihazKodu}'),
            trailing: IconButton(
              icon:
                  Icon(Icons.delete, color: Colors.red[900]?.withOpacity(0.6)),
              onPressed: () {
                showDeleteConfirmationDialog(cihaz);
              },
            ),
          );
        },
      );
    } else {
      return Center(child: Text("Liste Boş"));
    }
  }

  void showDeleteConfirmationDialog(Cihaz cihaz) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Cihazı Sil'),
          content: Text(
              'CRP-${cihaz.cihazKodu} kodlu cihazı silmek istediğinize emin misiniz?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // İletişim kutusunu kapat
              },
              child: Text('İptal'),
            ),
            TextButton(
              onPressed: () {
                removeDevice(cihaz); // Cihazı listeden sil
                Navigator.pop(context); // İletişim kutusunu kapat
              },
              child: Text('Sil'),
            ),
          ],
        );
      },
    );
  }
}
