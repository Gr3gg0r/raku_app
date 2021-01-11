import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:raku_app/Root/Controller/db_controller.dart';
import 'package:raku_app/Root/Shared/loading_view.dart';
import 'package:raku_app/Root/View/homepage.dart';
import 'package:raku_app/Root/View/new_user.dart';

class Wrapper extends StatelessWidget {
  final String uid;
  Wrapper({this.uid});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: DBController(collection: "UserProfile",docu: uid).data,
      builder: (BuildContext context,AsyncSnapshot<DocumentSnapshot> snapshot){
        if(snapshot.connectionState==ConnectionState.waiting)
          return LoadingPage();
        return snapshot.data.data()!=null? HomePage():NewUser(uid: uid,);
      },
    );
  }
}
