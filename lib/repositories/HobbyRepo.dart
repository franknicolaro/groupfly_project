import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:groupfly_project/DAOs/HobbyDAO.dart';
import 'package:groupfly_project/models/Hobby.dart';

//Implementation of HobbyDAO
class HobbyRepo implements HobbyDao{
  //Instance of Firestore
  final FirebaseFirestore firebaseDB = FirebaseFirestore.instance;

  //List of selectable hobbies for registration.
  static final List<Hobby> _selectableHobbies = [
    Hobby(hobbyName: "Singing"),
    Hobby(hobbyName: "Dancing"),
    Hobby(hobbyName: "Football"),
    Hobby(hobbyName: "Soccer"),
    Hobby(hobbyName: "Baseball"),
    Hobby(hobbyName: "Basketball"),
    Hobby(hobbyName: "Bowling"),
    Hobby(hobbyName: "Hiking"),
    Hobby(hobbyName: "Frisbee"),
    Hobby(hobbyName: "Swimming"),
    Hobby(hobbyName: "Walking"),
    Hobby(hobbyName: "Exercising"),
    Hobby(hobbyName: "Cooking"),
    Hobby(hobbyName: "Painting"),
  ];

  //Inserts hobbies into the hobby collection.
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
  
  //Returns all selectable hobbies.
  @override
  List<Hobby> getAllHobbies() {
    return _selectableHobbies;
  }

}