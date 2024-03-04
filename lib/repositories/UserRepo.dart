import 'package:groupfly_project/DAOs/UserDAO.dart';
import 'package:groupfly_project/models/group_fly_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/authorization_service.dart';

class UserRepo implements UserDao{
  final FirebaseFirestore firebaseDB = FirebaseFirestore.instance;
  final _auth = Authorization();
  @override
  Future<GroupFlyUser> getGroupFlyUserByUID(String uid) async {
    GroupFlyUser? result;
    CollectionReference users = firebaseDB.collection('user');
    final ref = users.doc(uid).withConverter(
      fromFirestore: GroupFlyUser.fromDB, 
      toFirestore: (GroupFlyUser user, _) => user.toMap(),
    );
    final documentSnapshot = await ref.get();
    result = documentSnapshot.data();
    return result!;
  }

  @override
  Future<void> insertGroupFlyUser(String email, String address, DateTime? dateOfBirth, String username) {
    CollectionReference users = firebaseDB.collection('user');
    return users.doc(_auth.currentUser!.uid).set({
      'email': email,
      'address': address,
      'date_of_birth': dateOfBirth,
      'username': username
    })
    .then((value) => print("User added at id ${_auth.currentUser!.uid}."))
    .catchError((error) => print("Error occurred while adding user: $error"));
  }
  
}