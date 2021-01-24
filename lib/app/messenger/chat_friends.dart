import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'file:///G:/FutureInTheMaking/Project/Dr%20Aza/Raku/raku_app/lib/shared/loading_view.dart';
import 'package:raku_app/app/profile/profile_user.dart';
import 'package:raku_app/model/user_auth.dart';

class ChatFriends extends StatefulWidget {
  @override
  _ChatFriendsState createState() => _ChatFriendsState();
}

class _ChatFriendsState extends State<ChatFriends> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final UserProfile userProfile = Provider.of<UserProfile>(context,listen: false);
    return StreamBuilder(
      stream: _firestore
          .collection("UserProfile")
          .where("friends", arrayContains: userProfile.uid)
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
