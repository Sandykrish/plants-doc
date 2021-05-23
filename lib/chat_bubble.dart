import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  ChatBubble(
      {this.senderDetail,
      this.messageTexts,
      this.image,
      this.currentUser,
      this.username});
  bool me;

  final String senderDetail, messageTexts, currentUser, username, image;
  @override
  Widget build(BuildContext context) {
    if (senderDetail == currentUser.substring(3)) {
      me = true;
    } else {
      me = false;
    }

    return (me == true)
        ? Padding(
            padding: const EdgeInsets.fromLTRB(50, 8, 8, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15.0),
                        bottomLeft: Radius.circular(15.0),
                        bottomRight: Radius.circular(15.0)),
                    color: Colors.lightGreen,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          username,
                          style: TextStyle(fontSize: 10),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 30, 15),
                        child: image == ""
                            ? Column(
                                children: [
                                  Text(
                                    messageTexts,
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  )
                                ],
                              )
                            : Column(
                                children: [
                                  Image.network(image),
                                  Text(
                                    messageTexts,
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        : Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 50, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          username,
                          style: TextStyle(fontSize: 10),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 0, 20, 15),
                        child: Text(
                          messageTexts,
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                      color: Colors.black38,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(15.0),
                          bottomLeft: Radius.circular(15.0),
                          bottomRight: Radius.circular(15.0))),
                ),
              ],
            ),
          );
  }
}
