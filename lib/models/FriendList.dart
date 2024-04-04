import 'package:cloud_firestore/cloud_firestore.dart';

class FriendList{

  final String user_uid;
  late List<String> friend_uids;

  FriendList({required this.user_uid, required this.friend_uids});

  factory FriendList.fromDB(DocumentSnapshot<Map<String,dynamic>> snapshot,
    SnapshotOptions? options,){
      final map = snapshot.data();
      return FriendList(
        user_uid: map?['uid'],
        friend_uids: map?['frienduid'],
    );
  }

  Map<String, dynamic> toMap(){
    return{
      'uid': user_uid,
      'frienduid': friend_uids
    };
  }
}