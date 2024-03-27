
import 'package:cloud_firestore/cloud_firestore.dart';

class Group{
  final String group_id;
  final String owner_uid;
  final String title;
  final String hobbyName;
  final String location;
  final List<String> member_uids;
  final String notes;
  final DateTime meeting_time;

  Group({required this.group_id, required this.owner_uid, required this.title, required this.hobbyName, required this.location, required this.notes, required this.member_uids, required this.meeting_time});

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
    );
  }
  
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