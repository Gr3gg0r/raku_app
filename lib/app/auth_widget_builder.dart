import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:raku_app/model/user_auth.dart';
import 'package:raku_app/services/service_firebase_auth.dart';
import 'package:raku_app/services/service_firestore.dart';

class AuthWidgetBuilder extends StatelessWidget {
  const AuthWidgetBuilder({Key key, @required this.builder}) : super(key: key);
  final Widget Function(BuildContext, AsyncSnapshot<UserAuth>) builder;
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<ServiceFirebaseAuth>(context);
    return StreamBuilder<UserAuth>(
      stream: authService.user,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        final UserAuth userAuth = snapshot.data;
        if (userAuth != null) {
          return MultiProvider(
            providers: [
              Provider<UserAuth>.value(value: userAuth),
              Provider<ServiceFirestore>(
                create: (_) => ServiceFirestore(uid: userAuth.userID),
              ),
              StreamProvider<UserProfile>.value(
                value:ServiceFirestore(uid: userAuth.userID).userProfile,
              ),
            ],
            child: builder(context,snapshot),
          );
        }
        return builder(context, snapshot);
      },
    );
  }
}
