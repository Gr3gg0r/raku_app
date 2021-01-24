import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:raku_app/model/user_auth.dart';

class ChatRoom extends StatelessWidget {
  final DocumentSnapshot snapshot;
  ChatRoom({@required this.snapshot});
  @override
  Widget build(BuildContext context) {
    final UserProfile userProfile = Provider.of<UserProfile>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat Room"),
        centerTitle: true,
      ),
      body: ListChat(
        username: userProfile.username,
        uuid: userProfile.uid,
        snapshot: snapshot,
      ),
    );
  }
}

class ListChat extends StatefulWidget {
  final String username, uuid;
  final DocumentSnapshot snapshot;
  ListChat({@required this.snapshot,this.username, this.uuid});
  @override
  _ListChatState createState() => _ListChatState();
}

class _ListChatState extends State<ListChat> {
  ChatUser user = ChatUser();

  @override
  void initState() {
    user.name = widget.username;
    user.uid = widget.uuid;
    super.initState();
  }

  void onSend(ChatMessage message) {
    var documentReference = FirebaseFirestore.instance
        .collection("Group")
        .doc(widget.snapshot.id)
        .collection('messages')
        .doc(DateTime.now().millisecondsSinceEpoch.toString());

    FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.set(
        documentReference,
        message.toJson(),
      );
    });
  }

  void uploadFile() async {
    File result = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxHeight: 400,
      maxWidth: 400,
    );

    if (result != null) {
      final Reference storageRef = FirebaseStorage.instance
          .ref()
          .child("chat_images/${widget.uuid}.jpg");

      UploadTask uploadTask = storageRef.putFile(result);
      var download = await uploadTask;

      String url = await download.ref.getDownloadURL();

      ChatMessage message = ChatMessage(text: "", user: user, image: url);

      var documentReference = FirebaseFirestore.instance
          .collection("Group")
          .doc(widget.snapshot.id)
          .collection('messages')
          .doc();

      FirebaseFirestore.instance.runTransaction((transaction) async {
        await transaction.set(
          documentReference,
          message.toJson(),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Group")
            .doc(widget.snapshot.id)
            .collection('messages')
            .orderBy("createdAt")
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor),
              ),
            );
          } else {
            List<DocumentSnapshot> items = snapshot.data.documents;
            var messages =
                items.map((i) => ChatMessage.fromJson(i.data())).toList();
            return DashChat(
              user: user,
              messages: messages,
              inputDecoration: InputDecoration(
                hintText: "Message here...",
                border: InputBorder.none,
              ),
              onSend: onSend,
              trailing: <Widget>[
                IconButton(
                  icon: Icon(Icons.photo),
                  onPressed: uploadFile,
                )
              ],
            );
          }
        },
      ),
    );
  }
}