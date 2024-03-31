import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:groupfly_project/models/Group.dart';

import '../DAOs/GroupDAO.dart';

class GroupRepo implements GroupDao{
  final FirebaseFirestore firebaseDB = FirebaseFirestore.instance;

  @override
  Future<List<Group>> getGroupsByMemberUID(String memberUID) async{
    CollectionReference groupCollection = firebaseDB.collection('group');
    List<Group> groups = [];
    await groupCollection.where('members', arrayContains: memberUID).get().then((result){
      if(result.docs.isNotEmpty){
        groups = List.generate(result.docs.length, (i){
          return Group(
            group_id: result.docs[i].id,
            owner_uid: result.docs[i]['owneruid'],
            hobbyName: result.docs[i]['hobby'],
            location: result.docs[i]['location'],
            member_uids: List.from(result.docs[i]['members']),
            notes: result.docs[i]['other_notes'],
            title: result.docs[i]['title'],
            meeting_time: result.docs[i]['meeting_time'].toDate(),
            isActive: result.docs[i]['is_active'],
            maxCapacity: result.docs[i]['max_capacity']
          );
        });
      }
    });
    return groups;
  }
  @override
  Future<Group> getGroupByPostReference(DocumentReference groupRef) async{
    Group? result;
    final ref = groupRef.withConverter(
      fromFirestore: Group.fromDB, 
      toFirestore: (Group group, _) => group.toMap(),
    );
    final snapshot = await ref.get();
    result = snapshot.data();
    return result!;
  }
  
  @override
  Future<List<Group>> searchGroupsByName(String title) async{
    List<Group> groups = [];
    CollectionReference groupRef = firebaseDB.collection('group');
    await groupRef.where('title', isEqualTo: title).where('is_active', isEqualTo: true).get().then((result){
      if(result.docs.isNotEmpty){
        groups = List.generate(result.docs.length, (i){
          return Group(
            group_id: result.docs[i].id,
            owner_uid: result.docs[i]['owneruid'],
            title: result.docs[i]['title'],
            hobbyName: result.docs[i]['hobby'],
            location: result.docs[i]['location'],
            notes: result.docs[i]['other_notes'],
            member_uids: List.from(result.docs[i]['members']),
            meeting_time: result.docs[i]['meeting_time'].toDate(),
            isActive: result.docs[i]['is_active'],
            maxCapacity: result.docs[i]['max_capacity']
          );
        });
      }
    });
    return groups;
  }
}