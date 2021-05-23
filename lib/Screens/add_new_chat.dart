import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:plants_doc/Screens/chat_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

File pickedImage;

final firestore = FirebaseFirestore.instance;
var discussionTitle;
var messageTexts;
User loggedUser;
final auth = FirebaseAuth.instance;
void getCurrentUser() {
  try {
    final user = auth.currentUser;
    if (user != null) {
      loggedUser = user;
    }
  } catch (e) {
    print(e);
  }
}

class AddNewChat extends StatefulWidget {
  @override
  _AddNewChatState createState() => _AddNewChatState();
}

class _AddNewChatState extends State<AddNewChat> {
  @override
  Widget build(BuildContext context) {
    Future pickImage() async {
      final pickedFile =
          await ImagePicker().getImage(source: ImageSource.gallery);
      setState(() {
        if (pickedFile != null) {
          pickedImage = File(pickedFile.path);
          print('Image Picked');
        } else {
          print('no image');
        }
      });
    }

    Future captureImage() async {
      final pickedFile =
          await ImagePicker().getImage(source: ImageSource.camera);

      setState(() {
        if (pickedFile != null) {
          pickedImage = File(pickedFile.path);
          print('Image Picked');
          return pickedFile;
        } else {
          print('no image');
        }
      });
    }

    getCurrentUser();
    firestore
        .collection('users')
        .doc(loggedUser.phoneNumber)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      loggedUsername = documentSnapshot.data()['username'];
    });

    return Scaffold(
      backgroundColor: Color(0xffECF4F3),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: ListView(
        children: [
          Column(
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
              Container(
                height: 200,
                width: 350,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Column(
                  children: [
                    pickedImage == null
                        ? Image.asset(
                            "images/empty.png",
                            width: 280,
                          )
                        : Image.file(
                            pickedImage,
                            width: 280,
                            height: 130,
                          ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          child: Container(
                            width: 50,
                            child: Center(
                              child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      0.0, 15.0, 0.0, 15.0),
                                  child: Icon(Icons.camera)),
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              color: Color(0xffFF7E67),
                            ),
                          ),
                          onTap: () {
                            captureImage();
                          },
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        GestureDetector(
                          child: Container(
                            width: 50,
                            child: Center(
                              child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      0.0, 15.0, 0.0, 15.0),
                                  child: Icon(Icons.attach_file)),
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              color: Color(0xffFF7E67),
                            ),
                          ),
                          onTap: () {
                            pickImage();
                          },
                        ),
                        SizedBox(
                          width: 20,
                        )
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 150,
                width: 350,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Column(
                  children: [
                    Text("Title:"),
                    TextField(
                      onChanged: (value) {
                        discussionTitle = value;
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 150,
                width: 350,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Column(
                  children: [
                    Text("Text:"),
                    TextField(
                      onChanged: (value) {
                        messageTexts = value;
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              GestureDetector(
                child: Container(
                  width: 350,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 20.0),
                      child: Text(
                        "Start Discussion",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Color(0xffFF7E67),
                  ),
                ),
                onTap: () {
                  addCollection();
                },
              )
            ],
          ),
        ],
      )),
    );
  }
}

Future addCollection() async {
  firestore
      .collection('messages')
      .doc('discussion')
      .collection(discussionTitle)
      .add({
        'text': messageTexts,
        'sender': (loggedUser.phoneNumber).substring(3),
        'sendername': loggedUsername
      })
      .then((value) => print('working'))
      .catchError((onError) => print(onError));
  firestore
      .collection('messages')
      .add({'collection': discussionTitle, 'creater': loggedUsername});
}
