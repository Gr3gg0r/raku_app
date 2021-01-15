import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:raku_app/Root/Controller/auth.dart';
import 'package:raku_app/Root/View/Forum/forum_home.dart';
import 'package:raku_app/Root/View/Messenger/chat_home.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    FlutterStatusbarcolor.setStatusBarColor(Colors.orange);
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.lock),
            onPressed: AuthController().SignOut,
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RaisedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(
                builder: (context) => ForumHome()
              )),
              child: Text("Forum"),
            ),
            SizedBox(height: 20,),
            RaisedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(
                  builder: (context) => ChatHome()
              )),
              child: Text("Chat"),
            )
          ],
        ),
      ),
    );
  }
}
