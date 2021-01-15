import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:raku_app/Root/View/Messenger/chat_room.dart';

class ProfileUser extends StatelessWidget {
  final DocumentSnapshot snapshot;
  ProfileUser(this.snapshot);
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("User Profile"),
        centerTitle: true,
        /*leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.white,),
          onPressed: () => Navigator.pop(context),
        ),*/
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: height*0.4,
              color: Colors.orange,
              width: width,
              child: Column(
                children: [
                  Expanded(
                    flex:3,
                    child: Center(
                      child: CircleAvatar(
                        maxRadius: height*0.11+5,
                        minRadius: height*0.05+5,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          maxRadius: height*0.11,
                          minRadius: height*0.05,
                          backgroundImage: NetworkImage("${snapshot.data()["image_url"]}"),
                        ),
                      ),
                    ),
                  ),
                  Expanded(child: Text("${snapshot.data()['username']}",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: height*0.03
                  ),
                  )),
                ],
              ),
            ),
            SizedBox(height: 20,),
            RaisedButton(
              child: Text("Personal Message"),
              onPressed: ()=>Navigator.push(context, MaterialPageRoute(
                builder: (context) => ChatRoom()
              )),
              color: Colors.yellow,
            )
          ],
        ),
      ),
    );
  }
}
