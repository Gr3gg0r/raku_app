import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:provider/provider.dart';
import 'package:raku_app/app/home/dashboard.dart';
import 'package:raku_app/app/home/home_all_user.dart';
import 'package:raku_app/app/social_post/forum_home.dart';
import 'package:raku_app/app/messenger/chat_home.dart';
import 'package:raku_app/model/user_auth.dart';
import 'package:raku_app/services/service_firebase_auth.dart';

class HomePage extends StatelessWidget {

/*
  Widget CustomCard({UserProfile userprofile,width,height}){
    return Card(
      child: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(8),
        width: width,
        child: Column(
          children: [
            Text("${userprofile.uid}"),
            Text("${userprofile.researcher_id}"),
            Text("${userprofile.image_url}"),
            Text("${userprofile.group}"),
            Text("${userprofile.friends}"),
            Text("${userprofile.email}"),
            Text("${userprofile.username}"),
          ],
        ),
      ),
    );
  }
*/

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final UserProfile userProfile = Provider.of<UserProfile>(context);
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
            onPressed: () => ServiceFirebaseAuth().SignOut(),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //CustomCard(userprofile:userProfile,width: width,height: height),
            RaisedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(
                builder: (context) => ForumHome()
              )),
              child: Text("Social Post"),
            ),
            SizedBox(height: 20,),
            RaisedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(
                  builder: (context) => ChatHome()
              )),
              child: Text("Messenger"),
            ),
            SizedBox(height: 20,),
            RaisedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(
                  builder: (context) => ChatHome()
              )),
              child: Text("Profile"),
            ),
            SizedBox(height: 20,),
            RaisedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(
                  builder: (context) => DashboardPage()
              )),
              child: Text("Dashboard"),
            ),
            SizedBox(height: 20,),
            RaisedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(
                  builder: (context) => AllUser()
              )),
              child: Text("All User"),
            )
          ],
        ),
      ),
    );
  }
}
