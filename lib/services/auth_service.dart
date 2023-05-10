import 'package:chat_app/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../helper/helper_function.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

//  Login
  Future login(String email, String password) async {
    try {
      User user=(await firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password
      )).user!;
      if(user!=null){
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
//Register
  Future register(String name, String email, String password) async {
    try {
      User user=(await firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password
      )).user!;
      if(user!=null){
        await DatabaseService(uid: user.uid).savingUserData(name, email);
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
  Future signOut()async{
    try{
      await HelperFunctions.saveUserLoginStatus(false);
      await HelperFunctions.saveUserEmail("");
      await HelperFunctions.saveUserName("");
      await firebaseAuth.signOut();
    }catch(e){
      return null;
    }
  }
//Sign-out
}
