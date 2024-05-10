import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:groupfly_project/DAOs/FriendDAO.dart';
import 'package:groupfly_project/models/FriendList.dart';

//Implementation of FriendDAO
class FriendRepo implements FriendDao{
  //Instance of Firestore
  final FirebaseFirestore firebaseDB = FirebaseFirestore.instance;

  //Initializes a Friend document for the user upon registration
  @override
  Future<void> initFriendDocument(String uid) async{
    firebaseDB.collection("friends").doc(uid).set(
      {
        'frienduids': []
      }
    ).onError((error, stackTrace) => "Error: could not create friend document");
  }

  //Obtains all friends of the user based on the user's UID.
  @override
  Future<FriendList> getFriendsByUID(String uid) async{
    CollectionReference friendCollection = firebaseDB.collection('friends');
    FriendList? friends;
    await friendCollection.doc(uid).get().then((snapshot) {
      friends = FriendList(
        friend_uids: List.from(snapshot.get('frienduids'))
      );
    });
    return friends!;
  }

  //Removes a friend (based on their uid) from a user's friend document base
  //based on their UID.
  @override
  Future<void> removeFriend(String uid, String frienduid) async {
    firebaseDB.collection("friends").doc(uid).update({
      "frienduids": FieldValue.arrayRemove([frienduid])
    }).then((_) {
      firebaseDB.collection("friends").doc(frienduid).update({
        "frienduids": FieldValue.arrayRemove([uid])
      });
    });
  }

  //Adds a friend (based on their uid) from a user's friend document base
  //based on their UID.
  @override
  Future<void> addFriend(String uid, String frienduid) async {
    firebaseDB.collection("friends").doc(uid).update({
      "frienduids": FieldValue.arrayUnion([frienduid])
    }).then((_){
      firebaseDB.collection("friends").doc(frienduid).update({
        "frienduids": FieldValue.arrayUnion([uid])
      });
    });
  }

  
}