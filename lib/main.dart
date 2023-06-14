// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:convert';

import 'package:carpex_stok_takibi/constants/constants.dart';
import 'package:carpex_stok_takibi/page/qr_device_list_page.dart';
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
      //const LoginPage(),
      // builder: (context, childWidget) {
      //   final data = MediaQuery.of(context);
      //   return MediaQuery(
      //     data: data.copyWith(textScaleFactor: 1),
      //     child: childWidget,
      //   );
      // },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? selectedCustomer;
  var musteriler = [];

  SharedPreferences? prefs;
  void getCustomersApi() async {
    prefs = await SharedPreferences.getInstance();
    print('prefs.get("username") ${prefs!.get("username")}');
    print('prefs.get("password") ${prefs!.get("password")}');
    try {
      String basicAuth = 'Basic ' +
          base64.encode(utf8.encode(
              '${prefs!.get("username").toString()}:${prefs!.get("password").toString()}'));
      print(basicAuth);

      http.Response response = await http.get(
          Uri.parse("http://95.70.201.96:39050/api/customers/"),
          headers: <String, String>{'authorization': basicAuth});

      print("11111111111 ${response.body}");

      if (response.statusCode == 200) {
        print("2222222222 ${response.body}");
        var abc = jsonDecode(utf8.decode(response.bodyBytes));
        print("AAAAAAAAABBBBBBBBBBBCCC ${abc}");
        for (var i = 0; i < response.body.length; i++) {
          print("xxxxxxxxxxxxx1 : ${abc[i]}");
          print("xxxxxxxxxxxxx2 : ${abc[i]['name'].toString()}");
          musteriler.add({
            "value": abc[i]['name'].toString(),
            "id": abc[i]['id'].toString()
          });
        }
      } else {
        print('başarısız');
      }
    } catch (e) {
      print(e.toString());
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getCustomersApi();
  }

  void navigateToDeviceListPage() {
    if (selectedCustomer != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                QrDeviceListPage(selectedCustomer: selectedCustomer!),
          ));

      // Navigator.pushAndRemoveUntil(
      //     context,
      //     MaterialPageRoute(
      //         builder: (BuildContext context) =>
      //             QrDeviceListPage(selectedCustomer: selectedCustomer!)),
      //     (Route<dynamic> route) => false);
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Hata'),
          content: const Text('Müşteri seçimi yapmadınız!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tamam'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        body: Column(
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(30)),
              child: Container(
                height: 90,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  image: DecorationImage(
                      image: AssetImage("assets/images/carpex_koku_logo.png"),
                      alignment: Alignment.center),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(30),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 150,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 60),
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15)),
                                child: DropdownButton<String>(
                                  padding: EdgeInsets.all(9),
                                  iconEnabledColor: Colors.black,
                                  menuMaxHeight: 400,
                                  iconSize: 28,
                                  isExpanded: true,
                                  hint: const Padding(
                                    padding: EdgeInsets.all(6),
                                    child: Text(
                                      'Müşteri Seçiniz',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16),
                                    ),
                                  ),
                                  value: selectedCustomer,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      print("newValue : ${newValue}");
                                      selectedCustomer = newValue;
                                      Constants.musteri = newValue!;
                                    });
                                  },
                                  items: musteriler.map((customer) {
                                    return DropdownMenuItem<String>(
                                      value: customer['id'],
                                      child: Text(
                                        "    ${customer['value']}",
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 16),
                                      ),
                                    );
                                  }).toList(),
                                  dropdownColor: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 80),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // selectedCustomer != null ? Text(
                          //         'Seçilen müşteri: $selectedCustomer',
                          //         style: const TextStyle(fontSize: 16),
                          //       )
                          //     : const Text('Seçilen müşteri: Müşteri Seçilmedi'),
                          ElevatedButton(
                              onPressed: () {
                                navigateToDeviceListPage();
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 5,
                                minimumSize: const Size(300, 45),
                                backgroundColor: Colors.green[400],
                              ),
                              child: const Text("Devam"))
                        ],
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(bottom: 80),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //     children: [
                    //       // selectedCustomer != null ? Text(
                    //       //         'Seçilen müşteri: $selectedCustomer',
                    //       //         style: const TextStyle(fontSize: 16),
                    //       //       )
                    //       //     : const Text('Seçilen müşteri: Müşteri Seçilmedi'),
                    //       ElevatedButton(
                    //           onPressed: () {
                    //             getCustomersApi();
                    //           },
                    //           style: ElevatedButton.styleFrom(
                    //             elevation: 5,
                    //             minimumSize: const Size(300, 45),
                    //             backgroundColor: Colors.green[400],
                    //           ),
                    //           child: const Text("aaaaaaa"))
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
