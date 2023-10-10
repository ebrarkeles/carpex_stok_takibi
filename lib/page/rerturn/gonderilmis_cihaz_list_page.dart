// ignore_for_file: prefer_typing_uninitialized_variables, avoid_print, use_build_context_synchronously, iterable_contains_unrelated_type

import 'dart:convert';

import 'package:carpex_stok_takibi/constants/fonts.dart';
import 'package:carpex_stok_takibi/page/rerturn/device_list_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/constants.dart';
import '../../constants/data_helpar.dart';
import '../../controller/mainController.dart';
import '../../constants/utils/on_wii_pop.dart';

import 'package:http/http.dart' as http;

import '../action_choose_page/login_page.dart';

class SentDevicesList extends StatefulWidget {
  const SentDevicesList({super.key});

  @override
  State<SentDevicesList> createState() => _SentDevicesListState();
}

class _SentDevicesListState extends State<SentDevicesList> {
// appbardan + butonuyla bu sayfaya gelir

/*----------------------------------------------------------------------------*/
//TODOs                               VARIABLES                               */
/*----------------------------------------------------------------------------*/

  var selectedDevice;
  var gonderilmisCihazlar = [];
  var newGonderilmisCihazlar = [];
  bool isFirstLoading = false;
  SharedPreferences? prefs;

/*----------------------------------------------------------------------------*/
//TODOs                          CONTROLLER                                   */
/*----------------------------------------------------------------------------*/

  final controller = Get.put(MainController());
  TextEditingController searchController = TextEditingController();

/*----------------------------------------------------------------------------*/
//TODOs                          GET DEVİCES API                              */
/*----------------------------------------------------------------------------*/

  void getDeviceListsApi() async {
    setState(() {
      //cihaz listesi yüklenirkenki indicator
      isFirstLoading = true;
    });
    prefs = await SharedPreferences.getInstance();
    try {
      String username = controller.usernameController.value.toString();
      String password = controller.passwordController.value.toString();

      String basicAuth =
          'Basic ${base64.encode(utf8.encode('$username:$password'))}';
      http.Response response = await http.post(
          Uri.parse("http://95.70.201.96:39050/api/device-list/"),
          headers: <String, String>{'authorization': basicAuth},
          body: {'tenant': username.split('@').last.trim()});

      print("response.body :  ${response.body}");
      //print("response.bodyBytes :  ${response.bodyBytes}");

      if (response.statusCode == 200) {
        var abc = jsonDecode(utf8.decode(response.bodyBytes));
        var devices = abc['devices'];
        print("devices:  $devices");

        print("abc  :  $abc");
        for (var i = 0; i < response.body.length; i++) {
          gonderilmisCihazlar.add({
            "value": abc['devices'][i]['device_id'].toString(),
            "id": abc['devices'][i]['owner_id'].toString()
          });
          print("gonderilmisCihazlar : $gonderilmisCihazlar");
          Constants.gonderilmisCihazList = gonderilmisCihazlar;
          newGonderilmisCihazlar = gonderilmisCihazlar;
        }
      } else {
        print('başarısız Gönderilmiş Cihaz Listesi');
        prefs!.clear();
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => const LoginPage(),
            ),
            (Route<dynamic> route) => false);
      }
    } catch (e) {
      print(e.toString());
    }
    setState(() {
      isFirstLoading = false;
    });
  }

/*----------------------------------------------------------------------------*/
//TODOs                            INIT                                       */
/*----------------------------------------------------------------------------*/

  @override
  void initState() {
    super.initState();
    getDeviceListsApi();
  }

/*----------------------------------------------------------------------------*/
//TODOs                         SECİLEN CİHAZ                                 */
/*----------------------------------------------------------------------------*/

  void handleItemSelected(selectedItem) {
    setState(() {
      selectedDevice = selectedItem;
    });
    print('Seçilen CİHAZ: $selectedItem');
  }

/*----------------------------------------------------------------------------*/
//TODOs              CHECK COSTUMER IS SELECTED FUNCTION                      */
/*----------------------------------------------------------------------------*/

