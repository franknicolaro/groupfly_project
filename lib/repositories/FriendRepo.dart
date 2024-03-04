import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:groupfly_project/DAOs/FriendDAO.dart';
import 'package:groupfly_project/models/Friend.dart';

import '../services/authorization_service.dart';

class FriendRepo implements FriendDao{
  final FirebaseFirestore firebaseDB = FirebaseFirestore.instance;
  final _auth = Authorization();

  @override
  Future<List<Friend>> getFriendsByUID(String uid) async{
    CollectionReference friendCollection = firebaseDB.collection('friends');
    List<Friend> friends = [];
    await friendCollection.where('uid', isEqualTo: _auth.currentUser!.uid).get().then((result){
      if(result.docs.isNotEmpty){
        friends = List.generate(result.docs.length, (i){
          return Friend(
            user_uid: uid,
            friend_uid: result.docs[i]['frienduid']
          );
        });
      }
    });
    return friends;
  }
  
  
}