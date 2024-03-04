import 'package:cloud_firestore/cloud_firestore.dart';

class Hobby{
  String hobbyName;
  late String? uid;

  Hobby({required this.hobbyName, String uid =""});

  void setUid(String newUid){
    uid = newUid;
  }

  factory Hobby.fromDB(DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,){
      final map = snapshot.data();
      return Hobby(
        hobbyName: map?['hobby_name'],
        uid: map?['uid'],
      );
    }  

  Map<String, dynamic> toMap(){
    return {
      'hobby_name': hobbyName,
      'uid': uid,
    };
  }
}