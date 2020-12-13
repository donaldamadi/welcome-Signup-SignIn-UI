import 'package:welcome_page/services/user.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class AuthMethods{
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;

  User _userFromFirebaseUser(auth.User userAccount){
    return userAccount != null ? User(userId: userAccount.uid) : null;
  }

  Future signInWithEmailAndPassword(String email, String password) async{
    try{
      auth.UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      auth.User firebaseUser = result.user;
      return _userFromFirebaseUser(firebaseUser);
    } on auth.FirebaseAuthException catch (e){
      if (e.code == 'user-not-found'){
        print('No user found for that email.');
      }else if (e.code == 'wrong password'){
        print ('You typed in a wrong password.');
      }
    }catch(e){
      print(e.toString());
    }
  }

  Future signUpWithEmailAndPassword(String email, String password) async{
    try{
      auth.UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      auth.User firebaseUser = result.user;
      return _userFromFirebaseUser(firebaseUser);
    } on auth.FirebaseAuthException catch (e){
      if (e.code == 'email-already-in-use'){
        print('The account already exists for that email.');
      }
    }catch (e){
      print(e);
    }
  }

  Future resetPassword(String email) async{
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch(e){
      print(e.toString());
    }
  }

  Future signOut() async {
    try{
      return _auth.signOut();
    }catch(e){
      print(e.toString());
    }
  }

}