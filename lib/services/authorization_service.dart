import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:groupfly_project/models/group_fly_user.dart';

class Authorization{

  final FirebaseAuth _auth = FirebaseAuth.instance;

  GroupFlyUser? _userFromFirebaseUser(User? user) {
    return user != null ? GroupFlyUser(uid: user.uid): null;
  }

  User? get currentUser{
    return _auth.currentUser;
  }

  Stream<GroupFlyUser?> get user {
    return _auth.userChanges().map((User? user) =>  _userFromFirebaseUser(user!));
  }

  Future signIn(String email, String password) async{
    try{
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User user = result.user!;
      return _userFromFirebaseUser(user);
    } catch(e){
      print(e.toString());
      return null;
    }
  }
  Future registerAccountAndVerify(String email, String password) async{
    UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    try{
      await result.user?.sendEmailVerification();
    }
    catch(e){
      print("Error orccured while trying to verify account information");
    }
    return _userFromFirebaseUser(result.user);
  }
  Future signOut() async{
    await _auth.signOut();
  }
}