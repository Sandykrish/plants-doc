import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plants_doc/Screens/login_screen.dart';

class SampleSpace extends StatefulWidget {
  @override
  _SampleSpaceState createState() => _SampleSpaceState();
}

class _SampleSpaceState extends State<SampleSpace> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Center(
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Text(
              "PlantsDoc",
              style: TextStyle(
                fontSize: 60,
                color: Color(0xff032123),
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Make Plants Happy",
              style: TextStyle(
                fontSize: 30,
                color: Color(0xff032123),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Center(
              child: Image.asset(
                "images/intro_plant.png",
                width: 300,
              ),
            ),
            SizedBox(
              height: 80,
            ),
            GestureDetector(
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(100, 20, 100, 20),
                  child: Text(
                    "Get Started",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: Color(0xffFF7E67),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ),
                );
              },
            )
          ],
        ),
      )),
    );
  }
}
