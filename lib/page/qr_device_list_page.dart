// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:convert';

import 'package:carpex_stok_takibi/main.dart';
import 'package:carpex_stok_takibi/page/finish_page.dart';
import 'package:carpex_stok_takibi/utils/on_wii_pop.dart';
import 'package:carpex_stok_takibi/widgets/cihaz_listesi.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/constants.dart';
import 'okutma_sayfasi.dart';
import 'package:http/http.dart' as http;

class QrDeviceListPage extends StatefulWidget {
  final String selectedCustomer;
  const QrDeviceListPage({super.key, required this.selectedCustomer});

  @override
  State<QrDeviceListPage> createState() => _QrDeviceListPageState();
}

class _QrDeviceListPageState extends State<QrDeviceListPage> {
  SharedPreferences? prefs;
  TextEditingController searchController = TextEditingController();
  bool sendCircularIsActive = false;
  @override
  void initState() {
    super.initState();
    searchController.text = Constants.musteri.toString();
  }

  void sendDevicesApi() async {
    Navigator.of(context).pop();
    setState(() {
      sendCircularIsActive = true;
    });
    prefs = await SharedPreferences.getInstance();
    print('prefs.get("username") ${prefs!.get("username")}');
    print('prefs.get("password") ${prefs!.get("password")}');
    var listem = [];
    for (var i = 0; i < Constants.tumEklenenCihazlar.length; i++) {
      print(Constants.tumEklenenCihazlar[i].cihazKodu);
      listem.add(
          "CRP-${Constants.tumEklenenCihazlar[i].cihazKodu.toString().replaceAll(" ", '')}"
              .toString()
              .toUpperCase());
    }

    var body = {
      "username": prefs!.get("username").toString(),
      "buyer_id": Constants.musteri.toString(),
      "devices": listem
    };
    print("body1 : $body");
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
        print('başarısızqr');
        setState(() {
          sendCircularIsActive = false;
        });
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
            duration: const Duration(milliseconds: 800),
          ),
        );
      }
    } catch (e) {
      print(e.toString());
      setState(() {
        sendCircularIsActive = false;
      });
    }
  }

  final scrollController = ScrollController();

  Future<bool> showExitPopupHandle() => showExitPopup(context);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: showExitPopupHandle,
        child: Scaffold(
          backgroundColor: Constants.backgroundColor,
          appBar: AppBar(
            centerTitle: true,
            elevation: 0,
            backgroundColor: Constants.themeColor,
            title: const Text(
              "Cihaz Listesi",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            leading: IconButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => const MyHomePage()),
                  (Route<dynamic> route) => false,
                );
              },
              icon: const Icon(
                Icons.arrow_back_rounded,
              ),
            ),
          ),
          body: Stack(
            children: [
              Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.center,
                    height: 55,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 6,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                      controller: searchController,
                      decoration: const InputDecoration(
                        floatingLabelAlignment: FloatingLabelAlignment.center,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white70,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          right: 15, left: 15, top: 8, bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                  "${Constants.tumEklenenCihazlar.length.toString()} cihaz eklendi",
                                  style: const TextStyle(color: Colors.black54),
                                ),
                              ],
                            ),
                          ),
                          const Qr_List(),
                          Container(
                            margin: const EdgeInsets.only(top: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: 50,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green[400],
                                      ),
                                      onPressed: () {
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        const QRScannerPage()),
                                            (Route<dynamic> route) => false);
                                      },
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                              Icons.qr_code_scanner_rounded),
                                          Container(
                                              margin: const EdgeInsets.only(
                                                  left: 6),
                                              child: const Text("Qr Okut")),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: SizedBox(
                                    height: 50,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        _showConfirmationDialog();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Constants.themeColor,
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                              margin: const EdgeInsets.only(
                                                  right: 6),
                                              child: const Text("Gönder")),
                                          const Icon(Icons.send_rounded),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              sendCircularIsActive == true
                  ? Container(
                      color: Colors.white54,
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(),
                    )
                  : const SizedBox(),
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
            title: const Text('Cihaz Gönderme Onayı'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                      '${Constants.tumEklenenCihazlar.length} cihaz ${Constants.musteri} firmasına gönderilecek!'),
                ],
              ),
            ),
            actions: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      elevation: 0,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text(
                      'Vazgeç',
                      style: TextStyle(color: Color.fromARGB(194, 0, 0, 0)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Constants.themeColor,
                    ),
                    onPressed: () => sendDevicesApi(),
                    //return true when click on "Yes"
                    child: SizedBox(
                      width: 100,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 6),
                            child: const Text("Gönder"),
                          ),
                          const Icon(Icons.send_rounded),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          );
        },
      );
    }
  }
}
