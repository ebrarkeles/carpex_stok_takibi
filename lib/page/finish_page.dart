import 'package:carpex_stok_takibi/constants/constants.dart';
import 'package:carpex_stok_takibi/main.dart';
import 'package:flutter/material.dart';

class FinishPage extends StatefulWidget {
  const FinishPage({Key? key});

  @override
  State<FinishPage> createState() => _FinishPageState();
}

class _FinishPageState extends State<FinishPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle,
              size: 100,
              color: Colors.green,
            ),
            const SizedBox(height: 20),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Cihazlar sevk edildi.',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  'İşlem başarılı!',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            Constants.tumEklenenCihazlar = [];
                          });
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      const MyHomePage()),
                              (Route<dynamic> route) => false);
                        },
                        child: Text("Anasayfaya Dön")),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
