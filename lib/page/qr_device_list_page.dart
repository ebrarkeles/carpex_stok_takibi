// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:carpex_stok_takibi/main.dart';
import 'package:carpex_stok_takibi/page/finish_page.dart';
import 'package:carpex_stok_takibi/widgets/cihaz_listesi.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/constants.dart';
import 'okutma_sayfasi_güncel.dart';
import 'package:http/http.dart' as http;

class QrDeviceListPage extends StatefulWidget {
  final String selectedCustomer;
  const QrDeviceListPage({super.key, required this.selectedCustomer});

  @override
  State<QrDeviceListPage> createState() => _QrDeviceListPageState();
}

class _QrDeviceListPageState extends State<QrDeviceListPage> {
  SharedPreferences? prefs;
  void sendDevicesApi() async {
    prefs = await SharedPreferences.getInstance();
    print('prefs.get("username") ${prefs!.get("username")}');
    print('prefs.get("password") ${prefs!.get("password")}');
    var listem = [];
    for (var i = 0; i < Constants.tumEklenenCihazlar.length; i++) {
      print(Constants.tumEklenenCihazlar[i].cihazKodu);
      listem.add(
          "CRP-${Constants.tumEklenenCihazlar[i].cihazKodu.toString().replaceAll(" ", '')}"
              .toString());
    }

    var body = {
      "username": prefs!.get("username").toString(),
      "buyer_id": Constants.musteri.toString(),
      "devices": listem
    };
    print("body1 : ${body}");
    print("body2 : ${json.encode(body)}");
    try {
      String basicAuth =
          'Basic ${base64.encode(utf8.encode('${prefs!.get("username").toString()}:${prefs!.get("password").toString()}'))}';
      print(basicAuth);

      http.Response response = await http.post(
          Uri.parse("http://95.70.201.96:39050/api/device-transaction/"),
          body: json.encode(body),
          headers: <String, String>{
            'authorization': basicAuth,
            'Content-Type': 'application/json; charset=UTF-8',
          });

      print("11111111111 ${response.body}");

      if (response.statusCode == 200) {
        print("2222222222 ${response.body}");
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => const FinishPage()),
          (Route<dynamic> route) => false,
        );
      } else {
        print('başarısız');
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Cihaz gönderme başarısız!',
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
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          backgroundColor: Constants.themeColor,
          title: const Text('Cihaz Listesi'),
          leading: IconButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => const MyHomePage()),
                (Route<dynamic> route) => false,
              );
            },
            icon: Icon(
              Icons.arrow_back_rounded,
            ),
          ),
        ),
        body: Padding(
          padding:
              const EdgeInsets.only(right: 40, left: 40, top: 16, bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                margin: EdgeInsets.only(top: 10, bottom: 20),
                child: Row(
                  children: [
                    const Text('Müşteri:',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                            color: Colors.black)),
                    const SizedBox(width: 15),
                    Text(
                      Constants.musteri.toString(),
                      style: const TextStyle(
                          fontSize: 23, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Qr_List(),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 100,
                      height: 40,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Constants.themeColor),
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      const QRScannerPage()),
                              (Route<dynamic> route) => false);
                        },
                        child: const Text("Qr Okut"),
                      ),
                    ),
                    const SizedBox(width: 20),
                    SizedBox(
                      width: 100,
                      height: 40,
                      child: ElevatedButton(
                          onPressed: () {
                            _showConfirmationDialog();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[400],
                          ),
                          child: const Text("Gönder")),
                    ),
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
                  sendDevicesApi();
                },
              ),
            ],
          );
        },
      );
    }
  }
}
