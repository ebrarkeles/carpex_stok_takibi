// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

Future<bool> showExitPopup(context) async {
  return await showDialog(
        //show confirm dialogue
        //the return value will be from "Yes" or "No" options
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Carpex Cihaz Sevk'),
          content: Text('Uygulamadan çıkmak istiyor musunuz?'),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white, elevation: 0),

              onPressed: () => Navigator.of(context).pop(false),
              //return false when click on "NO"
              child: Text(
                'Hayır',
                style: TextStyle(color: Color.fromARGB(194, 0, 0, 0)),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Color.fromARGB(255, 255, 60, 60)),
              onPressed: () => Navigator.of(context).pop(true),
              //return true when click on "Yes"
              child: Text('Evet, Çıkış yap'),
            ),
          ],
        ),
      ) ??
      false; //if showDialouge had returned null, then return false
}
