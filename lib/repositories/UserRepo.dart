import 'package:groupfly_project/DAOs/UserDAO.dart';
import 'package:groupfly_project/models/group_fly_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/authorization_service.dart';

//Implementation of UserDAO
class UserRepo implements UserDao{
  //Instance of Firestore
  final FirebaseFirestore firebaseDB = FirebaseFirestore.instance;

  //Authorization object for inserting a new user into the users collection
  final _auth = Authorization();

  //Gets a user by the provided UID
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

  //Gets a user by the provided username
  @override
  Future<List<GroupFlyUser>> searchProfileByName(String name) async{
    List<GroupFlyUser> profiles = [];
    CollectionReference users = firebaseDB.collection('user');
    await users.where('username', isGreaterThanOrEqualTo: name)
                .where('username', isLessThanOrEqualTo: name + '\uf8ff').get().then((result) {
      if(result.docs.isNotEmpty){
        profiles = List.generate(result.docs.length, (i){
          return GroupFlyUser(
            uid: result.docs[i].id,
            email: result.docs[i]['email'],
            address: result.docs[i]['address'],
            dateOfBirth: (result.docs[i]['date_of_birth'] as Timestamp).toDate(),
            photoURL: result.docs[i]['photo_url'],
            username: result.docs[i]['username'],
            homeFeedRecency: result.docs[i]['home_feed_recency_in_days'],
            active: result.docs[i]['active']
          );
        });
      }
    },);
    return profiles;
  }

  //Inserts a new user to the user collection after registration.
  @override
  Future<void> insertGroupFlyUser(String email, String address, DateTime? dateOfBirth, String username) {
    CollectionReference users = firebaseDB.collection('user');
    return users.doc(_auth.currentUser!.uid).set({
      'email': email,
      'address': address,
      'date_of_birth': dateOfBirth,
      'username': username,
      'photo_url': "",
      'home_feed_recency_in_days': 2,
      'active': true
    })
    .then((value) => print("User added at id ${_auth.currentUser!.uid}."))
    .catchError((error) => print("Error occurred while adding user: $error"));
  }
  
  //Deactivates the user at a specified UID.
  @override
  Future<void> deactivateUser(String uid) async{
    firebaseDB.collection('user').doc(uid).update({
      'active': false
    });
  }
  
  //Activates the user at a specified UID.
  @override
  Future<void> activateUser(String uid) async {
    firebaseDB.collection('user').doc(uid).update({
      'active': true
    });
  }
}