//!api gelince düzenlenecek
  void navigateToDeviceListPage() {
    if (selectedDevice != null) {
      var cihazKodu = selectedDevice['value'];

      if (!cihazKodu.toString().startsWith("CRP-")) {
        cihazKodu = "CRP-$cihazKodu";
        print("cihaz kodunda CRP- bulunmuyordu eklendi.");
      } else {
        print("cihaz kodunda CRP- bulunuyor eklenmeyecek.");
      }

      cihazKodu = cihazKodu.toString().replaceAll(" ", "");

      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      final cihaz = Cihaz(cihazKodu); // Seçilen cihazı Cihaz nesnesine dönüştür

      print(
          "Constants.iadeCihazListesi.contains(cihaz.cihazKodu) : ${Constants.iadeCihazListesi.contains(cihaz.cihazKodu)}");
      continueAddDeviceList(selectedDevice['value']);

      print("cihazKodu: ${cihazKodu.toString()}");
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Uyarı'),
          content: const Text('Devam etmek için seçili cihaz kodu yok.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Tamam'),
            ),
          ],
        ),
      );
    }
  }

  void continueAddDeviceList(deviceCode) {
    bool isDeviceExists = Constants.iadeCihazListesi
        .any((cihaz) => cihaz.cihazKodu == deviceCode);
    print(" isDeviceExists :  $isDeviceExists");

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    if (isDeviceExists) {
      // Cihaz zaten var uyarı snacki göster
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Container(
            alignment: Alignment.center,
            height: 50,
            color: Colors.red,
            child: const Text(
              'Cihaz zaten ekli.',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
          backgroundColor: Colors.transparent,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height - 85,
          ),
          duration: const Duration(milliseconds: 800),
        ),
      );
    } else {
      // Cihaz yok yeni cihazı ekle
      Cihaz newDevice = Cihaz(deviceCode);

      setState(() {
        Constants.iadeCihazListesi.add(newDevice);
      });

      // EKLENDİ snacki göster
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Container(
            alignment: Alignment.center,
            height: 50,
            color: Colors.green,
            child: const Text(
              'Cihaz listeye eklendi',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
          backgroundColor: Colors.transparent,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height - 85,
          ),
          duration: const Duration(milliseconds: 800),
        ),
      );
    }
  }
/*----------------------------------------------------------------------------*/
//TODOs                          EXIT POP UP                                  */
/*----------------------------------------------------------------------------*/

  Future<bool> showExitPopupHandle() => showExitPopup(context);

/*----------------------------------------------------------------------------*/
//TODOs                            FILTER                                     */
/*----------------------------------------------------------------------------*/

  searchValue(String query) {
    print("gonderilmisCihazlar listesi  :   $gonderilmisCihazlar");

    final filteredValues = gonderilmisCihazlar.where((element) {
      final value = element['value'].toString().toLowerCase();
      return value.contains(query.toLowerCase());
    }).toList();
    setState(() {
      newGonderilmisCihazlar = filteredValues;
    });
  }

/*----------------------------------------------------------------------------*/
//TODOs                               BUILD                                   */
/*----------------------------------------------------------------------------*/

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
              "Firmaya Gönderilmiş Cihazlar",
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
                      builder: (BuildContext context) =>
                          DeviceListPage(selectedCustomer: Constants.musteri)),
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
                      // textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                      controller: searchController,
                      onChanged: searchValue,
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
                        prefixIcon: Icon(
                          Icons.search,
                        ),
                        prefixIconConstraints: BoxConstraints(
                          minHeight: 60,
                          minWidth: 50,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: newGonderilmisCihazlar.isEmpty
                              ? const Center(
                                  child: Text("Cihaz bulunamadı"),
                                )
                              : ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: newGonderilmisCihazlar.length,
                                  itemBuilder: (context, index) {
                                    final item = newGonderilmisCihazlar[index];
                                    print("item $item");
                                    if (selectedDevice != null &&
                                        selectedDevice['value'].toString() ==
                                            item['value'].toString()) {
                                      return Card(
                                        margin:
                                            const EdgeInsets.only(bottom: 5),
                                        child: ListTile(
                                            title: Text(
                                              item['value'],
                                              style:
                                                  const TextStyle(fontSize: 13),
                                            ),
                                            onTap: () {
                                              handleItemSelected(item);
                                            },
                                            trailing: const Icon(
                                              Icons.check,
                                              color: Colors.green,
                                            )),
                                      );
                                    } else {
                                      return Card(
                                        margin:
                                            const EdgeInsets.only(bottom: 5),
                                        child: ListTile(
                                          title: Text(
                                            item['value'],
                                            style:
                                                const TextStyle(fontSize: 13),
                                          ),
                                          onTap: () {
                                            handleItemSelected(item);
                                          },
                                        ),
                                      );
                                    }
                                  },
                                ),
                        ),
                        isFirstLoading == true
                            ? Container(
                                color: Colors.white,
                                alignment: Alignment.center,
                                child: const CircularProgressIndicator(),
                              )
                            : const SizedBox(),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 10, bottom: 10, left: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 50,
                            child: ElevatedButton(
                                onPressed: () {
                                  navigateToDeviceListPage();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Constants.themeColor,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(left: 4.0.wp),
                                      child: const Text("Cihazı Ekle"),
                                    ),
                                    SizedBox(
                                      width: 2.0.wp,
                                    ),
                                    const Icon(
                                      Icons.arrow_circle_right_outlined,
                                    )
                                  ],
                                )),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
