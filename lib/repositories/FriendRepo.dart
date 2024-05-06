import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:groupfly_project/DAOs/FriendDAO.dart';
import 'package:groupfly_project/models/FriendList.dart';

class FriendRepo implements FriendDao{
  final FirebaseFirestore firebaseDB = FirebaseFirestore.instance;

  @override
  Future<void> initFriendDocument(String uid) async{
    firebaseDB.collection("friends").doc(uid).set(
      {
        'frienduids': []
      }
    ).onError((error, stackTrace) => "Error: could not create friend document");
  }
  @override
  Future<FriendList> getFriendsByUID(String uid) async{
    print("getting friends by user uid...");
    CollectionReference friendCollection = firebaseDB.collection('friends');
    FriendList? friends;
    await friendCollection.doc(uid).get().then((snapshot) {
      friends = FriendList(
        friend_uids: List.from(snapshot.get('frienduids'))
      );
    });
    return friends!;
  }
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