// ignore_for_file: prefer_interpolation_to_compose_strings, avoid_print, unnecessary_brace_in_string_interps, avoid_unnecessary_containers, use_build_context_synchronously, avoid_init_to_null

import 'dart:convert';

import 'package:carpex_stok_takibi/constants/constants.dart';
import 'package:carpex_stok_takibi/page/login_page.dart';
import 'package:carpex_stok_takibi/page/qr_device_list_page.dart';
import 'package:carpex_stok_takibi/utils/on_wii_pop.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Carpex Stok Takibi',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Constants.getSplashScreen,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedCustomer = null;
  var result = '';
  var musteriler = [];
  var newMusteriler = [];
  bool isFirstLoading = false;

  SharedPreferences? prefs;
  void getCustomersApi() async {
    setState(() {
      //müşteri listesi yüklenirkenki indicator
      isFirstLoading = true;
    });
    prefs = await SharedPreferences.getInstance();
    try {
      String username = prefs!.get("username").toString();

      String basicAuth = 'Basic ' +
          base64.encode(utf8.encode(
              '${prefs!.get("username").toString()}:${prefs!.get("password").toString()}'));
      http.Response response = await http.get(
          Uri.parse(
              "http://95.70.201.96:39050/api/customers/${username.split('@').last.trim()}/children/"),
          headers: <String, String>{'authorization': basicAuth});

      if (response.statusCode == 200) {
        var abc = jsonDecode(utf8.decode(response.bodyBytes));
        for (var i = 0; i < response.body.length; i++) {
          musteriler.add({
            "value": abc[i]['name'].toString(),
            "id": abc[i]['id'].toString()
          });
          newMusteriler = musteriler;
        }
      } else {
        print('başarısız');
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

  //Müşterileri getiren API
  void navigateToDeviceListPage() {
    if (selectedCustomer != null) {
      print("AAAAAAAAAAAAAAAA1 : ${selectedCustomer['id'].toString()}");
      print("AAAAAAAAAAAAAAAA2 : ${selectedCustomer['value'].toString()}");
      Constants.musteri = selectedCustomer['id'].toString();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => QrDeviceListPage(
                    selectedCustomer: selectedCustomer['value'].toString(),
                  )),
          (Route<dynamic> route) => false);
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Uyarı'),
          content: const Text('Müşteri seçimi yapmadınız!'),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(43, 114, 176, 1),
              ),
              onPressed: () => Navigator.pop(context),
              //return true when click on "Yes"
              child: const Text('Tamam'),
            ),
          ],
        ),
      );
    }
  }

  searchValue(String query) {
    final filteredValues = musteriler.where((element) {
      final value = element['value'].toString().toLowerCase();
      return value.contains(query.toLowerCase());
    }).toList();
    setState(() {
      newMusteriler = filteredValues;
    });
  }

  TextEditingController searchController = TextEditingController();
  Future<bool> showExitPopupHandle() => showExitPopup(context);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: showExitPopupHandle,
        child: Scaffold(
          backgroundColor: Constants.backgroundColor,
          body: Column(
            children: [
              Container(
                color: Constants.themeColor,
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          height: 60,
                          child: const Text("Müşteri Seç",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold)),
                        ),
                        Positioned(
                          left: MediaQuery.of(context).size.width / 2 - 30,
                          child: Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,
                            height: 60,
                            child: IconButton(
                                onPressed: () {
                                  showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text("Carpex Cihaz Sevk"),
                                      content: const Text(
                                          "Oturumdan çıkış yapmak istiyor musunuz?"),
                                      actions: [
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.white,
                                              elevation: 0),
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                          child: const Text(
                                            'Hayır',
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    194, 0, 0, 0)),
                                          ),
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      255, 255, 60, 60)),
                                          onPressed: () {
                                            Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const LoginPage()),
                                              (route) => false,
                                            );
                                            // prefs!.clear();
                                          },
                                          child: const Text('Evet, Çıkış yap'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  Icons.exit_to_app_outlined,
                                  color: Colors.white,
                                )),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 55,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: TextFormField(
                        style: const TextStyle(fontSize: 16),
                        controller: searchController,
                        onChanged: searchValue,
                        decoration: const InputDecoration(
                          floatingLabelAlignment: FloatingLabelAlignment.center,
                          contentPadding: EdgeInsets.only(top: 16),
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
                  ],
                ),
              ),
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: newMusteriler.isEmpty
                          ? const Center(
                              child: Text("Müşteri bulunamadı"),
                            )
                          : ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              itemCount: newMusteriler.length,
                              itemBuilder: (context, index) {
                                final item = newMusteriler[index];
                                print("item ${item}");
                                if (selectedCustomer != null &&
                                    selectedCustomer['value'].toString() ==
                                        item['value'].toString()) {
                                  return Card(
                                    margin: const EdgeInsets.only(bottom: 5),
                                    child: ListTile(
                                        title: Text(
                                          item['value'],
                                          style: const TextStyle(fontSize: 13),
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
                                    margin: const EdgeInsets.only(bottom: 5),
                                    child: ListTile(
                                      title: Text(
                                        item['value'],
                                        style: const TextStyle(fontSize: 13),
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
                                    margin: const EdgeInsets.only(right: 5),
                                    child: const Text("Cihaz Ekle")),
                                const Icon(
                                  Icons.add,
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
        ),
      ),
    );
  }

  void handleItemSelected(selectedItem) {
    setState(() {
      selectedCustomer = selectedItem;
    });
    print('Seçilen öğe: $selectedItem');
  }
}
