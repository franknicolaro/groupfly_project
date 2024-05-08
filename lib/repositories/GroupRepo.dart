import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:groupfly_project/models/Group.dart';

import '../DAOs/GroupDAO.dart';

//Implementation of GroupDAO
class GroupRepo implements GroupDao{
  //Instance of Firestore
  final FirebaseFirestore firebaseDB = FirebaseFirestore.instance;

  //Creates and inserts a Group into the "group" collection.
  @override
  Future<void> createGroup(Group group) async {
    firebaseDB.collection('group').doc().set({
      'hobby': group.hobbyName,
      'is_active': group.isActive,
      'location': group.location,
      'max_capacity': group.maxCapacity,
      'meeting_time': group.meeting_time,
      'members': group.member_uids,
      'other_notes': group.notes,
      'owneruid': group.owner_uid,
      'title': group.title,
    }).onError((error, stackTrace) => "Error adding group to Firestore: $error");
  }

  //Get all groups that a user is a member of (regardless of ownership) 
  //based on the user's UID
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

  //Returns a Group based on a provided DocumentReference to that group.
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
  
  //Returns Groups based on the title of the group (for searching).
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
  
  //Removes a member from a group given on the Group's document ID
  @override
  Future<void> removeMember(String memberUID, String groupId)async {
    firebaseDB.collection('group').doc(groupId).update({
      'members': FieldValue.arrayRemove([memberUID])
    });
  }

  //Adds a member from a Group given on the Group's document ID
  @override
  Future<void> addMember(String memberUID, String groupId)async {
    firebaseDB.collection('group').doc(groupId).update({
      'members': FieldValue.arrayUnion([memberUID])
    });
  }

  //Disbands a Group at the given document ID
  @override
  Future<void> disbandGroup(String groupId)async {
    firebaseDB.collection('group').doc(groupId).update({
      'is_active': false
    });
  }
}