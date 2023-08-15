import 'dart:convert';

import 'package:carpex_stok_takibi/constants/fonts.dart';
import 'package:carpex_stok_takibi/page/rerturn/device_list_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/constants.dart';
import '../../controller/mainController.dart';
import '../../utils/on_wii_pop.dart';

import 'package:http/http.dart' as http;

import '../dispatch/login_page.dart';

class SentDevicesList extends StatefulWidget {
  const SentDevicesList({super.key});

  @override
  State<SentDevicesList> createState() => _SentDevicesListState();
}

class _SentDevicesListState extends State<SentDevicesList> {
// appbardan + butonuyla bu sayfaya gelir

  var selectedDevice;
  var gonderilmisCihazlar = [];
  var newGonderilmisCihazlar = [];
  bool isFirstLoading = false;

  final controller = Get.put(MainController());

  SharedPreferences? prefs;
  void getCustomersApi() async {
    setState(() {
      //müşteri listesi yüklenirkenki indicator
      isFirstLoading = true;
    });
    prefs = await SharedPreferences.getInstance();
    try {
      String username = controller.usernameController.value.toString();

      String basicAuth =
          'Basic ${base64.encode(utf8.encode('${controller.usernameController.value.toString()}:${controller.passwordController.value.toString()}'))}';
      http.Response response = await http.get(
          Uri.parse(
              "http://95.70.201.96:39050/api/customers/${username.split('@').last.trim()}/children/"),
          headers: <String, String>{'authorization': basicAuth});

      if (response.statusCode == 200) {
        var abc = jsonDecode(utf8.decode(response.bodyBytes));
        for (var i = 0; i < response.body.length; i++) {
          gonderilmisCihazlar.add({
            "value": abc[i]['name'].toString(),
            "id": abc[i]['id'].toString()
          });
          newGonderilmisCihazlar = gonderilmisCihazlar;
        }
      } else {
        print('başarısızmain');
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

  @override
  void initState() {
    super.initState();
    getCustomersApi();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController searchController = TextEditingController();

    Future<bool> showExitPopupHandle() => showExitPopup(context);

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
                                      child: const Text("Devam Et"),
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

  void handleItemSelected(selectedItem) {
    setState(() {
      selectedDevice = selectedItem;
    });
    print('Seçilen öğe: $selectedItem');
  }

//!api gelince düzenlenecek
  //Müşterileri getiren API
  void navigateToDeviceListPage() {
    if (selectedDevice != null) {
      print("AAAAAAAAAAAAAAAA1 : ${selectedDevice['id'].toString()}");
      print("AAAAAAAAAAAAAAAA2 : ${selectedDevice['value'].toString()}");
      Constants.musteri = selectedDevice['id'].toString();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => DeviceListPage(
                    selectedCustomer: selectedDevice['value'].toString(),
                  )),
          (Route<dynamic> route) => false);
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Cihaz Seçimi Yapmadınız.'),
          content: const Text('Geri dönmek istiyor musunuz?'),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, elevation: 0),
              onPressed: () => Navigator.of(context).pop(false),
              //return false when click on "NO"
              child: Text(
                'Hayır',
                style: TextStyle(color: Color.fromARGB(194, 0, 0, 0)),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(43, 114, 176, 1),
              ),
              onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) =>
                        DeviceListPage(selectedCustomer: Constants.musteri),
                  ),
                  (route) => false),
              //return true when click on "Yes"
              child: Text('Evet, Geri dön'),
            ),
          ],
        ),
      );
    }
  }
}
