import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:plants_doc/Screens/login_screen.dart';
import 'package:plants_doc/chat_bubble.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class ChatScreen extends StatefulWidget {
  ChatScreen({Key key, @required this.colletionData}) : super(key: key);
  final String colletionData;
  @override
  _ChatScreenState createState() => _ChatScreenState(colletionData);
}

final firestore = FirebaseFirestore.instance;

User loggedUser;
var messageText, loggedUsername;
final fieldText = TextEditingController();

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

var image;
//
File pickedImage;
Future pickImage() async {
  final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);

  if (pickedFile != null) {
    pickedImage = File(pickedFile.path);
    print('Image Picked');
  } else {
    print('no image');
  }
}
//

class _ChatScreenState extends State<ChatScreen> {
  String collectionData;
  _ChatScreenState(this.collectionData);
  @override
  void initState() {
    getCurrentUser();
    // TODO: implement initState
    super.initState();
  }

  String url;
  Future uploadFile(File imagefile) async {
    String filename = basename(imagefile.path);
    print(filename);
    Reference storageReference =
        FirebaseStorage.instance.ref().child("chatImage/$filename");
    final UploadTask uploadTask = storageReference.putFile(imagefile);
    final TaskSnapshot downloadUrl = (await uploadTask);
    await downloadUrl.ref.getDownloadURL().whenComplete(() => firestore
        .collection('messages')
        .doc('discussion')
        .collection(collectionData)
        .add({
          'ImageUrl': url,
          'text': "",
          'sender': (loggedUser.phoneNumber).substring(3),
          'sendername': loggedUsername
        })
        .then((value) => print('working'))
        .catchError((onError) => print(onError)));
  }

  @override
  Widget build(BuildContext context) {
    firestore
        .collection('users')
        .doc(loggedUser.phoneNumber)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      loggedUsername = documentSnapshot.data()['username'];
    });
    return Scaffold(
      appBar: AppBar(
        title: Text(
          collectionData,
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        shadowColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                    print(snapshot.error);
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("Loading");
                  }
                  return new ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    children:
                        snapshot.data.docs.map((DocumentSnapshot document) {
                      return new ChatBubble(
                        messageTexts: document.data()['text'] == null
                            ? ""
                            : document.data()['text'],
                        image: document.data()['ImageUrl'] == null
                            ? ""
                            : document.data()['ImageUrl'],
                        senderDetail: document.data()['sender'],
                        currentUser: loggedUser.phoneNumber,
                        username: document.data()['sendername'],
                      );

                      //     ListTile(
                      //   title: new Text(document.data()['text']),
                      //   subtitle: new Text(document.data()['sender']),
                      // );
                    }).toList(),
                  );
                },
                stream: firestore
                    .collection('messages')
                    .doc('discussion')
                    .collection(collectionData)
                    .snapshots()),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: fieldText,
                  onChanged: (value) {
                    messageText = value;
                  },
                  decoration: InputDecoration(
                    hintStyle: TextStyle(fontSize: 17),
                    hintText: 'Text',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(20),
                  ),
                ),
              ),
              IconButton(
                  icon: Icon(Icons.attach_file),
                  onPressed: () {
                    setState(() {
                      pickImage();
                    });
                  }),
              IconButton(
                icon: Icon(Icons.camera),
                onPressed: () {
                  uploadFile(pickedImage);
                },
              ),
              IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    print(loggedUser.phoneNumber);
                    firestore
                        .collection('messages')
                        .doc('discussion')
                        .collection(collectionData)
                        .add({
                          'text': messageText,
                          'sender': (loggedUser.phoneNumber).substring(3),
                          'sendername': loggedUsername
                        })
                        .then((value) => print('working'))
                        .catchError((onError) => print(onError));
                    fieldText.clear();
                  })
            ],
          ),
        ],
      )),
    );
  }
}
