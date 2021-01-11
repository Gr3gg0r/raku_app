import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:raku_app/Root/Controller/auth.dart';

class SignInPage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    FlutterStatusbarcolor.setStatusBarColor(Colors.white);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("Rakku App"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: height*0.05,),
            CircleAvatar(
              radius: 0.14*height,
              backgroundColor: Colors.deepOrangeAccent,
              child: CircleAvatar(
                radius: (0.14*height)-6,
                backgroundColor: Colors.white,
              ),
            ),
            SizedBox(height: height*0.05,),
            Container(
              height: height * 0.06,
              width: width*0.7,
              child: RaisedButton(
                child: Text("Sign In With Google"),
                onPressed: AuthController().signInWithGoogle,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            SizedBox(height: height*0.02,),
            Container(
              height: height * 0.06,
              width: width*0.7,
              child: RaisedButton(
                child: Text("Sign In Account",style: TextStyle(color: Colors.white),),
                onPressed: (){},
                color: Colors.orange,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)
                ),
              ),
            ),
            SizedBox(height: height*0.02,),
            Container(
              height: height * 0.06,
              width: width*0.7,
              child: RaisedButton(
                color: Colors.black,
                child: Text("Sign In Anonymously ",style: TextStyle(color: Colors.white),),
                onPressed: AuthController().signInAnon,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
