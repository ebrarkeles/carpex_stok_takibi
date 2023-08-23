// ignore_for_file: use_key_in_widget_constructors

import 'package:carpex_stok_takibi/constants/constants.dart';
import 'package:carpex_stok_takibi/constants/fonts.dart';
import 'package:carpex_stok_takibi/page/action_choose_page/action_choose_page.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 5.0.hp),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Lottie.asset("assets/lottie/data.json"),
                  SizedBox(
                    height: 5.0.hp,
                  ),
                  Text(
                    'İşlem başarılı!',
                    style: TextStyle(
                        fontSize: 20.0.sp, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 5.0.hp),
              child: InkWell(
                onTap: () {
                  setState(() {
                    Constants.iadeCihazListesi = [];
                  });
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const ActionChoosePage()),
                      (Route<dynamic> route) => false);
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 2, 143, 77),
                      borderRadius: BorderRadius.circular(20)),
                  width: 65.0.wp,
                  height: 7.0.hp,
                  child: Center(
                      child: Text(
                    "Anasayfaya Dön",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 15.0.sp),
                  )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
