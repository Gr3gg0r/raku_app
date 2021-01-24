import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:raku_app/app/messenger/chat_friends.dart';
import 'package:raku_app/app/messenger/chat_room.dart';
import 'package:raku_app/model/user_auth.dart';
import 'package:raku_app/model/user_auth.dart';
import 'package:raku_app/model/user_auth.dart';
import 'package:raku_app/shared/loading_view.dart';

class ChatHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Messenger Home"),
          centerTitle: true,
          bottom: TabBar(
            tabs: [
              Tab(
                child: Text("CHAT"),
              ),
              Tab(
                child: Text("FRIENDS"),
              )
            ],
          ),
        ),
        body: TabBarView(
          children: [GroupList(), ChatFriends()],
        ),
      ),
    );
  }
}

class CustomFriends extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(
                  "https://images.unsplash.com/photo-1610344389740-360295d620ce?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=658&q=80"),
            ),
            title: Text("Shahfiq Shah"),
          ),
        )
      ],
    );
  }
}

class GroupList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final UserProfile userProfile = Provider.of<UserProfile>(context);
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("Group")
          .where("participant", arrayContains: userProfile.uid)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.data.docs.isEmpty)
            return Center(
              child: Text("No Chat Yet"),
            );
          return ListView(
            children: snapshot.data.docs.map((e) => CustomListTile(snapshot: e)).toList(),
          );
        }
        return LoadingPage();
      },
    );
  }
}

class CustomListTile extends StatefulWidget {
  final DocumentSnapshot snapshot;
  CustomListTile({@required this.snapshot});

  @override
  _CustomListTileState createState() => _CustomListTileState();
}

class _CustomListTileState extends State<CustomListTile> {

  String ouser=null;

  @override
  Widget build(BuildContext context) {
    final UserProfile userProfile = Provider.of<UserProfile>(context);
    final  userId = widget.snapshot.data()['participant'];
    for(int i=0;i<userId.length;i++){
      if(userId[i]!=userProfile.uid)
      setState(() {
        ouser =userId[i];
      });
    }
    return ouser==null?null: StreamBuilder(
      stream: FirebaseFirestore.instance.collection("UserProfile").doc(ouser).snapshots(),
      builder: (BuildContext context,AsyncSnapshot<DocumentSnapshot> snapshot){
        if(snapshot.connectionState == ConnectionState.active){
          return Card(
            child: ListTile(
              title: Text(snapshot.data.data()['username']),
              leading: CircleAvatar(
                backgroundImage: NetworkImage(snapshot.data.data()['image_url']),
              ),
              onTap: () =>Navigator.push(context, MaterialPageRoute(builder:
              (context) =>ChatRoom(snapshot: widget.snapshot)
              )) ,
            ),
          );
        }
        return CircularProgressIndicator();
      },
    );
  }
}
