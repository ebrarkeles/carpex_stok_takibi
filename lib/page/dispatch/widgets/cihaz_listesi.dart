// ignore_for_file: camel_case_types, avoid_print

import 'package:carpex_stok_takibi/constants/constants.dart';
import 'package:carpex_stok_takibi/constants/data_helpar.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

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
      tumQrEklenenCihazlar = Constants.tumEklenenCihazlar;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0xffDDDDDD),
              blurRadius: 6.0,
              spreadRadius: 2.0,
              offset: Offset(0.0, 0.0),
            )
          ],
        ),
        child: tumQrEklenenCihazlar.isEmpty
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: Lottie.asset(
                      'assets/lottie/not_found_device_list.json',
                    ),
                  ),
                  const SizedBox(height: 0),
                  const Text(
                    "Gösterilecek cihaz yok.",
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 13,
                      color: Color.fromRGBO(43, 114, 176, 1),
                    ),
                  ),
                ],
              )
            : ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: tumQrEklenenCihazlar.length,
                itemBuilder: (BuildContext context, int index) {
                  Cihaz cihaz = tumQrEklenenCihazlar[index];
                  var cihazim = cihaz.cihazKodu
                      .replaceAll(' ', '')
                      .toUpperCase()
                      .toString();
                  if (!cihazim.startsWith("CRP-")) {
                    cihazim = "CRP-$cihazim";
                    print("cihaz kodunda CRP- bulunmuyordu eklendi.");
                  } else {
                    print("cihaz kodunda CRP- bulunuyor eklenmeyecek.");
                  }
                  return Card(
                    borderOnForeground: true,
                    child: ListTile(
                      title: Text(
                        '${index + 1}.  $cihazim',
                        style: const TextStyle(letterSpacing: 0.90),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete,
                            color: Colors.red[900]?.withOpacity(0.6)),
                        onPressed: () {
                          showDeleteConfirmationDialog(cihaz);
                        },
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  void showDeleteConfirmationDialog(Cihaz cihaz) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Cihazı Sil'),
          content: Text(
              'CRP-${cihaz.cihazKodu} kodlu cihazı silmek istediğinize emin misiniz?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // İletişim kutusunu kapat
              },
              child: const Text('İptal'),
            ),
            TextButton(
              onPressed: () {
                removeDevice(cihaz); // Cihazı listeden sil
                Navigator.pop(context); // İletişim kutusunu kapat
              },
              child: const Text('Sil'),
            ),
          ],
        );
      },
    );
  }
}


/*
return Padding(
        padding: const EdgeInsets.all(40),
        child: Container(
          width: 350,
          height: 480,
          color: Colors.white,
          child: Column(
            children: [
              SizedBox(),
              ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: tumQrEklenenCihazlar.length,
                itemBuilder: (context, index) {
                  Cihaz cihaz = tumQrEklenenCihazlar[index];
                  return Card(
                    child: ListTile(
                      title: Text('CRP-${cihaz.cihazKodu}'),
                      trailing: IconButton(
                        icon: Icon(Icons.delete,
                            color: Colors.red[900]?.withOpacity(0.6)),
                        onPressed: () {
                          showDeleteConfirmationDialog(cihaz);
                        },
                      ),
                    ),
                  );
                },
              ),
              Container(),
            ],
          ),
        ),
      );
      */