import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:raku_app/model/user_auth.dart';

class ServiceFirebaseAuth {
  FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  UserAuth _setUser(User user) {
    return user == null
        ? null
        : UserAuth(
            userID: user.uid, displayName: user.displayName, email: user.email);
  }

  Stream<UserAuth> get user {
    return _auth.authStateChanges().map((event) => _setUser(event));
  }

  Future<UserAuth> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential _authResult =
        await _auth.signInWithCredential(credential);

    return _setUser(_authResult.user);

    /*final User user = authResult.user;

    if (user != null) {
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final User currentUser = _auth.currentUser;
      assert(user.uid == currentUser.uid);

      print('signInWithGoogle succeeded: $user');
    }
    return st;*/
  }

  Future<UserAuth> signInAnon() async {
    final UserCredential _authResult = await _auth.signInAnonymously();
    return _setUser(_authResult.user);
  }

  Future<UserAuth> signInWithEmailAndPassword({email, password}) async{
   final UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
   return _setUser(userCredential.user);
  }

  Future<UserAuth> createAccount({email, password}) async{
    final UserCredential user = await
    _auth.createUserWithEmailAndPassword(email: email, password: password);
    return _setUser(user.user);
  }

  Future<void> SignOut() async {
    googleSignIn.signOut();
    return await _auth.signOut();
  }
}
