import 'package:flutter/material.dart';

import '../../constants/constants.dart';
import '../../utils/on_wii_pop.dart';

class MusteriSec extends StatefulWidget {
  const MusteriSec({super.key});

  @override
  State<MusteriSec> createState() => _MusteriSecState();
}

class _MusteriSecState extends State<MusteriSec> {
  //EXIT POP UP   ------------------------------------------------------------*/
  Future<bool> showExitPopupHandle() => showExitPopup(context);
/*----------------------------------------------------------------------------*/

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: showExitPopupHandle,
        child: Scaffold(
          backgroundColor: Constants.backgroundColor,
          body: Center(child: Text("müşteri seç")),
        ),
      ),
    );
  }
}
