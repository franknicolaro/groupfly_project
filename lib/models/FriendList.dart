import 'package:cloud_firestore/cloud_firestore.dart';

class FriendList{

  late String user_uid;
  late List<String> friend_uids;

  FriendList({required this.friend_uids});

  factory FriendList.fromDB(DocumentSnapshot<Map<String,dynamic>> snapshot,
    SnapshotOptions? options,){
      final map = snapshot.data();
      return FriendList(
        friend_uids: map?['frienduids'],
    );
  }

  Map<String, dynamic> toMap(){
    return{
      'frienduids': friend_uids
    };
  }
}