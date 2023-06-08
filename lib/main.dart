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
        primarySwatch: Colors.blueGrey,
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
    'Rass Technology'
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
          title: Text('Hata'),
          content: Text('Müşteri seçimi yapmadınız!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Tamam'),
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
        appBar: AppBar(
          backgroundColor: Constants.themeColor,
          title: const Text("Stok Takip"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 30),
              Row(
                children: [
                  const SizedBox(width: 40),
                  Text(
                    'Müşteri',
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(width: 40),
                  DropdownButton<String>(
                    hint: Text('Müşteri Seçin'),
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
                        child: Text(customer),
                      );
                    }).toList(),
                    dropdownColor: Colors.white,
                  ),
                ],
              ),
              SizedBox(height: 600),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  selectedCustomer != null
                      ? Text(
                          'Seçilen müşteri: $selectedCustomer',
                          style: TextStyle(fontSize: 16),
                        )
                      : Text('Seçilen müşteri: Müşteri Seçilmedi'),
                  ElevatedButton(
                      onPressed: () {
                        navigateToDeviceListPage();
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 5,
                        minimumSize: Size(100, 45),
                        backgroundColor: Constants.themeColor,
                      ),
                      child: Text("Devam"))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
