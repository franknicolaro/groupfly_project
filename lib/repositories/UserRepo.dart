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
  Future<List<GroupFlyUser>> searchProfileByName(String name) async{
    List<GroupFlyUser> profiles = [];
    CollectionReference users = firebaseDB.collection('user');
    await users.where('username', isEqualTo: name).get().then((result) {
      if(result.docs.isNotEmpty){
        profiles = List.generate(result.docs.length, (i){
          return GroupFlyUser(
            uid: result.docs[i].id,
            email: result.docs[i]['email'],
            address: result.docs[i]['address'],
            dateOfBirth: (result.docs[i]['date_of_birth'] as Timestamp).toDate(),
            photoURL: result.docs[i]['photo_url'],
            username: result.docs[i]['username']
          );
        });
      }
    },);
    //print(profiles[0].username);
    return profiles;
  }

  @override
  Future<void> insertGroupFlyUser(String email, String address, DateTime? dateOfBirth, String username) {
    CollectionReference users = firebaseDB.collection('user');
    return users.doc(_auth.currentUser!.uid).set({
      'email': email,
      'address': address,
      'date_of_birth': dateOfBirth,
      'username': username,
      'photo_url': null,
    })
    .then((value) => print("User added at id ${_auth.currentUser!.uid}."))
    .catchError((error) => print("Error occurred while adding user: $error"));
  }
  
  
  
}