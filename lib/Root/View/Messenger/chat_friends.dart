import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:raku_app/Root/Shared/loading_view.dart';
import 'package:raku_app/Root/View/Profile/profile_user.dart';

class ChatFriends extends StatefulWidget {
  @override
  _ChatFriendsState createState() => _ChatFriendsState();
}

class _ChatFriendsState extends State<ChatFriends> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _firestore
          .collection("UserProfile")
          .where("friends", arrayContains: "AndTJTtO9bfod5GjT1C0VjZ6CUq1")
          .orderBy("username")
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if(snapshot.connectionState==ConnectionState.waiting)
          return LoadingPage();
        return ListView(
          children: snapshot.data.docs
              .map((e) => Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage:
                            NetworkImage("${e.data()['image_url']}"),
                      ),
                      title: Text("${e.data()['username']}"),
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfileUser(e))),
                    ),
                  ))
              .toList(),
        );
      },
    );
  }
}
