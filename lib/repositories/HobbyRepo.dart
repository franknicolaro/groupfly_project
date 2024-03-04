import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:groupfly_project/DAOs/HobbyDAO.dart';
import 'package:groupfly_project/models/Hobby.dart';
import 'package:groupfly_project/services/authorization_service.dart';

class HobbyRepo implements HobbyDao{
  final FirebaseFirestore firebaseDB = FirebaseFirestore.instance;
  final _auth = Authorization();

  @override
  Future<void> insertHobbies(List<Hobby> selectedHobbies) {
    var batch = firebaseDB.batch();
    CollectionReference hobbies = firebaseDB.collection('hobbies');
    selectedHobbies.forEach((hobby) {
      var docRef = hobbies.doc();
      batch.set(docRef, {
        'uid': hobby.uid,
        'hobby_name': hobby.hobbyName,
      });
    });
    return batch.commit().catchError((error) => print("Error occurred while commiting the batch of hobbies: $error"));
  }
}