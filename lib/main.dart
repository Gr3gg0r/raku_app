
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:raku_app/Root/Controller/auth.dart';
import 'package:raku_app/Root/Model/user_model.dart';
import 'package:raku_app/Root/Shared/loading_view.dart';
import 'package:raku_app/Root/View/loginpage.dart';
import 'package:raku_app/Root/Wrapper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: RootDir(),
    );
  }
}

class RootDir extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  FutureBuilder(
      future:Firebase.initializeApp(),
      builder: (BuildContext context, snapshot){
        if(snapshot.connectionState==ConnectionState.done){
          return AuthWrapper();
        }
        return LoadingPage();
      },
    );
  }
}



class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthController().user,
      builder: (BuildContext context,AsyncSnapshot<UserAuth> snapshot){
        if(snapshot.connectionState==ConnectionState.waiting)
          return LoadingPage();
        return snapshot.data==null? SignInPage():Wrapper(uid: snapshot.data.userID,);
      },
    );
  }
}

