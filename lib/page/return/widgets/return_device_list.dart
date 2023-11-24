// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../constants/constants.dart';
import '../../../constants/data_helper.dart';
import '../../../controller/mainController.dart';

class ReturnDeviceList extends StatefulWidget {
  const ReturnDeviceList({super.key});

  @override
  State<ReturnDeviceList> createState() => _ReturnDeviceListState();
}

class _ReturnDeviceListState extends State<ReturnDeviceList> {
  List<Cihaz> tumIadeEklenenCihazlar = Constants.iadeCihazListesi;

  void removeDevice(Cihaz cihaz) {
    setState(() {
      tumIadeEklenenCihazlar.remove(cihaz);
    });
    // print("tumIadeEklenenCihazlar : $tumIadeEklenenCihazlar");
    // print("Constants.iadeCihazListesi : ${Constants.iadeCihazListesi}");

    // print(tumIadeEklenenCihazlar);
    // print(Constants.iadeCihazListesi);
  }

/*----------------------------------------------------------------------------*/
//TODOs                          CONTROLLER                                   */
/*----------------------------------------------------------------------------*/

  final controller = Get.put(MainController());

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          SizedBox(
            height: 35,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Cihaz Listesi",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "${Constants.iadeCihazListesi.length}  cihaz eklendi",
                  style: const TextStyle(color: Colors.black54),
                ),
              ],
            ),
          ),
          Expanded(
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
              child: tumIadeEklenenCihazlar.isEmpty
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
                          "İade edilecek cihaz yok.",
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
                      itemCount: tumIadeEklenenCihazlar.length,
                      itemBuilder: (BuildContext context, int index) {
                        Cihaz cihaz = tumIadeEklenenCihazlar[index];
                        return Card(
                          borderOnForeground: true,
                          child: ListTile(
                            title: Text(
                              '${index + 1}.  ${cihaz.cihazKodu.toString().replaceAll(' ', '')}'.toString(),
                              style: const TextStyle(letterSpacing: 0.90),
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.delete, color: Colors.red[900]?.withOpacity(0.6)),
                              onPressed: () {
                                showDeleteConfirmationDialog(cihaz);
                              },
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  void showDeleteConfirmationDialog(Cihaz cihaz) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Cihazı Sil'),
          content: Text('${cihaz.cihazKodu} kodlu cihazı silmek istediğinize emin misiniz?'),
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
                Get.back(); // İletişim kutusunu kapat
              },
              child: const Text('Sil'),
            ),
          ],
        );
      },
    );
  }
}
