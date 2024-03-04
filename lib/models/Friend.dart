import 'package:cloud_firestore/cloud_firestore.dart';

class Friend{

  final String user_uid;
  late String friend_uid;

  Friend({required this.user_uid, this.friend_uid = ''});

  factory Friend.fromDB(DocumentSnapshot<Map<String,dynamic>> snapshot,
    SnapshotOptions? options,){
      final map = snapshot.data();
      return Friend(
        user_uid: map?['uid'],
        friend_uid: map?['frienduid'],
    );
  }

  Map<String, dynamic> toMap(){
    return{
      'uid': user_uid,
      'frienduid': friend_uid
    };
  }
}