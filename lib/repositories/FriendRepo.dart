import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:groupfly_project/DAOs/FriendDAO.dart';
import 'package:groupfly_project/models/FriendList.dart';

import '../services/authorization_service.dart';

class FriendRepo implements FriendDao{
  final FirebaseFirestore firebaseDB = FirebaseFirestore.instance;
  final _auth = Authorization();

  @override
  Future<FriendList> getFriendsByUID(String uid) async{
    print("getting friends by user uid...");
    CollectionReference friendCollection = firebaseDB.collection('friends');
    List<FriendList> friends = [];
    await friendCollection.where('uid', isEqualTo: uid).get().then((result) {
      if(result.docs.isNotEmpty){
        friends = List.generate(result.docs.length, (i) {
          return FriendList(
            friend_uids: List.from(result.docs[i]['frienduids']), 
            user_uid: uid
          );
        });
      }
    },);
    print("Number of friends:");
    print(friends.length);
    return friends[0];
  }
  
  
}