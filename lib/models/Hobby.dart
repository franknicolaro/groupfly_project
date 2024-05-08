import 'package:cloud_firestore/cloud_firestore.dart';

//Hobby model
class Hobby{
  String hobbyName;
  late String? uid;

  Hobby({required this.hobbyName, String uid =""});

  void setUid(String newUid){
    uid = newUid;
  }

  //Obtains data from a Firebase Snapshot and returns a Hobby object.
  factory Hobby.fromDB(DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,){
      final map = snapshot.data();
      return Hobby(
        hobbyName: map?['hobby_name'],
        uid: map?['uid'],
      );
    }  

  //Maps the current Hobby object to a map which would be passed through to a Repository
  Map<String, dynamic> toMap(){
    return {
      'hobby_name': hobbyName,
      'uid': uid,
    };
  }
}