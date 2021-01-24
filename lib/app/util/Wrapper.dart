import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:raku_app/app/home/homepage.dart';
import 'package:raku_app/app/profile/new_user.dart';
import 'package:raku_app/model/user_auth.dart';
import 'package:raku_app/shared/loading_view.dart';

class Wrapper extends StatelessWidget {

  Future<UserProfile> UserListen(BuildContext context)async{
    final UserProfile userProfile = Provider.of<UserProfile>(context);
    return userProfile;
  }

  @override
  Widget build(BuildContext context) {
/*   final UserAuth userAuth = Provider.of<UserAuth>(context);
    final UserProfile userProfile = Provider.of<UserProfile>(context);

    return userProfile!=null? HomePage():NewUser(uid: userProfile.uid);*/
    return FutureBuilder(
      future: UserListen(context),
      builder: (BuildContext context,AsyncSnapshot<UserProfile> snapshot){
       if(snapshot.connectionState==ConnectionState.done){
         return snapshot.data!=null?HomePage():NewUser(uid: snapshot.data.uid,);
       }
       return LoadingPage();
      },
    ) ;

    /*return StreamBuilder(
      stream: ServiceFirestore(uid: userAuth.userID).userProfile,
      builder: (BuildContext context,AsyncSnapshot<UserProfile> snapshot){
        if(snapshot.connectionState==ConnectionState.waiting)
          return LoadingPage();
        return snapshot.data!=null? HomePage():NewUser(uid:  userAuth.userID,);
      },
    );*/
  }
}
