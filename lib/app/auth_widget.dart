import 'package:flutter/material.dart';
import 'package:raku_app/app/util/Wrapper.dart';
import 'package:raku_app/app/auth/sign_in_page.dart';
import 'package:raku_app/model/user_auth.dart';

class AuthWidget extends StatelessWidget {
  const AuthWidget({Key key,@required this.userSnapshot}) : super(key:key);
  final AsyncSnapshot<UserAuth> userSnapshot;
  @override
  Widget build(BuildContext context) {
    if(userSnapshot.connectionState == ConnectionState.active){
      return userSnapshot.hasData ? Wrapper():SignInPage();
    }
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
