
import 'package:cloud_firestore/cloud_firestore.dart';

//Group model.
class Group{
  final String group_id;
  final String owner_uid;
  final String title;
  final String hobbyName;
  final String location;
  List<String> member_uids;
  final String notes;
  final DateTime meeting_time;
  bool isActive;
  final int maxCapacity;

  Group({required this.group_id, required this.owner_uid, required this.title, required this.hobbyName, required this.location, required this.notes, required this.member_uids, required this.meeting_time, required this.isActive, required this.maxCapacity});

  //Obtains data from a Firebase Snapshot and returns a Group object.
  factory Group.fromDB(DocumentSnapshot<Map<String, dynamic>> snapshot,
  SnapshotOptions? options,){
    final map = snapshot.data();
    return Group(
      group_id: snapshot.id,
      owner_uid: map?['owneruid'],
      title: map?['title'],
      hobbyName: map?['hobby'],
      location: map?['location'],
      notes: map?['other_notes'],
      member_uids: List.from(map?['members']),
      meeting_time: map?['meeting_time'].toDate(),
      isActive: map?['is_active'],
      maxCapacity: map?['max_capacity']
    );
  }
  
  //Maps the current Group object to a map which would be passed through to a Repository
  Map<String, dynamic> toMap(){
    return {
      'owneruid': owner_uid,
      'title': title,
      'hobby': hobbyName,
      'location': location,
      'other_notes': notes,
      'members': member_uids,
    };
  }
}