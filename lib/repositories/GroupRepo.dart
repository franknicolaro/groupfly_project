import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:groupfly_project/models/Group.dart';

import '../DAOs/GroupDAO.dart';
import '../services/authorization_service.dart';

class GroupRepo implements GroupDao{
  final FirebaseFirestore firebaseDB = FirebaseFirestore.instance;
  final _auth = Authorization();

  @override
  Future<List<Group>> getGroupsByMemberUID(String memberUID) async{
    CollectionReference groupCollection = firebaseDB.collection('group');
    List<Group> groups = [];
    print('getting groups...');
    await groupCollection.where('members', arrayContains: memberUID).get().then((result){
      if(result.docs.isNotEmpty){
        groups = List.generate(result.docs.length, (i){
          return Group(
            owner_uid: result.docs[i]['owneruid'],
            hobbyName: result.docs[i]['hobby'],
            location: result.docs[i]['location'],
            member_uids: result.docs[i]['members'],
            notes: result.docs[i]['other_notes'],
            title: result.docs[i]['title'],
          );
        });
      }
    });
    print('returning groups...');
    return groups;
  }
}