import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:raku_app/app/profile/profile_user.dart';
import 'package:raku_app/shared/loading_view.dart';

class AllUser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AllUser"),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection("UserProfile").snapshots(),
        builder: (BuildContext context , AsyncSnapshot<QuerySnapshot> snapshot){
          if(snapshot.connectionState == ConnectionState.active){
            return ListView(
              children: snapshot.data.docs.map((e) =>
              Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(e.data()['image_url']),
                  ),
                  title: Text(e.data()['username']),
                  onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfileUser(e))),
                ),
              )
              ).toList(),
            );
          }
          return LoadingPage();
        },
      ),
    );
  }
}
