import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:plants_doc/Screens/main_screen.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    is12HoursFormat = MediaQuery.of(context).alwaysUse24HourFormat;
    getClimate().whenComplete(() => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MainScreen(),
          ),
        ));
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: SpinKitFadingCube(
          color: Colors.lightGreen,
        ),
      )),
    );
  }
}
