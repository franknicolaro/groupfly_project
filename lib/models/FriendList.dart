import 'package:cloud_firestore/cloud_firestore.dart';

//FriendList model (used with Friend functionality)
class FriendList{

  late String user_uid;
  late List<String> friend_uids;

  FriendList({required this.friend_uids});

  //Obtains data from a Firebase Snapshot and returns a FriendList object.
  factory FriendList.fromDB(DocumentSnapshot<Map<String,dynamic>> snapshot,
    SnapshotOptions? options,){
      final map = snapshot.data();
      return FriendList(
        friend_uids: map?['frienduids'],
    );
  }

  //Maps the current FriendList object to a map which would be passed through to a Repository
  Map<String, dynamic> toMap(){
    return{
      'frienduids': friend_uids
    };
  }
}