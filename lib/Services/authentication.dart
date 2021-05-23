import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:plants_doc/Screens/loading_screen.dart';
import 'package:plants_doc/Screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:plants_doc/Screens/main_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> verifyPhone(phNo, BuildContext context) async {
  String smsCode;
  final firestore = FirebaseFirestore.instance;

  FirebaseAuth auth = FirebaseAuth.instance;
  await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phNo,
      verificationCompleted: (PhoneAuthCredential credential) async {
        Navigator.of(context).pop();
        UserCredential result = await auth.signInWithCredential(credential);
        User user = result.user;
        if (user != null) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('login', phNo);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext ctx) => LoadingScreen()));
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text("Login Successful"),
          ));
          firestore
              .collection('users')
              .doc(phoneNumber)
              .set({'username': userName, 'phonenumber': phoneNumber});
        }
      },
      verificationFailed: (FirebaseAuthException e) {
        print(e);
      },
      codeSent: (String verificationId, int resendToken) {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return AlertDialog(
                backgroundColor: Colors.white,
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text('Catching Otp'),
                    SpinKitChasingDots(
                      size: 30.0,
                      color: Colors.black38,
                    ),
                    TextField(
                      keyboardType: TextInputType.phone,
                      onChanged: (value) async {
                        smsCode = value;

                        if (value.length == 6) {
                          PhoneAuthCredential phoneAuth =
                              PhoneAuthProvider.credential(
                                  verificationId: verificationId,
                                  smsCode: smsCode);
                          UserCredential codeResult =
                              await auth.signInWithCredential(phoneAuth);
                          User user = codeResult.user;
                          if (user != null) {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            prefs.setString('login', phNo);

                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext ctx) =>
                                        LoadingScreen()));
                            firestore.collection('users').doc(phoneNumber).set({
                              'username': userName,
                              'phonenumber': phoneNumber
                            });
                          } else {
                            Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text("Incorrect OTP"),
                            ));
                          }
                        }
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter Manually',
                        filled: true,
                      ),
                      autofocus: false,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            });
      },
      timeout: const Duration(seconds: 60),
      codeAutoRetrievalTimeout: (String verificationId) {});
}
