
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:raku_app/Root/Model/user_model.dart';

class AuthController{

  FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();


  UserAuth setUser(User user){
    return user==null?null: UserAuth(userID:user.uid,displayName: user.displayName,email:user.email);
  }

  Stream<UserAuth> get user{
    return _auth.authStateChanges().map((event) => setUser(event));
  }

  Future<String> signInWithGoogle() async{


      final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential authResult = await _auth.signInWithCredential(credential);
      final User user = authResult.user;

      if (user != null) {
        assert(!user.isAnonymous);
        assert(await user.getIdToken() != null);

        final User currentUser = _auth.currentUser;
        assert(user.uid == currentUser.uid);

        print('signInWithGoogle succeeded: $user');
      }

      return null;
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