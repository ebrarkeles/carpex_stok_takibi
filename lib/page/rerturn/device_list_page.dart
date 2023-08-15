import 'package:carpex_stok_takibi/constants/fonts.dart';
import 'package:carpex_stok_takibi/page/rerturn/customer_choose_page.dart';
import 'package:carpex_stok_takibi/page/rerturn/return_qr_scan_page.dart';
import 'package:carpex_stok_takibi/page/rerturn/widgets/return_device_list.dart';
import 'package:carpex_stok_takibi/page/rerturn/gonderilmis_cihaz_list_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/constants.dart';
import '../../constants/utils/on_wii_pop.dart';

class DeviceListPage extends StatefulWidget {
  final String selectedCustomer;

  const DeviceListPage({super.key, required this.selectedCustomer});

  @override
  State<DeviceListPage> createState() => _DeviceListPageState();
}

class _DeviceListPageState extends State<DeviceListPage> {
  //EXIT POP UP   ------------------------------------------------------------*/
  Future<bool> showExitPopupHandle() => showExitPopup(context);
/*----------------------------------------------------------------------------*/

  //SEND   ------------------------------------------------------------*/

  void sendDevicesApi() async {
    // Navigator.of(context).pop();
    // setState(() {
    //   sendCircularIsActive = true;
    // });
    // prefs = await SharedPreferences.getInstance();
    // print('prefs.get("username") ${prefs!.get("username")}');
    // print('prefs.get("password") ${prefs!.get("password")}');
    // var listem = [];
    // for (var i = 0; i < Constants.tumEklenenCihazlar.length; i++) {
    //   print(Constants.tumEklenenCihazlar[i].cihazKodu);
    //   listem.add(
    //       "CRP-${Constants.tumEklenenCihazlar[i].cihazKodu.toString().replaceAll(" ", '')}"
    //           .toString()
    //           .toUpperCase());
    // }

    // var body = {
    //   "username": prefs!.get("username").toString(),
    //   "buyer_id": Constants.musteri.toString(),
    //   "devices": listem
    // };
    // print("body1 : $body");
    // print("body2 : ${json.encode(body)}");
    // try {
    //   String basicAuth =
    //       'Basic ${base64.encode(utf8.encode('${prefs!.get("username").toString()}:${prefs!.get("password").toString()}'))}';
    //   print(basicAuth);

    //   http.Response response = await http.post(
    //       Uri.parse("http://95.70.201.96:39050/api/device-transaction/"),
    //       body: json.encode(body),
    //       headers: <String, String>{
    //         'authorization': basicAuth,
    //         'Content-Type': 'application/json; charset=UTF-8',
    //       });

    //   print("11111111111 ${response.body}");
    // if (response.statusCode == 200) {
    //   print("2222222222 ${response.body}");
    // Navigator.pushAndRemoveUntil(
    //   context,
    //   MaterialPageRoute(
    //       builder: (BuildContext context) => const FinishPage()),
    //   (Route<dynamic> route) => false,
    // );
    // } else {
    //   print('başarısızqr');
    // setState(() {
    //   sendCircularIsActive = false;
    // });
    //     ScaffoldMessenger.of(context).hideCurrentSnackBar();
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(
    //         content: const Text(
    //           'Cihaz gönderme başarısız!',
    //           style: TextStyle(fontSize: 18),
    //         ),
    //         backgroundColor: Colors.red,
    //         behavior: SnackBarBehavior.floating,
    //         margin: EdgeInsets.only(
    //           bottom: MediaQuery.of(context).size.height - 85,
    //         ),
    //         duration: const Duration(milliseconds: 800),
    //       ),
    //     );
    //   }
    // } catch (e) {
    //   print(e.toString());
    //   setState(() {
    //     sendCircularIsActive = false;
    //   });
    // }
  }

/*----------------------------------------------------------------------------*/

  SharedPreferences? prefs;
  TextEditingController searchController = TextEditingController();
  bool sendCircularIsActive = false;
  @override
  void initState() {
    super.initState();
    searchController.text = Constants.musteri.toString();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: showExitPopupHandle,
      child: Scaffold(
        backgroundColor: Constants.backgroundColor,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Constants.themeColor,
          title: const Text(
            "İade Cihaz Listesi",
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
                    builder: (BuildContext context) => const MusteriSec()),
                (Route<dynamic> route) => false,
              );
            },
            icon: const Icon(
              Icons.arrow_back_rounded,
            ),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 2.0.wp),
              child: IconButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SentDevicesList(),
                      ),
                      (route) => false);
                },
                icon: const Icon(Icons.playlist_add_rounded),
              ),
            )
          ],
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
                        const ReturnDeviceList(),
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
                                              builder: (BuildContext context) =>
                                                  const ReturnQrScanPage()),
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
                                            margin:
                                                const EdgeInsets.only(left: 6),
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
                                            margin:
                                                const EdgeInsets.only(right: 6),
                                            child: const Text("İade Et ")),
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


/* Expanded(
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
                itemCount: tumQrEklenenCihazlar.length,
                itemBuilder: (BuildContext context, int index) {
                  Cihaz cihaz = tumQrEklenenCihazlar[index];
                  return Card(
                    borderOnForeground: true,
                    child: ListTile(
                      title: Text(
                        '${index + 1}.  CRP-${cihaz.cihazKodu.replaceAll(' ', '')}'
                            .toString(),
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
    ); */