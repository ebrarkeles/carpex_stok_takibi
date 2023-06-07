// ignore_for_file: camel_case_types

import 'package:carpex_stok_takibi/constants/constants.dart';
import 'package:carpex_stok_takibi/constants/data_helpar.dart';
import 'package:flutter/material.dart';

class Qr_List extends StatefulWidget {
  const Qr_List({super.key});

  @override
  State<Qr_List> createState() => _Qr_ListState();
}

class _Qr_ListState extends State<Qr_List> {
  @override
  Widget build(BuildContext context) {
    List<Cihaz> tumQrEklenenCihazlar = Constants.tumEklenenCihazlar;
    if (tumQrEklenenCihazlar.isNotEmpty) {
      return Center(child: Text("Buraya Liste Gelecek"));
    } else {
      return Center(child: Text("Liste Boş"));
    }
  }
}
