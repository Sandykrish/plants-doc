import 'package:flutter/material.dart';
import 'package:plants_doc/Screens/Index_screen.dart';
import 'package:plants_doc/Screens/add_new_chat.dart';
import 'package:plants_doc/Screens/feritlizer_calculator.dart';
import 'package:plants_doc/Screens/login_screen.dart';
import 'package:plants_doc/Screens/main_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:plants_doc/Screens/pridict_image.dart';
import 'package:plants_doc/Screens/sample_space.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:plants_doc/Screens/loading_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var login = prefs.getString("login");
  runApp(MaterialApp(
    home: login == null ? SampleSpace() : LoadingScreen(),
    //home: PredictImage(),
    theme: ThemeData(scaffoldBackgroundColor: Colors.white),
  ));
}
