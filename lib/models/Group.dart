
import 'package:cloud_firestore/cloud_firestore.dart';

class Group{
  final String owner_uid;
  late String title;
  late String hobbyName;
  late String location;
  late List<String>? member_uids;
  late String notes;

  Group({required this.owner_uid, this.title = '', this.hobbyName = '', this.location = '', this.notes = '', this.member_uids});

  factory Group.fromDB(DocumentSnapshot<Map<String, dynamic>> snapshot,
  SnapshotOptions? options,){
    final map = snapshot.data();
    return Group(
      owner_uid: map?['owneruid'],
      title: map?['title'],
      hobbyName: map?['hobby'],
      location: map?['location'],
      notes: map?['other_notes'],
      member_uids: map?['members'],
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