import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:plants_doc/Services/authentication.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

const String loginPlant = 'images/login.jpg';
var userName, phoneNumber;

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffECF4F3),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(15, 0, 15, 20),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                ),
                child: TextField(
                  style: TextStyle(fontSize: 20, color: Colors.black),
                  onChanged: (value) {
                    userName = value;
                  },
                  decoration: InputDecoration(
                    hintStyle: TextStyle(fontSize: 17, color: Colors.black),
                    hintText: 'User Name',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(20),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(15, 10, 15, 30),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                ),
                child: TextField(
                  keyboardType: TextInputType.number,
                  style: TextStyle(fontSize: 20, color: Colors.black),
                  onChanged: (value) {
                    phoneNumber = '+91$value';
                  },
                  decoration: InputDecoration(
                    hintStyle: TextStyle(fontSize: 17, color: Colors.black),
                    hintText: 'Phone Number',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(20),
                  ),
                ),
              ),
            ),
            GestureDetector(
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(100, 20, 100, 20),
                  child: Text(
                    "Sign In",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: Color(0xffFF7E67),
                ),
              ),
              onTap: () {
                setState(() {
                  verifyPhone(phoneNumber, context);
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
