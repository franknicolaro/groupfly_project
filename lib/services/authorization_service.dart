import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:groupfly_project/models/group_fly_user.dart';

//A service that connects FirebaseAuthentication to the Flutter backend.
class Authorization{
  //Instance of Firebase Authentication
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //Returns a GroupFlyUser based on the User provided.
  GroupFlyUser? _userFromFirebaseUser(User? user) {
    return user != null ? GroupFlyUser(uid: user.uid): null;
  }

  //Getter for the current user.
  User? get currentUser{
    return _auth.currentUser;
  }

  //provides the Stream for the StreamProvider in main.dart.
  Stream<GroupFlyUser?> get user {
    return _auth.userChanges().map((User? user) =>  _userFromFirebaseUser(user!));
  }

  //Signs the user in based on the provided email and password, and returns a GroupFlyUser
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

  //Registers and account into FirebaseAuthentication and sends an
  //email verification to the email that registered. Returns a GroupFlyUser of
  //the user that registered. 
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

  //Changes the password for the current user. 
  Future changePassword(String currentPassword, String newPassword) async{
    User user = currentUser!;
    final credential = EmailAuthProvider.credential(email: user.email!, password: currentPassword);
    user.reauthenticateWithCredential(credential).then((value) {
      user.updatePassword(newPassword).then((_){
        return;
      }).catchError((onError) => print("ERROR TRYING TO CHANGE PASSWORD, PASSWORD COULD NOT UPDATE: $onError"));
    }).catchError((error) => print("ERROR TRYING TO CHANGE PASSWORD, COULD NOT REAUTHENTICATE: $error"));
  }

  //Deletes the user from FirebaseAuthentication
  Future deleteUser() async{
    try{
      await _auth.currentUser!.delete();
    }
    catch(e){
      print("Error orccured while trying to delete account");
    }
  }

  //Signs the user out. 
  Future signOut() async{
    try{
      await _auth.signOut();
    }
    catch(e){
      print("Error orccured while trying to delete account");
    }
  }
}