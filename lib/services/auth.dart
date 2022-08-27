import 'package:firebase_auth/firebase_auth.dart';
import 'package:memon_friend/models/user.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:memon_friend/services/database.dart';




class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  //create user onj
  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid, email: user.email, username: user.displayName, photo: user.photoUrl) : null;
  }

  Stream<User> get user {
    return _auth.onAuthStateChanged
        .map(_userFromFirebaseUser);
  }

  //sign in with google

//  Future signInWithFacebook() async{
//    try{
//      FacebookLogin facebookSignIn = FacebookLogin();
//      FacebookLoginStatus account = await facebookSignIn.logIn();
//      print(account);
//      if (account == null)
//        return false;
//      AuthResult res = await _auth.signInWithCredential(GoogleAuthProvider.getCredential(
//        idToken: (await account.authentication).idToken,
//        accessToken: (await account.authentication).accessToken,
//      ));
//      FirebaseUser user = res.user;
//      print(user);
//      await DatabaseService(uid: user.uid,email: user.email,photo: user.photoUrl).updateUserBioData(user.displayName, true, null, null, null, null, null, null);//      await DatabaseService(uid: user.uid, email: user.email, name: user.displayName).updateUserData('0','Uni','Dept','Course Name', 'Course Code', 0,'Course Type',user.email);
//      if(user == null)
//        return false;
//      return _userFromFirebaseUser(user);
//    }
//    catch(e){
//      print(e.toString());
//      return null;
//    }
//  }
  Future signInWithGoogle() async{
    try{
      GoogleSignIn googleSignIn = GoogleSignIn();
      GoogleSignInAccount account = await googleSignIn.signIn();
      print(account);
      if (account == null)
        return false;
      AuthResult res = await _auth.signInWithCredential(GoogleAuthProvider.getCredential(
        idToken: (await account.authentication).idToken,
        accessToken: (await account.authentication).accessToken,
      ));
      FirebaseUser user = res.user;
      print(user);

      if(user == null)
        return false;
      return _userFromFirebaseUser(user);
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }


  //sign in with email & pw
  Future signInWithEmailAndPassword(String email, String password) async{
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      if(user == null)
        return false;
      return _userFromFirebaseUser(user);
    } catch(e){
      print(e.toString());
      return null;
    }
  }



  //register
  Future registerWithEmailAndPassword(String email, String password) async{
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      if(user == null)
        return false;
      return _userFromFirebaseUser(user);
    } catch(e){
      print(e.toString());
      return null;
    }
  }

  //sigh out
  Future signOut() async{
    try{
      return await _auth.signOut();
    } catch(e){
      print(e.toString());
      return null;
    }
  }


}