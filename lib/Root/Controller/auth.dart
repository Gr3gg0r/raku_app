
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:raku_app/Root/Model/user_model.dart';

class AuthController{

  FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();


  UserAuth setUser(User user){
    return user==null?null: UserAuth(userID:user.uid,displayname: user.displayName);
  }

  Stream<UserAuth> get user{
    return _auth.authStateChanges().map((event) => setUser(event));
  }

  Future<UserAuth> signInWithGoogle() async{

    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken
    );
    final UserCredential _user = await _auth.signInWithCredential(credential);

    return setUser(_user.user);
  }

  void  signInAnon(){
     _auth.signInAnonymously();
  }

  void signInWithEmailAndPassword({email,password}){
    _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  void createAccount({email,password}){
    _auth.createUserWithEmailAndPassword(email: email, password: password);
  }

  void SignOut(){
    _auth.signOut();
    googleSignIn.signOut();
  }

}