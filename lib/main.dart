import 'package:carpex_stok_takibi/constants/constants.dart';
import 'package:carpex_stok_takibi/page/login_page.dart';
import 'package:carpex_stok_takibi/page/qr_device_list_page.dart';
import 'package:flutter/material.dart';

void main() {
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
      home: const LoginPage(),
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

  List<String> musteriler = [
    'Carpex',
    'Starbucks',
    'Gesk Technology',
    'Petrol Ofisi',
    'Rass Technology',
    'Burger King',
    'Kahve Dünyası',
    'Kültür Üniversitesi',
  ];

  void navigateToDeviceListPage() {
    if (selectedCustomer != null) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) =>
                  QrDeviceListPage(selectedCustomer: selectedCustomer!)),
          (Route<dynamic> route) => false);
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
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Müşteri Seçiniz',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 18),
                                    ),
                                  ),
                                  value: selectedCustomer,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedCustomer = newValue;
                                      Constants.musteri = newValue!;
                                    });
                                  },
                                  items: musteriler.map((String customer) {
                                    return DropdownMenuItem<String>(
                                      value: customer,
                                      child: Text(
                                        "    $customer",
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 20),
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
